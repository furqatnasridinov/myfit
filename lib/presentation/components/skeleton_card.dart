// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';

class SkeletonCard extends StatelessWidget {
  final bool isBlue;
  double height;
  double width;
 SkeletonCard({super.key, this.isBlue = false, this.height = 24, this.width = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isBlue ? AppColors.skeletonBg :AppColors.skeletonSecondary,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
      ),
    );
  }
}
