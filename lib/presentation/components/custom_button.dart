import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  final void Function()? onPressed;
  Color buttonColor;
  Color borderColor;
  final String text;
  Color textColor;
  double? width;
  double? height;
  double? fontSize;
  FontWeight? fontWeight;
  bool showProgress;
  CustomButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.width = double.maxFinite,
    this.textColor = Colors.black,
    this.height = 34,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w500,
    this.borderColor = AppColors.blueColor,
    this.buttonColor = AppColors.backgroundColor,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width?.w,
      height: height?.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(buttonColor),
          shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
              side: BorderSide(color: borderColor, width: 1.w),
            ),
          ),
          elevation: const MaterialStatePropertyAll<double>(0),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Colors.black.withOpacity(0.07)
                  : null;
            },
          ),
        ),
        child: showProgress
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 5.h),
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5.w,
                ),
              )
            : CustomText(
                color: textColor,
                text: text,
                fontSize: fontSize!,
                fontWeight: fontWeight,
              ),
      ),
    );
  }
}
