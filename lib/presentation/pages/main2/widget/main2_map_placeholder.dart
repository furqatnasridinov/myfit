import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Main2MapPlaceHolder extends StatelessWidget {
  const Main2MapPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 100.h,
      width: double.maxFinite,
      child: CustomText(
        text: "Идет поиск заведений вокруг вас, пожалуйста подождите!",
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
