// ignore_for_file: division_optimization
import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../router/app_router.gr.dart';

class MySubscribtion extends StatelessWidget {
  const MySubscribtion({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final event = ref.read(settingsProvider.notifier);
        final bool autoRenewal = ref.watch(settingsProvider).autoRenewal;
        final currentSubscribtion =
            ref.watch(settingsProvider).currentSubscribtion;
        final String pricePerMonth = currentSubscribtion?.subscription !=
                    null &&
                currentSubscribtion?.subscription?.durationInMonth != 0
            ? ((currentSubscribtion?.subscription?.price ?? 0) /
                    (currentSubscribtion?.subscription?.durationInMonth ?? 1))
                .toInt()
                .toString()
            : '0';
        return currentSubscribtion == null
            ? const SizedBox.shrink()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Моя подписка",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      GestureDetector(
                        onTap: () {
                          context.router
                              .push(const SubscribtionSettingsRoute());
                        },
                        child: CustomText(
                          text: "Настроить",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blueText,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Container(
                    padding: EdgeInsets.all(1.r),
                    decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      gradient:  const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFEBC072),
                          Color(0xFF9A49C9),
                        ],
                        stops: [-0.4115, 1.3761],
                      ),
                    ),
                    child: Container(
                      width: double.maxFinite,
                      height: 113.h,
                      //padding: EdgeInsets.all(16.r),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.r),
                        /* border: Border.all(
                          color: const Color(0xFFEBC072), width: 1.0), */
                        boxShadow: const [
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
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFEBC072),
                            Color(0xFF9A49C9),
                          ],
                          stops: [-0.4115, 1.3761],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 32.w),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 80.w,
                                  height: 80.h,
                                  child: Image.asset(
                                    'assets/images/corona.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                16.horizontalSpace,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text:
                                          "Подписка на ${AppHelpers().getMonthWord(currentSubscribtion.subscription?.durationInMonth ?? 0)}",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: '₽$pricePerMonth',
                                            style: GoogleFonts.raleway(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                              fontFeatures: const [
                                                FontFeature.liningFigures()
                                              ],
                                            ),
                                          ),
                                          TextSpan(
                                            text: " в месяц",
                                            style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: double.maxFinite,
                              child: Image.asset(
                                "assets/images/subs_line.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  10.verticalSpace,
                  CustomText(
                    text: autoRenewal
                        ? "Списание произойдёт ${AppHelpers.getAutoRenewalDay(event.getEndDateOfCurrentSub())}"
                        : "Истекает ${event.getWhenCurrentSubEnds(currentSubscribtion.endData ?? "")}",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  32.verticalSpace,
                ],
              );
      },
    );
  }
}

/* Widget noSubscription() {
  return Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: "У вас нет подписки",
          style: GoogleFonts.raleway(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        TextSpan(
          text: " Подпишитесь на подписку, чтобы получить доступ ко всем функциям приложения",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
    ),);
} */
