import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';

class ContactsSkeleton extends StatelessWidget {
  const ContactsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonCard(width: double.infinity),
        10.verticalSpace,
        Row(
          children: [
            Expanded(
              flex: 1,
              child: SkeletonCard(),
            ),
            10.horizontalSpace,
            Expanded(
              flex: 5,
              child: SkeletonCard(),
            ),
            10.horizontalSpace,
            Expanded(
              flex: 1,
              child: SkeletonCard(),
            ),
            10.horizontalSpace,
            Expanded(
              flex: 5,
              child: SkeletonCard(),
            ),
          ],
        )
      ],
    );
  }
}
