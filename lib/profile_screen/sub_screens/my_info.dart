import 'dart:io';
import 'package:bakeryadminapp/profile_screen/controllers/my_info_controller.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:bakeryadminapp/widgets/buttons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MyInfoScreen extends StatefulWidget {
  const MyInfoScreen({super.key});

  @override
  State<MyInfoScreen> createState() => _MyInfoScreenState();
}

class _MyInfoScreenState extends State<MyInfoScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  XFile? image;
  bool isLoading = true;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        
        setState(() {
          nameController.text = userData['name'] ?? "";
          emailController.text = userData['email'] ?? "";
          
          final MyInfoController controller = Get.find<MyInfoController>();
          controller.namecontroller.text = nameController.text;
          controller.emailcontroller.text = emailController.text;
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error loading user data: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  void _pickImage() async {
    try {
      image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {});
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _saveUserData() async {
    if (!formkey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final MyInfoController controller = Get.find<MyInfoController>();
    
      Map<String, dynamic> updateData = {
        "name": controller.namecontroller.text,
        "email": controller.emailcontroller.text,
      };
      if (image != null) {
        final file = File(image!.path);
        final metadata = SettableMetadata(contentType: "image/jpeg");
        final storageRef = FirebaseStorage.instance.ref();
        final uploadTask = storageRef
            .child("images/${DateTime.now().millisecondsSinceEpoch}_${image!.name}")
            .putFile(file, metadata);

        TaskSnapshot taskSnapshot = await uploadTask;
        String url = await taskSnapshot.ref.getDownloadURL();
        
        updateData["imageurl"] = url;
      }

      await FirebaseFirestore.instance
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(updateData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Color(0xff1B4332),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Error updating user data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error updating profile: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildProfileImage() {
    final userImage = image != null
        ? FileImage(File(image!.path)) as ImageProvider
        : null;

    return Stack(
      children: [
        Container(
          width: 100.h,
          height: 100.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
            image: userImage != null
                ? DecorationImage(
                    image: userImage,
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: userImage == null
              ? Icon(
                  Icons.person,
                  size: 35.sp,
                  color: const Color(0xff1B4332),
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
            onTap: _pickImage,
            child: Container(
              height: 32.h,
              width: 32.w,
              decoration: BoxDecoration(
                color: const Color(0xff1B4332),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  size: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MyInfoController>(
        builder: (obj) {
          obj.namecontroller = nameController;
          obj.emailcontroller = emailController;
          
          return Container(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            color: const Color(0xffEEEEE6),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1B4332),
                    ),
                  )
                : Form(
                    key: formkey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 55.h),
                          AppBarClass(
                            text: "My Infos",
                            color: const Color(0xff20402A),
                            iconcolor: const Color(0xff1B4332),
                          ),
                          SizedBox(height: 30.h),
                          
                          Center(child: _buildProfileImage()),
                          SizedBox(height: 30.h),
                          TextFormFieldWidget(
                            onChanged: (v) {
                              setState(() {});
                            },
                            textEditingController: obj.namecontroller,
                            text: "Name",
                            width: 319.w,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter Name";
                              }
                              return null;
                            },
                            align: TextAlign.start,
                            Fontsize: 16.sp,
                          ),
                          SizedBox(height: 20.h),
                          TextFormFieldWidget(
                            onChanged: (v) {
                              setState(() {});
                            },
                            textEditingController: obj.emailcontroller,
                            text: "Email",
                            width: 319.w,
                            validator: (value) {
                              bool emailValidator = RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value!);
                              if (value.isEmpty) {
                                return "Please enter Email";
                              }
                              if (!emailValidator) {
                                return "Please enter valid Email";
                              }
                              return null;
                            },
                            align: TextAlign.start,
                            Fontsize: 16.sp,
                          ),
                          SizedBox(height: 30.h),
                          CustomButtons(
                            borderRadius: 7.78.r,
                            width: 319.w,
                            height: 45.h,
                            backcolor: const Color(0xff1B4332),
                            onPressed: _saveUserData,
                            child: ButtonText(
                              color: const Color(0xffFBFBF0),
                              text: 'Save Changes',
                              Font: FontWeight.w600,
                              fontsize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}