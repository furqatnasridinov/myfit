// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  int? maxLines;
  TextInputType? keyboardType;
  EdgeInsetsGeometry? contentPadding;
  String? initialValue;
  bool readOnly;
  CustomTextFormField({
    Key? key,
    this.hintText,
    this.readOnly = false,
    this.contentPadding,
    this.maxLines,
    this.keyboardType,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      initialValue: initialValue,
      maxLines: maxLines,
      keyboardType: keyboardType,
      //controller: controller,
      cursorColor: AppColors.greyText,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 13.sp,
          fontWeight: FontWeight.w400,
        ),
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
