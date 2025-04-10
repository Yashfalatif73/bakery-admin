
import 'package:bakeryadminapp/HomeScreens/controllers/itemadd_cont.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:bakeryadminapp/widgets/clipper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/instance_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
   
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
          Container(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              color: Color(0xffDE5B33),
              child: Center(
                child: Stack(
                  children: [
                   
                    Align(
                      alignment: Alignment.topCenter,
                      child: ClipPath(
                        clipper: TopClipper(),
                        child: Container(
                          height: 150.h,
                          width: 375.w,
                          color: AppColors.primaryColor,
                          
                        ),
                      ),
                    ),
                     Center(
                       child: Text("Logo Here",
                                           style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold
                                           ),),
                     ),
                  ],
                ),
              )),
        ],
      ),
 


    );
  }
}