import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Speciality extends StatelessWidget {
  Speciality({super.key});

  final List<String> list = [
    "Сменная обувь",
    "Спортивная одежда",
    "Справка о психическом состоянии",
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Особенности посещения",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              InkWell(
                onTap: () {
                  showSpecialityPopUp(context);
                },
                child: Container(
                  width: 26.w,
                  height: 26.h,
                  padding: EdgeInsets.all(3.5.r),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: SvgPicture.asset(
                    "assets/svg/question.svg",
                  ),
                ),
              )
            ],
          ),
          10.verticalSpace,
          Consumer(builder: (context, ref, child) {
            final state = ref.watch(activityProvider);
            return ListView.builder(
              itemCount: 1,//list.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return eachList(state.describtionAndPeculiarities?.peculiarities ?? "");
              },
            );
          }),
        ],
      ),
    );
  }
}

Widget eachList(String text) {
  return Row(
    children: [
      Container(
        width: 5.w,
        height: 5.h,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black,
        ),
      ),
      10.horizontalSpace,
      InterText(
        text: text,
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
      )
    ],
  );
}

void showSpecialityPopUp(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
                side: const BorderSide(
                  color: AppColors.blueBorder,
                )),
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "Особенности посещения",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  16.verticalSpace,
                  CustomText(
                    text:
                        "Для посещения этой активности вам стоит учитывать некоторые особенности. За их игнорирование вас могут не пустить на входе.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  16.verticalSpace,
                  CustomText(
                    text:
                        "Если у вас есть вопросы, пожалуйста свяжитесь с администратором, контакты указаны вверху страницы",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ));
      });
}
