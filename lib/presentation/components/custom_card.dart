// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  double? width;
  double? height;
  Color? color;
  Color borderColor;
  double radius;
  double? paddingAll;
  final Widget child;
  double? marginBottom;
  CustomCard({
    Key? key,
    this.width,
    this.height,
    this.marginBottom,
    this.color = Colors.white,
    this.borderColor = AppColors.greyBorder,
    this.radius = 16,
    this.paddingAll = 16,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: borderColor, width: 1.w),
        borderRadius: BorderRadius.circular(radius.r),
      ),
      margin: EdgeInsets.only(bottom: marginBottom ?? 0),
      padding: EdgeInsets.all(paddingAll!.r),
      child: child,
    );
  }
}
