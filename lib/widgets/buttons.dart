
import 'package:bakeryadminapp/utilis/utilis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButtons extends StatelessWidget {
  CustomButtons({
    super.key,
    required this.borderRadius,
    required this.child,
    required this.width,
    required this.height,
    required this.onPressed,
    required this.backcolor,
  });
  Widget child;
  double borderRadius;
  double width;
  double height;
  Color backcolor;

  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(backcolor ?? AppColors.primaryColor

                      // backcolor ?? AppColors.primaryColor,
                      ),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                borderRadius.r,
              )))),
          onPressed: onPressed,
          child: child),
    );
  }
}

class ButtonText extends StatelessWidget {
  ButtonText({
    super.key,
    required this.color,
    required this.text,
    required this.Font,
    required this.fontsize,
  });
  String text;
  Color color;
  FontWeight Font;
  double fontsize;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontsize,
        color: color,
        fontWeight: Font,
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  ButtonWithIcon({
    super.key,
    required this.image,
    required this.text,
    required this.onPressed,
  });
  String image;
  String text;
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return CustomButtons(
        borderRadius: 9.02.r,
        onPressed: onPressed,
        width: 306.04.w,
        height: 50.04.h,
        backcolor: Colors.white,
        child: Row(
          children: [
            const SizedBox(
              width: 15,
            ),
            Image(
              height: 26.04.h,
              width: 26.04.w,
              image: AssetImage(
                image,
              ),
            ),
            SizedBox(
              width: 50.w,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 15.h,
                  color: Colors.black,
                  fontWeight: FontWeight.w500),
            )
          ],
        ));
  }
}
