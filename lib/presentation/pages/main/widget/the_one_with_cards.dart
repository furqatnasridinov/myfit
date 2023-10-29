import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TheOneWithCards extends StatelessWidget {
  const TheOneWithCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: 'Варианты подписки',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      Column(
        children: [
          UiCard(
              cardValue: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Image(
                    image: AssetImage('assets/images/calculator.png'),
                    width: 79.0,
                    height: 81.0,
                  ),
                  const SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'Семейная подписка',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.purpleText,
                      ),
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$15 ',
                              style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black),
                            ),
                            TextSpan(
                              text: "в месяц",
                              style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      CustomText(
                        text: 'Одна подписка для 4-x человек',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: const Color.fromRGBO(176, 176, 176, 1),
                      )
                    ],
                  ),
                ],
              ),
              cardMaxWidth: MediaQuery.of(context).size.width * 1),
          5.verticalSpace,
          Row(children: [
            UiCard(
                cardValue: Column(
              children: [
                const Image(
                  image: AssetImage('assets/images/gantelya.png'),
                  width: 79.0,
                  height: 81.0,
                ),
                10.verticalSpace,
                CustomText(
                  text: 'Базовая',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.purpleText,
                ),
                10.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$10 ',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: "в месяц",
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
              ],
            )),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  // box-shadow: 0px 2px 5px 0px rgba(0, 0, 0, 0.15), 0px 19px 27px -15px #9E4EC5;
                  boxShadow: const [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.15),
                        spreadRadius: 0.0,
                        blurRadius: 5.0,
                        offset: Offset(0, 2)),
                    BoxShadow(
                        color: Color.fromRGBO(158, 78, 197, 0.8),
                        spreadRadius: -15.0,
                        blurRadius: 27.0,
                        offset: Offset(0, 19))
                  ],
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromRGBO(235, 192, 114, 1),
                      Color.fromRGBO(154, 73, 201, 1),
                    ],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Image(
                        image: AssetImage('assets/images/chains.png'),
                        width: 79.0,
                        height: 81.0,
                      ),
                      10.verticalSpace,
                      CustomText(
                        text: 'На двоих',
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 10.0),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: '\$10 ',
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: "в месяц",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      CustomText(
                        text: 'Для 2 человек',
                        fontWeight: FontWeight.w500,
                        fontSize: 10.sp,
                        color: const Color.fromRGBO(221, 169, 235, 1),
                      ),
                      8.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            UiCard(
                cardValue: Column(
              children: [
                const Image(
                  image: AssetImage('assets/images/corona.png'),
                  width: 79.0,
                  height: 81.0,
                ),
                const SizedBox(height: 10.0),
                CustomText(
                  text: 'Премиум',
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                  color: AppColors.purpleText,
                ),
                10.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$20 ',
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text: "в месяц",
                        style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
                12.verticalSpace,
              ],
            )),
          ])
        ],
      )
    ]);
  }
}
