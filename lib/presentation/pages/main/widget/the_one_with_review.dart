import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:activity/presentation/components/ui_vertical_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithReview extends StatelessWidget {
  const TheOneWithReview({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: 'Что говорят наши пользователи:',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        UiCard(
          cardValue: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 292,
                    child: InterText(
                      text:
                          'За месяц подписки сходил во все залы района, прочекал состояние оборудования, открыл для себя то, что в двух залах есть сауна. Без этой подписки денег отдал бы больше.',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      SizedBox(
                        width: 37.0,
                        height: 37.0,
                        child: ClipOval(
                            child: Image.network(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterText(
                            text: 'Томас Хардов',
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          2.verticalSpace,
                          InterText(
                            text: 'г. Санкт-Петербург, 29 лет',
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                            color: AppColors.greyText,
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
              20.horizontalSpace,
              UiVerticalStepper()
            ],
          ),
        )
      ],
    );
  }
}
