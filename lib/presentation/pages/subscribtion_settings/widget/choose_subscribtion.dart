// ignore_for_file: division_optimization, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/settings/settings_notifier.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/models/data/user_subscribtion.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';

class ChooseSubscribtion extends StatelessWidget {
  void Function()? onTap;
  ChooseSubscribtion({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
            final List<Subscription> allSubs = ref.watch(settingsProvider).allAvailableSubscriptions;
            final UserSubscription? nextSub = ref.watch(settingsProvider).nextSubscribtion;
            final UserSubscription? currentSub = ref.watch(settingsProvider).currentSubscribtion;
            final String cardNumber = ref.watch(settingsProvider).cardNumber;
            final notifier = ref.read(settingsProvider.notifier);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  itemBuilder: (context, index) {
                    final current = allSubs[index];
                    return eachSubscription(
                      index,
                      currentSub?.subscription?.id ?? 0,
                      context,
                      current.durationInMonth.toString(),
                      current.priceAfterPromocode == 0.0 ? current.price.toString() : current.priceAfterPromocode!.toStringAsFixed(0),
                      current.price ?? 0,
                      current.priceAfterPromocode ?? 0.0,
                      AppHelpers.getCostPerMonth(current.price ?? 0, current.priceAfterPromocode ?? 0.0, current.durationInMonth ?? 0),
                      "Оплата раз в ${AppHelpers().getMonthWord(int.parse(current.durationInMonth.toString()))} и посещение сотен разных активностей",
                      currentSub?.subscription?.id == current.id,
                      nextSub?.subscription?.id == current.id,
                      cardNumber,
                      ref.watch(settingsProvider).isChangeSubscribtionLoading,
                      ref.watch(settingsProvider).autoRenewal,
                      notifier,
                      () {
                        if (currentSub != null) {
                          notifier.changeNextSubscription(context,id: current.id ?? 0);
                        } else {
                          notifier.purchaseSubscription(context,
                              id: current.id ?? 0,
                              autoRenewal:ref.watch(settingsProvider).autoRenewal);
                        }
                      },
                    );
                  },
                  itemCount: allSubs.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
                if (currentSub != null && nextSub != null)
                  CustomText(
                    text: getInfoText(
                      autoRenewal: ref.watch(settingsProvider).autoRenewal,
                      currentSub: currentSub,
                      nextSub: nextSub,
                      endDate: notifier.getEndDateOfCurrentSub(),
                    ),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1.h,
                    textAlign: TextAlign.start,
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
    int index,
    int currentSubId,
    BuildContext context,
    String month,
    String priceOfSub,
    int initialPrice,
    double priceAfterPromocode,
    String pricePerMonth,
    String description,
    bool isCurrentSub,
    bool isNextSub,
    String cardNumber,
    bool loading,
    bool isAutoRenewal,
    SettingsNotifier notifier,
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
                child: dialogContent(context, month, priceOfSub, cardNumber, onTap),
              );
            },
          );
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
                      color: isNextSub ? AppColors.purpleText : AppColors.fadedBlueBorder),
                  shape: BoxShape.circle,
                ),
                child: isNextSub
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
                padding: EdgeInsets.all(1.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                      color: isCurrentSub ? Colors.transparent : AppColors.fadedBlueBorder),
              gradient: isCurrentSub
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFFEBC072).withOpacity(0.8),
                        const Color(0xFF9A49C9),
                      ],
                      stops: const [-0.4115, 1.3761],
                    )
                  : null,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: isCurrentSub
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
                  gradient: isCurrentSub
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text:AppHelpers().getMonthWord(int.parse(month)),
                                style: GoogleFonts.raleway(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  fontFeatures: const [
                                    FontFeature.liningFigures()
                                  ],
                                  color: isCurrentSub ? Colors.white : AppColors.purpleText,
                                ),
                              ),
                              TextSpan(
                                text: (isNextSub  && isAutoRenewal)? " (c ${notifier.getEndDateOfCurrentSub()})" : isCurrentSub ? 
                                        (" (до ${notifier.getEndDateOfCurrentSub()})") : "",
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  fontFeatures: const [FontFeature.liningFigures()],
                                  color: isCurrentSub ? Colors.white : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [
                                  if (priceAfterPromocode != 0.0 &&
                                      priceOfSub != initialPrice.toString())
                                    CustomText(
                                      text: "₽$initialPrice",
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.lineThrough,
                                      decorationColor: isCurrentSub
                                          ? Colors.white
                                          : Colors.black,
                                      color: isCurrentSub
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                    3.horizontalSpace,
                                  CustomText(
                                    text: "₽$priceOfSub",
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: isCurrentSub ? Colors.white : Colors.black,
                                  ),
                                ],
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
                                        color: isCurrentSub ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    WidgetSpan(child: 4.horizontalSpace),
                                    TextSpan(
                                      text: "в месяц",
                                      style: GoogleFonts.raleway(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        color: isCurrentSub ? Colors.white  : Colors.black,
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
                      color: isCurrentSub ? Colors.white : AppColors.greyText,
                    ),
                  ],
                ),
              ),
            ),
          )),
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
    child: Consumer(
      builder: (context, ref, child) {
        final notifier = ref.read(settingsProvider.notifier);
        final currentSub = ref.watch(settingsProvider).currentSubscribtion;
        return Column(
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
                  "Сейчас у вас активна подписка “${currentSub?.subscription?.description}”, она закончится ${notifier.getEndDateOfCurrentSub()}, после чего тариф сменится на “${AppHelpers().getMonthWord(int.parse(month))}”.",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.1.h,
            ),
            16.verticalSpace,
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: notifier.getEndDateOfCurrentSub(),
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
            Consumer(
              builder: (context, ref, child) {
                final bool loading =
                    ref.watch(settingsProvider).isChangeSubscribtionLoading;
                return CustomButton(
                  onPressed: onPressed,
                  text: loading ? "Подтверждение..." : 'Подтвердить',
                  height: 40.h,
                  buttonColor: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                );
              },
            ),
          ],
        );
      },
    ),
  );
}


String getInfoText({
  required bool autoRenewal,
  required UserSubscription? currentSub,
  required UserSubscription? nextSub,
  required String endDate,
}) {
  if (autoRenewal) {
    if (currentSub?.subscription?.id == nextSub?.subscription?.id) {
      return "Ваш тариф: “${currentSub?.subscription?.description}” закончится $endDate, после чего подписка продлится автоматически.";
    }
    return "Ваш тариф: “${currentSub?.subscription?.description} закончится $endDate, после чего подписка сменится на “${nextSub?.subscription?.description}.";
  } else {
    return "Ваш тариф: “${currentSub?.subscription?.description}” закончится $endDate.";
  }
}
