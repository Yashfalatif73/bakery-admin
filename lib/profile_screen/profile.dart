import 'package:bakeryadminapp/Auth/signin.dart';
import 'package:bakeryadminapp/profile_screen/controllers/splash_controller.dart';
import 'package:bakeryadminapp/profile_screen/sub_screens/change_password.dart';
import 'package:bakeryadminapp/profile_screen/sub_screens/my_info.dart';
import 'package:bakeryadminapp/profile_screen/sub_screens/settings_screen.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:bakeryadminapp/widgets/clipper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String username = "";
  bool isLoading = true;

  List<String> tabs = [
    "My Info",
    "Change Password",
    // "Customer ",
    // "Settings"
  ];

  List<IconData> tabIcons = [
    Icons.person_outline,
    Icons.lock_outlined,
    // Icons.support_agent,
    // Icons.settings,
  ];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Widget _buildProfileImage() {
    final userModel = SplashScreenController.obj.userModel;
    print(SplashScreenController.obj.userModel);

    if (userModel == null ||
        userModel.imageurl == null ||
        userModel.imageurl!.isEmpty) {
      return Container(
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: Icon(
          Icons.person,
          size: 35.sp,
          color: const Color(0xff1B4332),
        ),
      );
    }

    return Container(
      width: 100.h,
      height: 100.h,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.network(
        userModel.imageurl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              color: const Color(0xff1B4332),
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Icon(
              Icons.person,
              size: 60.sp,
              color: const Color(0xff1B4332),
            ),
          );
        },
      ),
    );
  }

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("admins")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        setState(() {
          username = userData['name'] ?? "User";
        });
      }
    } catch (e) {
      print("Error fetching user data: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Logout",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xff1B4332),
            ),
          ),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(color: Color(0xff1B4332)),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Dialog(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              color: Color(0xff1B4332),
                            ),
                            SizedBox(width: 16),
                            Text(
                              "Logging out...",
                              style: TextStyle(
                                color: Color(0xff1B4332),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );

                try {
                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    final token = await FirebaseMessaging.instance.getToken();

                    if (token != null) {
                      await FirebaseFirestore.instance
                          .collection('admins')
                          .doc(user.uid)
                          .update({
                        'tokens': FieldValue.arrayRemove([token]),
                      });
                    }

                    await FirebaseAuth.instance.signOut();
                  }
                  navigator.pop();

                  Get.offAll(() => const SignInScreen());
                } catch (e) {
                  navigator.pop();

                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text("Error logging out: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            if (index == 0) {
              final result = await Get.to(() => const MyInfoScreen());
              if (result == true) {
                fetchUserData();
              }
            } else if (index == 1) {
              Get.to(() => const ChangePassword());
            } else if (index == 2) {
              Get.to(() => const SettingScreen());
            } else {
              Get.to(() => const SettingScreen());
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: const Color(0xffF5DDCC).withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      tabIcons[index],
                      color: const Color(0xff1B4332),
                      size: 20.sp,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    tabs[index],
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff20402A),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: const Color(0xff1B4332),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFAFAFA),
      body: Stack(
        children: [
          ClipPath(
            clipper: TopClipper(),
            child: Container(
              height: 220.h,
              width: ScreenUtil().screenWidth,
              color: const Color(0xffF5DDCC),
            ),
          ),
          Positioned(
            top: 55.h,
            left: 0,
            right: 0,
            child: AppBarClass(
              text: "My Profile",
              color: const Color(0xff20402A),
              iconcolor: const Color(0xff1B4332),
            ),
          ),
          SafeArea(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xff1B4332),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 90.h),
                        Center(child: _buildProfileImage()),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Welcome ",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: const Color(0xff20402A),
                              ),
                            ),
                            Text(
                              username,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                                color: const Color(0xff1B4332),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),
                        ...List.generate(
                          tabs.length,
                          (index) => _buildMenuItem(index),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 20.w, vertical: 8.h),
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              _showLogoutConfirmationDialog(context);
                            },
                            icon: const Icon(Icons.logout, color: Colors.white),
                            label: Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.defaultDialog(
                              title: "Delete Account",
                              middleText:
                                  "Are you sure you want to delete your account? This action is irreversible and your data will be permanently removed. You will not be able to log in with the same credentials again.",
                              confirm: TextButton(
                                onPressed: () async {
                                  try {
                                    final user =
                                        FirebaseAuth.instance.currentUser;
                                    final uid = user?.uid;

                                    if (uid != null) {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uid)
                                          .delete();

                                      await user!.delete();

                                      Get.offAll(const SignInScreen());
                                    }
                                  } catch (e) {
                                    Get.snackbar("Error",
                                        "Failed to delete account. Please try again.");
                                  }
                                },
                                child: const Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                              cancel: TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text("Cancel"),
                              ),
                            );
                          },
                          child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: 20.w, vertical: 8.h),
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                label: const Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                ),
                              )
                              //  Row(
                              //   children: [
                              //     Container(
                              //       width: 39.w,
                              //       height: 39.h,
                              //       decoration: BoxDecoration(
                              //           shape: BoxShape.circle,
                              //           color: Colors.red.withOpacity(0.3)),
                              //       child: const Center(
                              //         child: Icon(
                              //           Icons.delete,
                              //           color: Colors.red,
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(
                              //       width: 13.w,
                              //     ),
                              //     Text(
                              //       "Delete Account",
                              //       style: TextStyle(
                              //         fontSize: 16.sp,
                              //         fontWeight: FontWeight.w400,
                              //         color: const Color(0xff000000),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          "App Version 1.0.0",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
