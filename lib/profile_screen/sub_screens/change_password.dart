import 'package:bakeryadminapp/widgets/buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utilis/utilis.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool oldObscure = true;
  bool newObscure = true;
  bool confirmObscure = true;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPasswordController.text.trim(),
      );

      await user.reauthenticateWithCredential(cred);

      if (newPasswordController.text.trim() != confirmPasswordController.text.trim()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("New password and Confirm password do not match."),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          isLoading = false;
        });
        return;
      }

      await user.updatePassword(newPasswordController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Password updated successfully."),
          backgroundColor: Color(0xff1B4332),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required void Function() toggleVisibility,
  }) {
    return Container(
      width: 319.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16.sp),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Please enter $label';
          return null;
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: const Color(0xff1B4332),
            ),
            onPressed: toggleVisibility,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xff1B4332)),
            )
          : Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              color: const Color(0xffEEEEE6),
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 55.h),
                      AppBarClass(
                        text: "Change Password",
                        color: const Color(0xff20402A),
                        iconcolor: const Color(0xff1B4332),
                      ),
                      SizedBox(height: 30.h),
                      _buildPasswordField(
                        label: 'Old Password',
                        controller: oldPasswordController,
                        obscureText: oldObscure,
                        toggleVisibility: () {
                          setState(() {
                            oldObscure = !oldObscure;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildPasswordField(
                        label: 'New Password',
                        controller: newPasswordController,
                        obscureText: newObscure,
                        toggleVisibility: () {
                          setState(() {
                            newObscure = !newObscure;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),
                      _buildPasswordField(
                        label: 'Confirm Password',
                        controller: confirmPasswordController,
                        obscureText: confirmObscure,
                        toggleVisibility: () {
                          setState(() {
                            confirmObscure = !confirmObscure;
                          });
                        },
                      ),
                      SizedBox(height: 40.h),
                      CustomButtons(
                        borderRadius: 8.r,
                        width: 319.w,
                        height: 50.h,
                        onPressed: _changePassword,
                        backcolor: const Color(0xff20402A),
                        child: Center(
                          child: ButtonText(
                            color: Colors.white,
                            text: 'Update Password',
                            Font: FontWeight.w600,
                            fontsize: 16.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
