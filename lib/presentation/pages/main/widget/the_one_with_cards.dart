import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TheOneWithCards extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  TheOneWithCards({super.key, required this.state, required this.event});
  final List<String> images = [
    'assets/images/calculator.png',
    'assets/images/chains.png',
    'assets/images/gantelya.png',
    'assets/images/corona.png'
  ];
  @override
  Widget build(BuildContext context) {
    return state.subscribtions == null
        ? const SizedBox()
        : Column(
            children: [
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
              Wrap(
                runSpacing: 5.h,
                spacing: 3.w,
                children: state.subscribtions!.bodyData!
                    .map(
                      (element) => _cardsBuilder(
                        element.type ?? "",
                        element.price.toString(),
                        element.description ?? "",
                        element.id == 1 ? double.maxFinite : null,
                        null,
                        element.id!,
                        images[element.id! - 1],
                      ),
                    )
                    .toList(),
              ),
            ],
          );
  }

  Widget _cardsBuilder(
    String name,
    String price,
    String describtion,
    double? width,
    double? height,
    int index,
    String img,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: index == 3 ? null : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: index == 3
            ? null
            : Border.all(
                color: AppColors.greyBorder,
                width: 1.w,
              ),
        boxShadow: index == 3
            ? const [
                BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.15),
                    spreadRadius: 0.0,
                    blurRadius: 5.0,
                    offset: Offset(0, 2)),
                BoxShadow(
                  color: Color.fromRGBO(158, 78, 197, 0.8),
                  spreadRadius: -15.0,
                  blurRadius: 27.0,
                  offset: Offset(0, 19),
                )
              ]
            : [],
        gradient: index == 3
            ? const LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(235, 192, 114, 1),
                  Color.fromRGBO(154, 73, 201, 1),
                ],
              )
            : null,
      ),
      padding: EdgeInsets.all(
        14.5.r,
      ),
      child: index == 1
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
                30.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    CustomText(
                      text: name,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.purpleText,
                    ),
                    10.verticalSpace,
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '\$$price ',
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
                    2.verticalSpace,
                    CustomText(
                      text: describtion,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.greyText,
                    )
                  ],
                ),
              ],
            )
          : Column(
              children: [
                SizedBox(
                  width: 80.w,
                  height: 80.h,
                  child: Image.asset(
                    img,
                    fit: BoxFit.cover,
                  ),
                ),
                10.verticalSpace,
                CustomText(
                  text: name,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: index == 3 ? Colors.white : AppColors.purpleText,
                ),
                10.verticalSpace,
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '\$$price ',
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: index == 3 ? Colors.white : Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: "в месяц",
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: index == 3 ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                CustomText(
                  text: describtion,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText,
                )
              ],
            ),
    );
  }
}
