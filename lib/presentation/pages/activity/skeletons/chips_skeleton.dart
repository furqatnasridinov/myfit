import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class ChipsSkeleton extends StatelessWidget {
  const ChipsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonCard(width: 160.w),
        5.verticalSpace,
        Row(children: [
          Expanded(child: SkeletonCard(height: 34)),
          5.horizontalSpace,
          Expanded(child: SkeletonCard(height: 34)),
        ],),
      ],
    );
  }
}
