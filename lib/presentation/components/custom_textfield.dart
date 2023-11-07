// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  int? maxLines;
  TextInputType? keyboardType;
  EdgeInsetsGeometry? contentPadding;
  CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.contentPadding,
    this.maxLines,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines:maxLines,
      keyboardType: keyboardType,
      controller: controller,
      cursorColor: AppColors.greyText,
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(fontSize: 13.sp,fontWeight: FontWeight.w400),
        fillColor: Colors.white,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: AppColors.greyBorder,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}
