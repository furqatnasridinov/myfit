import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';

class FilterAndPayment extends StatelessWidget {
  const FilterAndPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      width: double.maxFinite,
      child: Column(
        children: [
          _iconAndText(),
          10.verticalSpace,
          _iconAndText(
            iconPath: "assets/svg/card_icon.svg",
            text: "Настроить методы оплаты",
          ),
        ],
      ),
    );
  }
}

Widget _iconAndText({ 
  String iconPath = "assets/svg/location_filled.svg",
  String text = "Найти залы рядом со мной для покупки абонемента",
  Function()? onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Row(
      children: [
        SvgPicture.asset(
          iconPath,
          width: 28.w,
          height: 28.h,
        ),
        10.horizontalSpace,
        Flexible(
            child: CustomText(
          text: text,
          fontSize: 14.sp,
          height: 1.1,
        )),
      ],
    ),
  );
}
