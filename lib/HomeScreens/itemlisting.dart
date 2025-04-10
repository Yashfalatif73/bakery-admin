
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ItemListingScreen extends StatefulWidget {
  const ItemListingScreen({super.key});

  @override
  State<ItemListingScreen> createState() => _ItemListingScreenState();
}

class _ItemListingScreenState extends State<ItemListingScreen> {
  TextEditingController searchcontroller = TextEditingController();
  @override
 
 
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        color: Color(0xffEEEEE6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopNavBarClass(),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Items Listing",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color(0xff20402A),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 392.h,
                      width: 330.w,
                      decoration: BoxDecoration(
                        // color: Colors.amber
                        color: Color(0xffF2F2F2),
                      ),
                      child: Column(
                        children: [
                          Container(
                            height: 64.h,
                            width: 330.w,
                            color: Color(0xffFAFAFA),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 215.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32.r),
                                      border: Border.all(
                                        color: Color(0xffF2F2F2),
                                        width: 1,
                                      )),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Image(
                                        image: AssetImage(
                                          "images/icon.png",
                                        ),
                                        height: 12.h,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Search",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff979797),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 67.w,
                                  height: 32.h,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(
                                        color: Color(0xffF2F2F2),
                                        width: 1,
                                      )),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Image(
                                        image: AssetImage(
                                          "images/filter.png",
                                        ),
                                        height: 12.h,
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Text(
                                        "Filter",
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Color(0xff807A7A),
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24, right: 24),
                            child: Container(
                              height: 40.h,
                              width: 330.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Item Name",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0xff404040),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Color(0xff404040),
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 24.h,
                                        width: 24.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffF5F7F9),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_back_ios_new_rounded,
                                            size: 12.h,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 24.h,
                                        width: 24.w,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xffF5F7F9),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 12.h,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1.h,
                            width: 330.w,
                            color: Color(0xffF2F2F2),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: 6,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 24, right: 24),
                                        child: Container(
                                          height: 40.h,
                                          width: 330.w,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Pizza",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Color(0xff404040),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              SizedBox(
                                                width: 3.w,
                                              ),
                                              Text(
                                                "BBq Pizza ..",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: Color(0xff404040),
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Container(
                                                width: 79.w,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Container(
                                                      height: 21.h,
                                                      width: 21.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r),
                                                        color:
                                                            Color(0xff0FCB02),
                                                      ),
                                                      child: Center(
                                                          child: Image(
                                                        image: AssetImage(
                                                            "images/Group 2128.png"),
                                                        height: 14.7.h,
                                                      )),
                                                    ),
                                                    Container(
                                                      height: 21.h,
                                                      width: 21.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r),
                                                        color:
                                                            Color(0xffF55F44),
                                                      ),
                                                      child: Center(
                                                          child: Image(
                                                        image: AssetImage(
                                                            "images/Vector (1).png"),
                                                        height: 10.h,
                                                      )),
                                                    ),
                                                    Container(
                                                      height: 21.h,
                                                      width: 21.w,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.r),
                                                        color:
                                                            Color(0xff495057),
                                                      ),
                                                      child: Center(
                                                          child: Image(
                                                        image: AssetImage(
                                                            "images/Group 2415.png"),
                                                        height: 8.h,
                                                      )),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 1.h,
                                      width: 330.w,
                                      color: Color(0xffF2F2F2),
                                    ),
                                  ],
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
