import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class StatsSkeleton extends StatelessWidget {
  const StatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 10.h),
      child: SizedBox(
        width: width,
        //height: 120.h, //
        child: DecoratedBox(decoration: BoxDecoration(
          color: AppColors.skeletonSecondary,
          borderRadius: BorderRadius.circular(10.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonCard(
                  isBlue: true,
                  height: 16,
                  width: width/1.8,
                  borderRadius: 4,
                ),
                10.verticalSpace,
                SizedBox(
                  width: double.maxFinite,
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // pie chart part
                      SizedBox(
                        width: 62.w,
                        height: 62.h,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.skeletonBg,
                        ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.favorite,
                              color: AppColors.skeletonSecondary,
                              size: 20.r,
                            ),
                          ),
                        ),
                      ),
                      20.horizontalSpace,
                      // texts
                      Expanded(
                        child: Wrap(
                          runSpacing: 5.h,
                          spacing: 5.w,
                          children: List.generate(
                            5,
                            (index) => _indicatorSkeleton(index + 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


  Widget _indicatorSkeleton(int index) {
    final double width = 50 + (index * 10).toDouble();
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 6.w,
          height: 6.h,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.skeletonBg,
            ),
          ),
        ),
        5.horizontalSpace,
        SkeletonCard(
          height: 14,
          isBlue: true,
          width: width,
          borderRadius: 4,
        ),
      ],
    );
  }
