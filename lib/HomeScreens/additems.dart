import 'dart:io';
import 'package:bakeryadminapp/bottom_bar/bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bakeryadminapp/widgets/buttons.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';

class ItemController extends GetxController {
  final nameController = TextEditingController();
  final desController = TextEditingController();
  final priceController = TextEditingController();
  final categoryController = TextEditingController();
  final quantityController = TextEditingController(); // New quantity controller

  bool isLoading = false;
  bool isclicked = true;
  String? selectedCategory;

  final imagesList = <File>[].obs;
  final uploadedImageUrls = <String>[].obs;

  String get currentAdminId {
    return FirebaseAuth.instance.currentUser?.uid ?? '';
  }

  void setCategory(String category) {
    selectedCategory = category;
    categoryController.text = category;
    update();
  }

  Future<void> uploadImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();
    if (pickedImages.isNotEmpty) {
      for (var image in pickedImages) {
        imagesList.add(File(image.path));
      }
    }
  }

  void deleteImage(int index) {
    if (index >= 0 && index < imagesList.length) {
      imagesList.removeAt(index);
    }
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> urls = [];

    try {
      for (var imageFile in imagesList) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${(imageFile.path)}';
        final storageRef =
            FirebaseStorage.instance.ref().child('items/$fileName');

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

  Future<void> addItem(BuildContext context) async {
    try {
      isLoading = true;
      update(['saveFunctionID']);

      // Validate input fields
      if (nameController.text.isEmpty ||
          desController.text.isEmpty ||
          priceController.text.isEmpty ||
          quantityController.text.isEmpty ||  // Validate quantity
          selectedCategory == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')),
        );
        isLoading = false;
        update(['saveFunctionID']);
        return;
      }

      // Validate admin is logged in
      if (currentAdminId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Admin authentication required')),
        );
        isLoading = false;
        update(['saveFunctionID']);
        return;
      }

      // Upload images
      List<String> imageUrls = [];
      if (imagesList.isNotEmpty) {
        imageUrls = await uploadImagesToStorage();

        if (imageUrls.isEmpty) {
          // Handle image upload failure if needed
        }
      }

      // Generate new item ID
      final itemId = const Uuid().v4();

      // Create item model
      final newItem = ItemModel(
        uid: itemId,
        itemName: nameController.text.trim(),
        itemDescription: desController.text.trim(),
        itemPrice: priceController.text.trim(),
        itemCategory: selectedCategory!,
        quantity: int.parse(quantityController.text.trim()), // Add quantity
        allowNotifications: isclicked,
        imageUrl: imageUrls.isNotEmpty ? imageUrls.join(',') : '',
        visibility: true,
        createdAt: Timestamp.now(),
        adminId: currentAdminId, // Add adminId to item
      );

      // Add item to Firestore
      await FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .set(newItem.toMap());

      // Update admin's items array
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentAdminId)
          .set({
        'items': FieldValue.arrayUnion([itemId])
      }, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item added successfully')),
      );
      clearFields();
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const BottomBarScreen()));
    } catch (e) {
      print('Error adding item: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding item: ${e.toString()}')),
      );
    } finally {
      isLoading = false;
      update(['saveFunctionID']);
    }
  }

  void clearFields() {
    nameController.clear();
    desController.clear();
    priceController.clear();
    categoryController.clear();
    quantityController.clear(); // Clear quantity
    selectedCategory = null;
    imagesList.clear();
    update();
  }

  @override
  void onClose() {
    nameController.dispose();
    desController.dispose();
    priceController.dispose();
    categoryController.dispose();
    quantityController.dispose(); // Dispose quantity controller
    super.onClose();
  }
}

class ItemModel {
  final String uid;
  final String itemName;
  final String itemDescription;
  final String itemPrice;
  final String itemCategory;
  final int quantity; // Add quantity field
  final bool allowNotifications;
  final String imageUrl;
  final bool visibility;
  final Timestamp createdAt;
  final String adminId;

  ItemModel({
    required this.uid,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemCategory,
    required this.quantity, // Make quantity required
    required this.allowNotifications,
    required this.imageUrl,
    this.visibility = true,
    required this.createdAt,
    required this.adminId,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'itemName': itemName,
      'itemDescription': itemDescription,
      'itemPrice': itemPrice,
      'itemCategory': itemCategory,
      'quantity': quantity, // Include quantity in map
      'allowNotifications': allowNotifications,
      'imageUrl': imageUrl,
      'visibility': visibility,
      'createdAt': createdAt,
      'adminId': adminId,
    };
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
  final List<TextInputFormatter>? inputFormatters; // Add input formatters parameter

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
    this.inputFormatters, // Add to constructor
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
            keyboardType:label=='Quantity'? TextInputType.number:TextInputType.name,
            controller: controller,
            validator: validator,
            onChanged: onChanged,
            textAlign: textAlign,
            inputFormatters: inputFormatters, // Add input formatters
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

class ImageUploadWidget extends StatelessWidget {
  final ItemController controller;

  const ImageUploadWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Image",
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xff898A8D),
          ),
        ),
        SizedBox(height: 12.h),
        InkWell(
          onTap: () => controller.uploadImages(),
          child: Container(
            height: 139.h,
            width: 333.w,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xffE5E5E5),
                width: 1.5,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 26.sp,
                  color: const Color(0xffA3A3A3),
                ),
                SizedBox(height: 18.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Click to upload ",
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "or drag and drop",
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xff898A8D),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  "JPG, JPEG, PNG less than 1MB",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xff898A8D),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 13.h),
        Obx(() => Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xffE5E5E5),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 90.h,
                    crossAxisCount: 3,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                  ),
                  itemCount: controller.imagesList.length + 1,
                  itemBuilder: (context, i) {
                    return controller.imagesList.length == i
                        ? Align(
                            alignment: Alignment.topCenter,
                            child: InkWell(
                              onTap: () => controller.uploadImages(),
                              child: Container(
                                height: 80.h,
                                width: 96.w,
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color(0xffE5E5E5),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.add_circle,
                                    color: const Color(0xffA3A3A3),
                                    size: 22.sp,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 80.h,
                            width: 96.w,
                            child: Stack(
                              children: [
                                Container(
                                  height: 80.h,
                                  width: 96.w,
                                  margin: EdgeInsets.only(right: 10.w),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: const Color(0xffE5E5E5),
                                      width: 1.5,
                                    ),
                                    borderRadius: BorderRadius.circular(20.r),
                                    image: DecorationImage(
                                      image: FileImage(
                                          File(controller.imagesList[i].path)),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 20,
                                  child: InkWell(
                                    onTap: () => controller.deleteImage(i),
                                    child: Container(
                                      padding: EdgeInsets.all(4.w),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 9.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                  }),
            )),
      ],
    );
  }
}

class NotificationToggle extends StatelessWidget {
  final ItemController controller;

  const NotificationToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Allow Notifications",
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xff898A8D),
          ),
        ),
        Row(
          children: [
            Row(
              children: [
                Radio(
                  activeColor: AppColors.primaryColor,
                  value: true,
                  groupValue: controller.isclicked,
                  onChanged: (val) {
                    controller.isclicked = true;
                    controller.update();
                  },
                ),
                Text(
                  'Yes',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
            Row(
              children: [
                Radio(
                  activeColor: AppColors.primaryColor,
                  value: false,
                  groupValue: controller.isclicked,
                  onChanged: (val) {
                    controller.isclicked = false;
                    controller.update();
                  },
                ),
                Text(
                  'No',
                  style: TextStyle(fontSize: 14.sp),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final formKey = GlobalKey<FormState>();
  final ItemController controller = Get.put(ItemController());

  final _categories = [
    "Bread",
    "Cake",
    "Pastry",
    "Cookie",
    "Muffin",
    "Croissant",
    "Danish",
    "Donut",
    "Cupcake",
    "Pie"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ItemController>(builder: (controller) {
        return SingleChildScrollView(
          child: Container(
            color: const Color(0xffEEEEE6),
            child: Column(
              children: [
                SizedBox(
                  height: 50.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 21.w),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Add New Listing",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff20402A),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 20.h),
                        TextFormFieldWithLabel(
                          label: "Item Name",
                          controller: controller.nameController,
                          validator: (value) =>
                              value!.isEmpty ? "Please Enter Item Name" : null,
                          width: 335.w,
                          fontSize: 14.sp,
                          onChanged: (_) {},
                        ),
                        SizedBox(height: 13.h),
                        TextFormFieldWithLabel(
                          label: "Description",
                          controller: controller.desController,
                          validator: (value) => value!.isEmpty
                              ? "Please Enter Description"
                              : null,
                          width: 335.w,
                          fontSize: 14.sp,
                          onChanged: (_) {},
                        ),
                        SizedBox(height: 13.h),
                        TextFormFieldWithLabel(
                          label: "Price",
                          controller: controller.priceController,
                          validator: (value) =>
                              value!.isEmpty ? "Please Enter Price" : null,
                          width: 335.w,
                          fontSize: 14.sp,
                          onChanged: (_) {},
                        ),
                        SizedBox(height: 13.h),
                        TextFormFieldWithLabel(
                          label: "Category",
                          controller: controller.categoryController,
                          validator: (value) =>
                              value!.isEmpty ? "Please Select Category" : null,
                          width: 335.w,
                          fontSize: 14.sp,
                          onChanged: (_) {},
                          suffixIcon: DropdownButton<String>(
                            icon: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: Color(0xff666666),
                              ),
                            ),
                            isExpanded: true,
                            hint: Text(
                              '',
                              style: TextStyle(color: AppColors.primaryColor),
                            ),
                            value: controller.selectedCategory,
                            isDense: true,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.setCategory(newValue);
                              }
                            },
                            items: _categories.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 13.h),
                        // New Quantity Field
                        TextFormFieldWithLabel(
                          label: "Quantity",
                          controller: controller.quantityController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Quantity";
                            }
                            if (int.tryParse(value) == null) {
                              return "Quantity must be a number";
                            }
                            return null;
                          },
                          width: 335.w,
                          fontSize: 14.sp,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ], // Only allow digits
                          onChanged: (_) {},
                        ),
                        SizedBox(height: 13.h),
                        NotificationToggle(controller: controller),
                        SizedBox(height: 19.h),
                        ImageUploadWidget(controller: controller),
                        SizedBox(height: 25.h),
                        SizedBox(
                          width: 333.w,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GetBuilder<ItemController>(
                                  id: 'saveFunctionID',
                                  builder: (controller) {
                                    return CustomButtons(
                                      borderRadius: 7.78.r,
                                      width: 155.w,
                                      height: 36.27.h,
                                      onPressed: () {
                                        if (formKey.currentState!.validate()) {
                                          controller.addItem(context);
                                        }
                                      },
                                      backcolor: AppColors.primaryColor,
                                      child: controller.isLoading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white)
                                          : Text(
                                              "Save",
                                              style: TextStyle(
                                                  fontSize: 13.64.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xffFBFBF0)),
                                            ),
                                    );
                                  }),
                              CustomButtons(
                                borderRadius: 7.78.r,
                                width: 155.w,
                                height: 36.27.h,
                                onPressed: () => controller.clearFields(),
                                backcolor: AppColors.primaryColor,
                                child: Text(
                                  "Cancel",
                                  style: TextStyle(
                                      fontSize: 13.64.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xffFBFBF0)),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}