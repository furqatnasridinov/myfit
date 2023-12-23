import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchingActivitiesCard extends StatelessWidget {
  const SearchingActivitiesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
      child: CustomCard(
        child: CustomText(
          text:
              "Собираем данные об активностях вокруг вас, скоро всё покажем, пожалуйста подождите",
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
