import 'package:bakeryadminapp/HomeScreens/provider/user_provider.dart';
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      body: Container(
        color: const Color(0xffEEEEE6),
        child: Column(
          children: [
            const TopNavBarClass(),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                height: 600.h,
                width: ScreenUtil().screenWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Good Morning,", style: TextStyle(fontSize: 18)),
                    Text(
                      userProvider.userData.name,
                      style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 18.h),
                    Row(
                      children: [
                        _buildCard(
                          label: "Total Revenue",
                          value: "${userProvider.userData.revenue}",
                          bgColor: const Color(0xffCAE7E3),
                        ),
                        const Spacer(),
                        _buildCard(
                          label: "Total Orders",
                          value: "${userProvider.userData.totalOrders}",
                          bgColor: const Color(0xffE5E8DC),
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

  Widget _buildCard({required String label, required String value, required Color bgColor}) {
    return Card(
      elevation: 5,
      child: Container(
        height: 61.h,
        width: 152.w,
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          children: [
            SizedBox(width: 15.h),
            Container(
              height: 40.h,
              width: 40.w,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffD2D6D0)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(value,
                        style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w700)),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(label,
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
