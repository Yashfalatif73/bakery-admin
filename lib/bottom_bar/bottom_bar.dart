import 'dart:developer';
import 'package:bakeryadminapp/HomeScreens/provider/user_provider.dart';
import 'package:bakeryadminapp/notifications/notifications_screen.dart';
import 'package:bakeryadminapp/HomeScreens/additems.dart';
import 'package:bakeryadminapp/HomeScreens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BottomBarScreen extends StatefulWidget {
  const BottomBarScreen({super.key});

  @override
  State<BottomBarScreen> createState() => _BottomBarScreenState();
}

class _BottomBarScreenState extends State<BottomBarScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).fetchCurrentUserData();
  }
  PageController pagecontroller = PageController();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffEEEEE6),
        height: ScreenUtil().screenHeight,
        width: ScreenUtil().screenWidth,
        child: Stack(
          children: [
            SizedBox(
              height: ScreenUtil().screenHeight,
              width: ScreenUtil().screenWidth,
              child: PageView(
                // physics: NeverScrollableScrollPhysics(),
                onPageChanged: (value) {
                  log("message $value");
                  index = value;
                  setState(() {});
                },
                controller: pagecontroller,
                children: const [
                  HomeScreen(),
                  NotificationsScreen(),
                  AddItemsScreen(),
                  Placeholder(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 70.82.h,
                width: 371.27.w,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border.fromBorderSide(BorderSide(
                      color: Color.fromARGB(255, 182, 182, 182),
                    )
                        //color: Colors.grey,
                        )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        index = 0;
                        pagecontroller.jumpToPage(0);
                        setState(() {});
                      },
                      child: Image(
                        image: index != 0
                            ? const AssetImage("images/bottomnav.png")
                            : const AssetImage("images/homefilled.png"),
                        height: 17.25,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        index = 1;
                        pagecontroller.jumpToPage(1);

                        setState(() {});
                      },
                      child: Image(
                        image: index != 1
                            ? const AssetImage("images/bottomheart.png")
                            : const AssetImage("images/favfilled.png"),
                        height: 17.02,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        index = 2;
                        // pagecontroller.jumpTo(
                        //   2,
                        // );
                        pagecontroller.animateToPage(2,
                            duration: const Duration(seconds: 1), curve: Curves.ease);
                        setState(() {});
                      },
                      child: Image(
                        image: index != 2
                            ? const AssetImage("images/bottomkitchen.png")
                            : const AssetImage("images/Ordersfilled.png"),
                        height: 21.79,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        index = 3;
                        pagecontroller.jumpToPage(3);
                        setState(() {});
                      },
                      child: Image(
                        image: index != 3
                            ? const AssetImage("images/bottomprofile.png")
                            : const AssetImage("images/profilefilled (2).png"),
                        height: 17.25,
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
