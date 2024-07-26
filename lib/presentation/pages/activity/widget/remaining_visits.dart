// ignore_for_file: use_build_context_synchronously

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/models/response/gym_response.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/components/shake_widget.dart';
import 'package:myfit/presentation/pages/activity/skeletons/remaining_visits_skeleton.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class RemainingVisits extends StatelessWidget {
   final GlobalKey<ShakeWidgetState> shakeKey;
   RemainingVisits({super.key, required this.shakeKey});
  
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final gym = ref.watch(activityProvider).gym;
      int? visitRemaining = (gym?.visitPerMonth ?? 0) - (gym?.visitedCount ?? 0);
      final loading = ref.watch(activityProvider).isGymLoading;
      final currentSub = ref.watch(settingsProvider).currentSubscribtion;
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 32.h),
            child: loading
                ? const RamainingVisitsSkeleton()
                : (!loading && currentSub == null)
                    ? ShakeWidget(
                      key: shakeKey,
                      shakeOffset: 10,
                      shakeCount: 3,
                      shakeDuration: const Duration(milliseconds: 400),
                      child: dontHaveSubCard(),
                      )
              : visitsRemainCard(visitRemaining, gym, context)
        );
    },);
  }
}

void showInfoPopUp(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              side: const BorderSide(
                color: AppColors.blueBorder,
              ),
            ),
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final currentSub =
                          ref.watch(settingsProvider).currentSubscribtion;
                      return CustomText(
                        text:"Занятия этого заведения пополнятся ${currentSub?.endDataFormatted}",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      );
                    },
                  ),
                  16.verticalSpace,
                  CustomText(
                    text:
                        "Как правило, каждое заведение выделяет для пользователей MyFit от 8 до 12 посещений в месяц. Если в одном зале посещения закончились - вы можете пойти в другой, заведений очень много, пробуйте новое без переплат!",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                  16.verticalSpace,
                  CustomText(
                    text:
                        "Количество оставшихся посещений всегда отображается на экране поиска занятий и в подробной карточке заведения.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                ],
              ),
            ));
      });
}

Widget visitsRemainCard(int? visitRemaining,GymResponse? gym, BuildContext context){
  return SizedBox(
    width: double.maxFinite,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.greyBorder),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InterText(
              text: "Осталось походов в этом месяце: ",
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
            2.horizontalSpace,
            InterText(
              text: "$visitRemaining/${gym?.visitPerMonth}",
              fontSize: 12.sp,
              height: 1.3,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                showInfoPopUp(context);
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
      ),
    ),
  );
}

Widget dontHaveSubCard(){
  return Consumer(builder: (context, ref, child) {
    final bool isRed = ref.watch(activityProvider).showAnimationDontHaveSubs;
    return AnimatedContainer(
    duration: Durations.long1,
    width: double.maxFinite,
     decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(6.r),
      border: Border.all(color: isRed ? AppColors.redBorder : AppColors.greyBorder),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InterText(
            text: "У вас нет активной подписки",
            fontSize: 13.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              showNoSubPopUp(context);
            },
            child: Container(
              width: 26.w,
              height: 26.h,
              padding: EdgeInsets.all(3.5.r),
              decoration: const  BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.backgroundColor
              ),
              child: SvgPicture.asset(
                "assets/svg/question.svg",
              ),
            ),
          )
        ],
      ),
    ),
  );
  },);
}

void showNoSubPopUp(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
              side: const BorderSide(
                color: AppColors.blueBorder,
              ),
            ),
            elevation: 0,
            insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: "У вас нет активной подписки",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  16.verticalSpace,
                  CustomText(
                    text: AppConstants.loremIpsum,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                  16.verticalSpace,
                  Consumer(
                  builder: (context, ref, child) {
                    final bool loading = ref.watch(activityProvider).buttonLoading;
                    final notifier = ref.read(activityProvider.notifier);
                    return CustomButton(
                      onPressed: () async{
                        notifier.setButtonLoading(true);
                        await ref.read(settingsProvider.notifier).getReferalInfo(context);
                        await ref.read(settingsProvider.notifier).getAllAvailableSubscribtions(context);
                        notifier.setButtonLoading(false);
                        context.router.pop();
                        context.router.push(const SubscribtionSettingsRoute());
                      },
                      text: "Настройки подписки",
                      buttonColor: AppColors.blueColor,
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      height: 40.h,
                      showProgress: loading,
                      fontWeight: FontWeight.w500,
                    );
                  },
                ),
                ],
              ),
            ));
      });
}
