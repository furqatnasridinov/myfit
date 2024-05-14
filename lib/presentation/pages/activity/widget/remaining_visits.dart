import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:myfit/presentation/pages/activity/skeletons/remaining_visits_skeleton.dart';

class RemainingVisits extends StatelessWidget {
  const RemainingVisits({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Consumer(
        builder: (context, ref, child) {
          final gym = ref.watch(activityProvider).gym;
          int? visitRemaining = (gym?.visitPerMonth ?? 0) - (gym?.visitedCount ?? 0);
          final loading = ref.watch(activityProvider).isGymLoading;
          return loading ? const RamainingVisitsSkeleton() : SizedBox(
            width: double.maxFinite,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(color: AppColors.greyBorder),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child:  Row(
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
        },
      ),
    );
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
                        text:
                            "Занятия этого заведения пополнятся ${currentSub?.endDataFormatted}",
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
                  ),
                  16.verticalSpace,
                  CustomText(
                    text:
                        "Количество оставшихся посещений всегда отображается на экране поиска занятий и в подробной карточке заведения.",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
            ));
      });
}
