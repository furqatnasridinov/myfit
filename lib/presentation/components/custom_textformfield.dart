// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  int? maxLines;
  TextInputType? keyboardType;
  List<TextInputFormatter>? inputFormatters;
  int? maxLength;
  EdgeInsetsGeometry? contentPadding;
  void Function(PointerDownEvent)? onTapOutside;
  String? initialValue;
  bool readOnly;
  bool hasFocus;
  FocusNode? focusNode;
  bool dontShowBorders;
  Widget? suffixIcon;
  void Function()? onTap;
  CustomTextFormField({
    Key? key,
    this.hintText,
    this.hasFocus = false,
    this.readOnly = false,
    this.dontShowBorders = false,
    this.onTap,
    this.inputFormatters,
    this.suffixIcon,
    this.contentPadding,
    this.onTapOutside,
    this.focusNode,
    this.maxLength,
    this.maxLines,
    this.keyboardType,
    this.initialValue,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      focusNode: focusNode,
      initialValue: initialValue,
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onTap: onTap,
      onTapOutside: onTapOutside,
      controller: controller,
      cursorColor: AppColors.greyText,
      style: GoogleFonts.inter(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        counterStyle: const TextStyle(
          height: double.minPositive,
        ),
        counterText: "",
        suffixIcon: suffixIcon,
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
            color: hasFocus
                ? AppColors.blueBorder
                : dontShowBorders
                    ? Colors.transparent
                    : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: hasFocus
                ? AppColors.blueBorder
                : dontShowBorders
                    ? Colors.transparent
                    : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}
