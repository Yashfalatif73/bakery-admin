import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditItemController extends GetxController {
  final nameController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool allowNotifications = true.obs;
  final RxString selectedCategory = ''.obs;
  final RxBool isImageLoading = false.obs;
  
  final RxList<File> imagesList = <File>[].obs;
  final RxList<String> existingImageUrls = <String>[].obs;
  final RxList<String> imagesToDelete = <String>[].obs;

  late String itemId;

  final List<String> categories = ["Cake", "Pizza", "Lasania", "Muffins"];

  void initWithItemId(String id) {
    itemId = id;
    loadItemData();
  }

  Future<void> loadItemData() async {
    isLoading.value = true;
    try {
      final DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        nameController.text = data['itemName'] ?? '';
        desController.text = data['itemDescription'] ?? '';
        priceController.text = data['itemPrice'] ?? '';
        selectedCategory.value = data['itemCategory'] ?? '';
        categoryController.text = data['itemCategory'] ?? '';
        allowNotifications.value = data['allowNotifications'] ?? true;
        if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty) {
          existingImageUrls.value = data['imageUrl'].toString().split(',');
        }
      }
    } catch (e) {
      print('Error loading item data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    categoryController.text = category;
  }

  Future<void> uploadImages() async {
    try {
      final pickedImages = await ImagePicker().pickMultiImage();
      if (pickedImages.isNotEmpty) {
        for (var image in pickedImages) {
          imagesList.add(File(image.path));
        }
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  void deleteNewImage(int index) {
    if (index >= 0 && index < imagesList.length) {
      imagesList.removeAt(index);
    }
  }

  void deleteExistingImage(int index) {
    if (index >= 0 && index < existingImageUrls.length) {
      final urlToDelete = existingImageUrls[index];
      imagesToDelete.add(urlToDelete);
      existingImageUrls.removeAt(index);
    }
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> urls = [];
    try {
      for (var imageFile in imagesList) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        final storageRef = FirebaseStorage.instance.ref().child('items/$fileName');
        final uploadTask = storageRef.putFile(
          imageFile,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        await uploadTask.whenComplete(() {});
        final downloadUrl = await storageRef.getDownloadURL();
        urls.add(downloadUrl);
      }
      return urls;
    } catch (e) {
      print('Error uploading images: $e');
      return [];
    }
  }

  Future<void> updateItem(BuildContext context) async {
    try {
      isLoading.value = true;

      if (nameController.text.isEmpty ||
          desController.text.isEmpty ||
          priceController.text.isEmpty ||
          selectedCategory.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')),
        );
        return;
      }

      List<String> allImageUrls = [...existingImageUrls];
      if (imagesList.isNotEmpty) {
        final newUrls = await uploadImagesToStorage();
        allImageUrls.addAll(newUrls);
      }

      await FirebaseFirestore.instance.collection('items').doc(itemId).update({
        'itemName': nameController.text.trim(),
        'itemDescription': desController.text.trim(),
        'itemPrice': priceController.text.trim(),
        'itemCategory': selectedCategory.value,
        'allowNotifications': allowNotifications.value,
        'imageUrl': allImageUrls.join(','),
        'updatedAt': Timestamp.now(),
      });

      for (String urlToDelete in imagesToDelete) {
        try {
          final ref = FirebaseStorage.instance.refFromURL(urlToDelete);
          await ref.delete();
        } catch (e) {
          print('Error deleting image from storage: $e');
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item updated successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      print('Error updating item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating item: $e')),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    desController.dispose();
    priceController.dispose();
    categoryController.dispose();
    super.onClose();
  }
}

class EditItemScreen extends StatelessWidget {
  final String itemId;
  EditItemScreen({Key? key, required this.itemId}) : super(key: key);

  final EditItemController controller = Get.put(EditItemController());

  @override
  Widget build(BuildContext context) {
    controller.initWithItemId(itemId);

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Container(
            color: const Color(0xffEEEEE6),
            child: Column(
              children: [
                SizedBox(height: 50.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21.w),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildScreenTitle(),
                        SizedBox(height: 20.h),
                        _buildNameField(),
                        SizedBox(height: 13.h),
                        _buildDescriptionField(),
                        SizedBox(height: 13.h),
                        _buildPriceField(),
                        SizedBox(height: 13.h),
                        _buildCategoryField(),
                        SizedBox(height: 13.h),
                        _buildNotificationToggle(),
                        SizedBox(height: 19.h),
                        _buildImageUploadSection(),
                        SizedBox(height: 25.h),
                        _buildActionButtons(context),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildScreenTitle() {
    return const Text(
      "Edit Item",
      style: TextStyle(
        fontSize: 18,
        color: Color(0xff20402A),
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormFieldWithLabel(
      label: "Item Name",
      controller: controller.nameController,
      width: 335.w,
      fontSize: 14.sp,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormFieldWithLabel(
      label: "Description",
      controller: controller.desController,
      width: 335.w,
      fontSize: 14.sp,
    );
  }

  Widget _buildPriceField() {
    return TextFormFieldWithLabel(
      label: "Price",
      controller: controller.priceController,
      width: 335.w,
      fontSize: 14.sp,
    );
  }

  Widget _buildCategoryField() {
    return TextFormFieldWithLabel(
      label: "Category",
      controller: controller.categoryController,
      width: 335.w,
      fontSize: 14.sp,
      suffixIcon: DropdownButton<String>(
        icon: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xff666666)),
        ),
        isExpanded: true,
        value: controller.selectedCategory.value.isEmpty ? null : controller.selectedCategory.value,
        onChanged: (String? newValue) {
          if (newValue != null) {
            controller.setCategory(newValue);
          }
        },
        items: controller.categories.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Allow Notifications",
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.black,
          ),
        ),
        Obx(() => Switch(
              value: controller.allowNotifications.value,
              onChanged: (bool value) {
                controller.allowNotifications.value = value;
              },
            )),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Images", style: TextStyle(fontSize: 14.sp, color: Colors.black)),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          children: [
            ...controller.existingImageUrls.map((url) => Stack(
                  children: [
                    Image.network(url, width: 70.w, height: 70.h, fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.deleteExistingImage(controller.existingImageUrls.indexOf(url));
                        },
                        child: const Icon(Icons.close, color: Colors.red, size: 18),
                      ),
                    ),
                  ],
                )),
            ...controller.imagesList.map((file) => Stack(
                  children: [
                    Image.file(file, width: 70.w, height: 70.h, fit: BoxFit.cover),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.deleteNewImage(controller.imagesList.indexOf(file));
                        },
                        child: const Icon(Icons.close, color: Colors.red, size: 18),
                      ),
                    ),
                  ],
                )),
            GestureDetector(
              onTap: controller.uploadImages,
              child: Container(
                width: 70.w,
                height: 70.h,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.grey),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return 
    GestureDetector(
      onTap: () => controller.updateItem(context),
      child: Container(
        width: 335.w,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.green[800],
          borderRadius: BorderRadius.circular(12)
        ),
        child: const Center(child: Text('Update Item',style: TextStyle(color: Colors.white),),),
      ),
    );
    // CustomButton(
    //   text: "Update Item",
    //   onPressed: () => controller.updateItem(context),
    //   width: 335.w,
    // );
  }
}


class TextFormFieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final double width;
  final TextAlign textAlign;
  final double fontSize;
  final void Function(String)? onChanged;

  const TextFormFieldWithLabel({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.suffixIcon,
    required this.width,
    this.textAlign = TextAlign.start,
    required this.fontSize,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: const Color(0xff898A8D),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: const Color(0xffE5E5E5), width: 1.5),
          ),
          child: TextFormField(
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            textAlign: textAlign,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
