import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstTwoCards extends StatelessWidget {
  const FirstTwoCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: UiCard(
          cardValue: Column(children: [
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: '17',
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                        color: Colors.black),
                  ),
                  TextSpan(
                    text: ' посещений Запланированов этом месяце',
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5.0),
            Align(
              alignment: Alignment.centerLeft,
              child: CustomText(
                text: 'Изменить расписание',
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: AppColors.blueColor,
              ),
            )
          ]),
        ),
      ),
      SizedBox(width: 5.w),
      UiCard(
        cardHeight: 99.0,
        cardValue:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          CustomText(
            text: 'Premium абонемент',
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(height: 5.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: Container(
                  color: const Color.fromRGBO(245, 249, 255, 1),
                  padding: const EdgeInsets.all(5.0),
                  child: CustomText(
                    text: '121 день',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              CustomText(
                text: 'Продлить',
                fontWeight: FontWeight.w500,
                fontSize: 10.sp,
                color: AppColors.blueColor,
              ),
            ],
          ),
        ]),
      ),
    ]);
  }
}
