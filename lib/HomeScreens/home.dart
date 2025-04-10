
import 'package:bakeryadminapp/utilis/utilis.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xffEEEEE6),
        child: Column(
          children: [
          TopNavBarClass(),
          
              SizedBox(
              height: 20.h,
            ),
            Padding(
                    padding: EdgeInsets.only(left: 24.w, right: 24.w),
                    child: Container(
                      height: 600.h,
                      width: ScreenUtil().screenWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Morning,",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            "Bessie Cooper",
                            style: TextStyle(
                                fontSize: 28,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: 18.h,
                          ),
                          Row(
                            children: [
                              Card(
                                elevation: 5,
                                child: Container(
                                  height: 61.h,
                                  width: 152.w,
                                  decoration: BoxDecoration(
                                      color: Color(0xffCAE7E3),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15.h,
                                          ),
                                          Container(
                                            height: 40.h,
                                            width: 40.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffD2D6D0),
                                            ),
                                           
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "40k",
                                                      style: TextStyle(
                                                          fontSize: 22.sp,
                                                          color:
                                                              Color(0xff464255),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Total Revenue",
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color:
                                                              Color(0xff464255),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Spacer(),
                              Card(
                                elevation: 5,
                                child: Container(
                                  height: 61.h,
                                  width: 152.w,
                                  decoration: BoxDecoration(
                                      color: Color(0xffE5E8DC),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: 15.h,
                                          ),
                                          Container(
                                            height: 40.h,
                                            width: 40.w,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xffD2D6D0),
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "126",
                                                      style: TextStyle(
                                                          fontSize: 22.sp,
                                                          color:
                                                              Color(0xff464255),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      "Total Orders",
                                                      style: TextStyle(
                                                          fontSize: 11.sp,
                                                          color:
                                                              Color(0xff464255),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
               
          ],
        ),
      ),
    );
  }
}
