import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class CalendarSkeleton extends StatelessWidget {
  const CalendarSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonCard(width: 220),
          10.verticalSpace,
          SizedBox(
            height: 73.h,
            child: ListView.builder(
              //physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 70,
              //shrinkWrap: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(right: 9.w),
                  child: SkeletonCard(width: 41, height: 70.h),
                );
              },
            ),
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
