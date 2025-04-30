import 'package:bakeryadminapp/HomeScreens/additems.dart';
import 'package:bakeryadminapp/HomeScreens/itemlisting.dart';
import 'package:bakeryadminapp/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppColors {
  static Color primaryColor = const Color(0xff1B4332);
}

class AppBarClass extends StatelessWidget {
  AppBarClass({
    super.key,
    required this.text,
    required this.color,
    required this.iconcolor,
  });
  String text;
  Color color;
  Color iconcolor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 15.w,
        ),
        IconButton(
          onPressed: () {
            // Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Icon(
              Icons.arrow_back,
              color: iconcolor,
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 17.26.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class ButtonsColors {
  static Color secondaryColor = const Color(0xff20402A);
}

class TextFormFieldWidget extends StatelessWidget {
  TextFormFieldWidget({
    super.key,
    required this.textEditingController,
    required this.text,
    required this.validator,
    required this.onChanged,
    required this.width,
    required this.Fontsize,
    this.obscureText = false,
    this.suffixicon,
    this.maxlines,
    this.obscuringCharacter = "*",
    required this.align,
    this.hinttext,
  });

  final TextEditingController textEditingController;
  String text;
  double width;
  Widget? suffixicon;
  void Function(String) onChanged;
  bool obscureText;
  String obscuringCharacter;
  bool? maxlines;
  String? Function(String?) validator;
  TextAlign align;
  double Fontsize;
  String? hinttext;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          textAlign: align,
          style: TextStyle(
            color: AppColors.primaryColor,
            fontSize: Fontsize,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 13.h,
        ),
        SizedBox(
          width: width,
          child: TextFormField(
            controller: textEditingController,
            style: const TextStyle(
              color: Colors.black,
            ),
            cursorColor: Colors.black,
            maxLines: maxlines == true ? 2 : 1,
            minLines: 1,
            decoration: InputDecoration(
              hintText: hinttext,
              suffixIcon: suffixicon,
              contentPadding: EdgeInsets.only(
                bottom: 5.h,
                left: 5.w,
              ),
              fillColor: Colors.white,
              filled: true,
              // errorStyle: TextStyle(
              //   color: Colors.transparent,
              //   fontSize: 0,
              // ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: BorderSide(
                      color: const Color(0xff20402A).withOpacity(0.16))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.r),
                borderSide: const BorderSide(color: Color(0xff20402A)),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  )),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  )),
              border: InputBorder.none,
            ),
            obscureText: obscureText,
            obscuringCharacter: obscuringCharacter,
            validator: validator,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}

class TextFormFieldForListings extends StatelessWidget {
  TextFormFieldForListings({
    super.key,
    required this.textEditingController,
    required this.text,
    required this.validator,
    required this.onChanged,
    required this.width,
    required this.Fontsize,
    this.obscureText = false,
    this.suffixicon,
    this.maxlines,
    this.obscuringCharacter = "*",
    required this.align,
    this.hinttext,
  });

  final TextEditingController textEditingController;
  String text;
  double width;
  Widget? suffixicon;
  void Function(String) onChanged;
  bool obscureText;
  String obscuringCharacter;
  bool? maxlines;
  String? Function(String?) validator;
  TextAlign align;
  double Fontsize;
  String? hinttext;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          textAlign: align,
          style: TextStyle(
            color: const Color(0xff898A8D),
            fontSize: Fontsize,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(
          height: 9.h,
        ),
        SizedBox(
          height: 48.h,
          width: width,
          child: TextFormField(
            controller: textEditingController,
            style: const TextStyle(
              color: Colors.black,
            ),
            cursorColor: Colors.black,
            maxLines: maxlines == true ? 2 : 1,
            minLines: 1,
            decoration: InputDecoration(
              hintText: hinttext,
              suffixIcon: suffixicon,
              contentPadding: EdgeInsets.only(
                bottom: 5.h,
                left: 5.w,
              ),
              fillColor: Colors.white,
              filled: true,
              // errorStyle: TextStyle(
              //   color: Colors.transparent,
              //   fontSize: 0,
              // ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: BorderSide(
                      color: const Color(0xff20402A).withOpacity(0.16))),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7.r),
                borderSide: const BorderSide(color: Color(0xff20402A)),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  )),
              focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(7.r),
                  borderSide: const BorderSide(
                    color: Colors.red,
                  )),
              border: InputBorder.none,
            ),
            obscureText: obscureText,
            obscuringCharacter: obscuringCharacter,
            validator: validator,
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}

class TopNavBarClass extends StatelessWidget {
  const TopNavBarClass({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const SizedBox(),
      toolbarHeight: 80,
      backgroundColor: const Color(0xffEEEEE6),
      actions: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Logo",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
              CustomButtons(
                  borderRadius: 100.r,
                  width: 136.67.w,
                  height: 36.54.h,
                  onPressed: () {
                    Get.to(() => const AddItemsScreen());
                    // index == 1;
                    // setState(() {});
                  },
                  backcolor: Colors.white,
                  child: ButtonText(
                    color: const Color(0xff20402A),
                    text: 'Add Items',
                    Font: FontWeight.w400,
                    fontsize: 12.34.sp,
                  )
                  // index == 1 ? AppColors.primaryColor : Colors.white,
                  ),
              CustomButtons(
                borderRadius: 100.r,
                width: 136.67.w,
                height: 36.54.h,
                onPressed: () {
                  Get.to(() => ItemListingScreen());
                  //index = 1;
                },
                backcolor: Colors.white,
                child: ButtonText(
                  color: const Color(0xff20402A),
                  //  color: index == 0 ? Color(0xff20402A) : Colors.white,
                  text: 'View Listing',
                  Font: FontWeight.w400,
                  fontsize: 12.34.sp,
                ),
                // index == 0 ? Colors.white : Color(0xff20402A),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
