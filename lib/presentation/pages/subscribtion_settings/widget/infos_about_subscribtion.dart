import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/models/data/subscribtion_card.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';

class InfosAboutSubscribtion extends StatelessWidget {
  const InfosAboutSubscribtion({super.key});

  @override
  Widget build(BuildContext context) {
    final List<SubscribtionCard> list = DummyData().dummySubscribtionCards;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Как работает подписка MyFit?",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          16.verticalSpace,

          // first long text
          CustomText(
            text: AppConstants.subscriptionText1,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          16.verticalSpace,
          // second long text
          CustomText(
            text: AppConstants.subscriptionText2,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          16.verticalSpace,
          // third long text
          CustomText(
            text: AppConstants.subscriptionText3,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          32.verticalSpace,
          // cards
          ListView.builder(
            itemCount: list.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return buildCard(
                list[index].title,
                list[index].description,
                list[index].description2,
              );
            },
          ),
          50.verticalSpace
        ],
      ),
    );
  }
}

Widget buildCard(String title, String description, String? description2) {
  return Container(
    width: double.maxFinite,
    margin: EdgeInsets.only(bottom: 32.h),
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(color: const Color.fromRGBO(244, 244, 244, 1)),
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.15),
          offset: Offset(0, 5),
          blurRadius: 5,
          spreadRadius: -4,
        ),
        BoxShadow(
          color: Color.fromRGBO(123, 163, 225, 0.73),
          offset: Offset(0, 10),
          blurRadius: 10,
          spreadRadius: -8,
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/svg/checkedNew.svg"),
            16.horizontalSpace,
            Flexible(
              child: CustomText(
                text: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
            )
          ],
        ),
        16.verticalSpace,
        CustomText(
          text: description,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.1,
        ),
        description2!.isEmpty ? 0.verticalSpace : 16.verticalSpace,
        if (description2.isNotEmpty)
          CustomText(
            text: description2,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
      ],
    ),
  );
}
