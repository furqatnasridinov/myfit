import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class PhotosSkeleton extends StatelessWidget {
  const PhotosSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        32.verticalSpace,
        SkeletonCard(width: 180),
        10.verticalSpace,
        Container(
          padding: EdgeInsets.all(16.r),
          width: double.maxFinite,
          height: 79.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: AppColors.skeletonSecondary,
          ),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(right: 17.w),
                child: SkeletonCard(width: 47, height: 47, isBlue: true),
              );
            },
          ),
        )
      ],
    );
  }
}
