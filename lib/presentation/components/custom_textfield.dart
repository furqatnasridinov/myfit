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
  Widget? suffixIcon;
  EdgeInsetsGeometry? contentPadding;
  FocusNode? focusNode;
  void Function(PointerDownEvent)? onTapOutside;
  void Function()? onTap;
  bool readOnly;

  CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.contentPadding,
    this.readOnly = false,
    this.maxLines,
    this.focusNode,
    this.keyboardType,
    this.onTap,
    this.onTapOutside,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      /* onTapOutside: (onTapOutside) {
        FocusScope.of(context).unfocus();
      }, */
      focusNode: focusNode,
      readOnly: readOnly,
      maxLines: maxLines,
      keyboardType: keyboardType,
      controller: controller,
      onTapOutside: onTapOutside,
      onTap: onTap,
      cursorColor: AppColors.greyText,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        contentPadding: contentPadding,
        hintText: hintText,
        hintStyle: GoogleFonts.inter(
          fontSize: 14.sp,
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
