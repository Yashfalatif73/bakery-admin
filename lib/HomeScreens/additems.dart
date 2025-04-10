import 'dart:io';

import 'package:bakeryadminapp/HomeScreens/controllers/itemadd_cont.dart';
import 'package:bakeryadminapp/models/usermodel.dart';
import 'package:bakeryadminapp/models/usermodel.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:bakeryadminapp/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddItemsScreen extends StatefulWidget {
  const AddItemsScreen({super.key});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  TextEditingController itemNameController = TextEditingController();
  AddItemController ctrl = Get.put(AddItemController());
GlobalKey<FormState> formkey = GlobalKey<FormState>();
  var _CategorySelectedValue;
  var _categories = [
    "Cake",
    "Pizza",
    "Lasania",
    "Muffins",
  ];

  get state => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<AddItemController>(builder: (obj) {
      return SingleChildScrollView(
        child: Container(
          color: Color(0xffEEEEE6),
          child: Column(
            children: [
              TopNavBarClass(),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 21, right: 21),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Expanded(
                    child: Container(
                      color: Color(0xffEEEEE6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Add New Listing",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff20402A),
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          TextFormFieldForListings(
                            onChanged: (v) {},
                            textEditingController: obj.nameController,
                            text: "Item Name",
                            width: 335.w,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Item Name";
                              }
                              return null;
                            },
                            align: TextAlign.start,
                            Fontsize: 14.sp,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          TextFormFieldForListings(
                            onChanged: (v) {},
                            textEditingController: obj.desController,
                            text: "Description",
                            width: 335.w,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Description";
                              }
                              return null;
                            },
                            align: TextAlign.start,
                            Fontsize: 14.sp,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          TextFormFieldForListings(
                            onChanged: (v) {},
                            textEditingController: obj.priceController,
                            text: "Price",
                            width: 335.w,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Enter Price";
                              }
                              return null;
                            },
                            align: TextAlign.start,
                            Fontsize: 14.sp,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          TextFormFieldForListings(
                            onChanged: (v) {},
                            textEditingController: obj.categoryController,
                            text: "Category",
                            width: 335.w,
                            suffixicon: DropdownButton<String>(
                              icon: Padding(
                                padding: const EdgeInsets.all(10.0),
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
                              value: _CategorySelectedValue,
                              isDense: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _CategorySelectedValue = newValue;
                                  // state.didChange(newValue);
                                });
                              },
                              items: _categories.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please Select Category";
                              }
                              return null;
                            },
                            align: TextAlign.start,
                            Fontsize: 14.sp,
                          ),
                          SizedBox(
                            height: 13.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 27.w,
                              ),
                              Text(
                                "Allow Notifications",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Color(0xff898A8D),
                                ),
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Radio(
                                        activeColor: AppColors.primaryColor,
                                        value: obj.isclicked,
                                        groupValue: true,
                                        onChanged: (val) {
                                          setState(() {
                                            obj.isclicked = true;
                                          });
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
                                        value: obj.isclicked,
                                        groupValue: false,
                                        onChanged: (val) {
                                          setState(() {
                                            obj.isclicked = false;
                                          });
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
                          ),
                          SizedBox(
                            height: 19.h,
                          ),
                          Text(
                            "Image",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Color(0xff898A8D),
                            ),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          SizedBox(height: 13.h),
                          InkWell(
                            onTap: () {
                              ctrl.uploadImages(); // Trigger image upload
                            },
                            child: Container(
                              height: 139.h,
                              width: 333.w,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xffE5E5E5),
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
                                    color: Color(0xffA3A3A3),
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
                                          color: Color(0xff898A8D),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "JPG, JPEG, PNG less than 1MB",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Color(0xff898A8D),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 13.h),
                          Obx(() => Container(
                            // height: 100.h,
                                decoration: BoxDecoration(
                                  //color: Colors.red,
                                  border: Border.all(
                                    color: Color(0xffE5E5E5),
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                child: GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          mainAxisExtent: 90.h,
                                      crossAxisCount:
                                          3, // number of items in each row
                                      mainAxisSpacing:
                                          8.0, // spacing between rows
                                      crossAxisSpacing:
                                          8.0, // spacing between columns
                                    ),
                                    itemCount: ctrl.imagesList.length + 1,
                                    itemBuilder: (context, i) {
                                      return ctrl.imagesList.length == i
                                          ? Align(
                                              alignment: Alignment.topCenter,
                                              child: Container(
                                                height: 80.h,
                                                width: 96.w,
                                                margin: EdgeInsets.only(
                                                    right: 10.w),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Color(0xffE5E5E5),
                                                    width: 1.5,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          24.r),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.add_circle,
                                                    color: Color(0xffA3A3A3),
                                                    size: 22.sp,
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              height: 80.h,
                                              width: 96.w,
                                              child: Stack(
                                                children: [
                                                  Container(
                                                    height: 80.h,
                                                    width: 96.w,
                                                    margin: EdgeInsets.only(
                                                        right: 10
                                                            .w), // Add spacing between boxes
                                                    decoration: BoxDecoration(
                                                      border: Border.all(
                                                        color:
                                                            Color(0xffE5E5E5),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      image: DecorationImage(
                                                        image: FileImage(File(ctrl
                                                            .imagesList[i]
                                                            .path)), // Display the image
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  // Delete button
                                                  Positioned(
                                                    top: 10,
                                                    right: 20,
                                                    child: InkWell(
                                                      onTap: () {
                                                        ctrl.deleteImage(
                                                            i); // Remove the image at index i
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(4.w),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.5),
                                                          shape:
                                                              BoxShape.circle,
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
                          SizedBox(
                            height: 25.h,
                          ),
                          Container(
                            width: 333.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GetBuilder<AddItemController>(
                      id: 'saveFunctionID',
                      builder: (obj) {
                                    return CustomButtons(
                                        borderRadius: 7.78.r,
                                        child: Text(
                                          "Save",
                                          style: TextStyle(
                                              fontSize: 13.64.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xffFBFBF0)),
                                        ),
                                        width: 155.w,
                                        height: 36.27.h,
                                        onPressed: () {
                                          //db ma upload phe uska url get hoga or phr wo save hoga

                                           if (obj.image != null) {
              final file = File(obj.image!.path);

// Create the file metadata
              final metadata = SettableMetadata(contentType: "image/jpeg");
              final storageRef = FirebaseStorage.instance.ref();
              final uploadTask = storageRef
                  .child("images/${obj.image!.name}")
                  .putFile(file, metadata);

              uploadTask.snapshotEvents
                  .listen((TaskSnapshot taskSnapshot) async {
                String url = await taskSnapshot.ref.getDownloadURL();
                AddItemController.obj.UserModel!.imageurl = url;
                FirebaseFirestore.instance
                    .collection("additem")
                    .doc(AddItemController.obj.userModel!.id)
                    .update({
                  "imageurl": url,
                });
              });
            }
                                           if (formkey.currentState!.validate()) {
                                    obj.additem(
                                        UserModel(
                                          name: obj.nameController.text,
                                          des: obj.desController.text,
                                          id: Uuid().v4(),
                                          price:obj.priceController.text,
                                          catg: obj.priceController.text,
                                          allownotification: obj.isclicked,



                                          imageurl:obj.image.toString()
                                        ),
                                        context);
                                                                  }
                                          if (_CategorySelectedValue != null &&
                                              itemNameController.text.isNotEmpty) {
                                            print(
                                                'Item Name: ${itemNameController.text}');
                                            print(
                                                'Selected Category: $_categories');
                                          } else {
                                            print('Please fill all fields');
                                          }
                                        },
                                        backcolor: AppColors.primaryColor);
                                  }
                                ),
                                CustomButtons(
                                    borderRadius: 7.78.r,
                                    child: Text(
                                      "Cancel",
                                      style: TextStyle(
                                          fontSize: 13.64.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xffFBFBF0)),
                                    ),
                                    width: 155.w,
                                    height: 36.27.h,
                                    onPressed: () {},
                                    backcolor: AppColors.primaryColor),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 50.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }));
  }
}
