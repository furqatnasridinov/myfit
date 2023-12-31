// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextField extends StatelessWidget {
  String? hintText;
  TextEditingController? controller;
  int? maxLines;
  TextStyle? style;
  TextInputType? keyboardType;
  Widget? suffixIcon;
  String? counterText;
  int? maxLength;
  EdgeInsetsGeometry? contentPadding;
  FocusNode? focusNode;
  TextStyle? counterStyle;
  bool hasFocus;
  bool isError;
  Color? cursorColor;
  String? Function(String?)? validator;
  List<TextInputFormatter>? inputFormatters;
  void Function(PointerDownEvent)? onTapOutside;
  void Function()? onEditingComplete;
  void Function()? onTap;
  bool readOnly;

  CustomTextField({
    Key? key,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.contentPadding,
    this.inputFormatters,
    this.counterStyle,
    this.readOnly = false,
    this.hasFocus = false,
    this.validator,
    this.isError = false,
    this.maxLines,
    this.counterText,
    this.maxLength,
    this.focusNode,
    this.keyboardType,
    this.style,
    this.onEditingComplete,
    this.onTap,
    this.onTapOutside,
    this.cursorColor = Colors.black
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      /* onTapOutside: (onTapOutside) {
        FocusScope.of(context).unfocus();
      }, */
      inputFormatters: inputFormatters,
      focusNode: focusNode,
      readOnly: readOnly,
      maxLines: maxLines,
      maxLength: maxLength,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      onTapOutside: onTapOutside,
      onTap: onTap,
      cursorColor: cursorColor,
      onEditingComplete: onEditingComplete,
      style: style,
      decoration: InputDecoration(
        counterText: counterText,
        counterStyle: counterStyle,
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
            color: focusNode!.hasFocus
                ? AppColors.blueColor
                : isError
                    ? Colors.red
                    : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: focusNode!.hasFocus
                ? AppColors.blueColor
                : isError
                    ? Colors.red
                    : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
            color: isError ? Colors.red : AppColors.greyBorder,
            width: 1.w,
          ),
        ),
      ),
    );
  }
}
