import 'package:bakeryadminapp/Auth/signin.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:bakeryadminapp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool iconclicked = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confpasscontroller = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

         body:  Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          color: Color(0xffEEEEE6),
          child: Form(
            key: formkey,
            child: Column(
              children: [
                SizedBox(
                  height: 55.h,
                ),
                AppBarClass(
                  text: "Sign Up",
                  color: Color(0xff20402A),
                  iconcolor: Color(0xff20402A),
                ),
                SizedBox(
                  height: 150.h,
                ),
              TextFormFieldWidget(
                        onChanged: (v) {},
                        textEditingController: emailcontroller,
                        text: "Email",
                        width: 319.w,
                        validator: (value) {
                          bool emailcontroller = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value!);
                          if (value!.isEmpty) {
                            return "Please enter Email";
                          }
                          if (!emailcontroller) {
                            return "Please enter valid Email";
                          }

                          return null;
                        },
                        align: TextAlign.start,
                        Fontsize: 16.sp,
                      ),
                    
                SizedBox(
                  height: 29.h,
                ),
                TextFormFieldWidget(
                        onChanged: (v) {
                         
                        },
                        textEditingController: passwordcontroller,
                        text: "Password",
                        width: 319.w,
                        obscureText: iconclicked,
                        obscuringCharacter: "*",
                        suffixicon: IconButton(
                          onPressed: () {
                         
                          
                          },
                          icon: Icon(
                            iconclicked
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.35)),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter password";
                          }
                          return null;
                        },
                        align: TextAlign.start,
                        Fontsize: 16.sp,
                      ),
                  SizedBox(
                  height: 29.h,
                ),
                TextFormFieldWidget(
                      onChanged: (v) {

                      },
                      textEditingController: confpasscontroller,
                      text: "Confirm Password",
                      width: 319.w,
                      obscureText: iconclicked,
                      obscuringCharacter: "*",
                      suffixicon: IconButton(
                        onPressed: () {
                        
                        },
                        icon: Icon(
                               iconclicked
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.35),
                              )
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        } else if (passwordcontroller.text != value) {
                          return "Confirm password does not match";
                        }
                        return null;
                      },
                      align: TextAlign.start,
                      Fontsize: 16.sp,
                    ),
               
                SizedBox(
                  height: 18.h,
                ),
                InkWell(
                  onTap: () {
                   //here to go on forgot pass 
                  },
                 
                ),
                SizedBox(
                  height: 50.h,
                ),
               CustomButtons(
                          borderRadius: 7.78.r,
                          child: ButtonText(
                            color: Color(0xffFBFBF0),
                            text: 'Sign Up',
                            Font: FontWeight.w600,
                            fontsize: 13.62.sp,
                          ),
                          width: 119.w,
                          height: 36.27.h,
                          onPressed: () async {
                            if (formkey.currentState!.validate()) {
                             
                             
                            }
                          },
                          backcolor: emailcontroller.text.isNotEmpty &&
                                 passwordcontroller.text.isNotEmpty
                              ? ButtonsColors.secondaryColor
                              : Colors.grey),
                    
                SizedBox(
                  height: 40.h,
                ),
                InkWell(
                  onTap: () {
                   Get.to(()=>SignInScreen());
                  },
                  child: Text(
                    "Already have any accounts? Click here to\n Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.62.sp,
                      fontWeight: FontWeight.normal,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      
   
    );
  }
}