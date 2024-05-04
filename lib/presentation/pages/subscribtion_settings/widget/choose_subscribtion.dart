// ignore_for_file: division_optimization, must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';

import '../../../../infrastructure/models/data/subscribtion.dart';

class ChooseSubscribtion extends StatelessWidget {
  void Function()? onTap;
  ChooseSubscribtion({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final List<Subscribtion> dummyList = DummyData().dummySubscribtions;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Выбор подписки",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              GestureDetector(
                onTap: onTap,
                child: CustomText(
                  text: "Как работает подписка",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blueText,
                ),
              ),
            ],
          ),
          16.verticalSpace,

          // list of subscribtions
          Consumer(builder: (context, ref, child) {
            final Subscribtion? selectedSubscribtion =
                ref.watch(settingsProvider).selectedSubscribtion;
            final String cardNumber = ref.watch(settingsProvider).cardNumber;
            final notifier = ref.read(settingsProvider.notifier);
            return Column(
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    return eachSubscription(
                      context,
                      dummyList[index].durationInMonths,
                      dummyList[index].price,
                      (int.parse(dummyList[index].price) /
                              int.parse(dummyList[index].durationInMonths))
                          .toInt()
                          .toString(),
                      dummyList[index].description,
                      selectedSubscribtion?.id == dummyList[index].id,
                      cardNumber,
                      () => notifier.setSelectedSubscribtion(dummyList[index]),
                    );
                  },
                  itemCount: dummyList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                if (selectedSubscribtion != null)
                  CustomText(
                    text:
                        "Ваш тариф: “Пол года” закончится 26.05.24, после чего подписка сменится на “${AppHelpers().getMonthWord(int.parse(selectedSubscribtion.durationInMonths ?? ""))}”.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1.h,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

Widget eachSubscription(
    BuildContext context,
    String month,
    String price,
    String pricePerMonth,
    String description,
    bool isSelected,
    String cardNumber,
    void Function()? onTap) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: GestureDetector(
      onTap: () {
        if (cardNumber.isEmpty) {
          AppHelpers.showSnack(context, "Добавьте карту для смены тарифа");
        } else {
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                  insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  child:
                      dialogContent(context, month, price, cardNumber, onTap),
                );
              });
        }
      },
      child: Row(
        children: [
          SizedBox(
            width: 24.w,
            height: 24.h,
            child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isSelected
                          ? AppColors.purpleText
                          : AppColors.fadedBlueBorder),
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? Center(
                        child: SizedBox(
                          width: 12.w,
                          height: 12.h,
                          child: const DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.purpleText,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()),
          ),
          10.horizontalSpace,
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      color: isSelected
                          ? AppColors.purpleBorder
                          : AppColors.fadedBlueBorder),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isSelected
                      ? const [
                          BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.15),
                            offset: Offset(0.0, 2.0),
                            blurRadius: 5.0,
                          ),
                          BoxShadow(
                            color: Color(0xFF9E4EC5),
                            offset: Offset(0.0, 19.0),
                            blurRadius: 27.0,
                            spreadRadius: -18.0,
                          ),
                        ]
                      : [],
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFEBC072).withOpacity(0.8),
                            const Color(0xFF9A49C9),
                          ],
                          stops: const [-0.4115, 1.3761],
                        )
                      : null),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text: AppHelpers().getMonthWord(int.parse(month)),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected ? Colors.white : AppColors.purpleText,
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              CustomText(
                                text: "₽$price",
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "₽$pricePerMonth",
                                      style: GoogleFonts.raleway(
                                        fontSize: 10.sp,
                                        fontFeatures: const [
                                          FontFeature.liningFigures()
                                        ],
                                        fontWeight: FontWeight.w700,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    WidgetSpan(child: 4.horizontalSpace),
                                    TextSpan(
                                      text: "в месяц",
                                      style: GoogleFonts.raleway(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    5.verticalSpace,
                    CustomText(
                      text: description,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : AppColors.greyText,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget dialogContent(
  BuildContext context,
  String month,
  String price,
  String cardNumber,
  void Function()? onPressed,
) {
  return Padding(
    padding: EdgeInsets.all(16.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: "Подтверждение смены тарифа",
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
        24.verticalSpace,
        CustomText(
          text:
              "Сейчас у вас активна подписка “1 месяц”, она закончится 26.05.24, после чего тариф сменится на “${AppHelpers().getMonthWord(int.parse(month))}”.",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.1.h,
        ),
        16.verticalSpace,
        RichText(
          text: TextSpan(children: [
            TextSpan(
              text: "27 мая 2024 года",
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.1.h,
                color: Colors.black,
                fontFeatures: const [FontFeature.liningFigures()],
              ),
            ),
            WidgetSpan(child: 4.horizontalSpace),
            TextSpan(
              text: "Мы спишем",
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.1.h,
                color: Colors.black,
              ),
            ),
            WidgetSpan(child: 4.horizontalSpace),
            TextSpan(
              text: "₽$price",
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.1.h,
                color: Colors.black,
                fontFeatures: const [FontFeature.liningFigures()],
              ),
            ),
            WidgetSpan(child: 4.horizontalSpace),
            TextSpan(
              text: "с вашей карты",
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.1.h,
                color: Colors.black,
              ),
            ),
            WidgetSpan(child: 4.horizontalSpace),
            TextSpan(
              text: cardNumber,
              style: GoogleFonts.raleway(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                height: 1.1.h,
                color: Colors.black,
                fontFeatures: const [FontFeature.liningFigures()],
              ),
            ),
          ]),
        ),
        16.verticalSpace,
        CustomText(
          text: "Мы пришлём смс с напоминанием за 3 дня до списания.",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.1.h,
        ),
        24.verticalSpace,
        CustomButton(
          onPressed: () {
            onPressed?.call();
            context.popRoute();
          },
          text: 'Подтвердить',
          height: 40.h,
          buttonColor: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        )
      ],
    ),
  );
}
