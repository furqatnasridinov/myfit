// ignore_for_file: use_build_context_synchronously
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/presentation/components/skeleton_card.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class TheOneWithCalendar extends StatelessWidget {
  final ActivityNotifier event;
  final int gymId;
  final ItemScrollController itemScrollController;

  const TheOneWithCalendar({
    super.key,
    required this.event,
    required this.gymId,
    required this.itemScrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final listOf45CalendarDaysFromNow = ref.watch(activityProvider).listOf45CalendarDaysFromNow;
        final daysInWhichWeHaveLessons = ref.watch(activityProvider).daysInWhichWeHaveLessons;
        final selectedCalendarDay = ref.watch(activityProvider).selectedCalendarDay;
        final loading = ref.watch(activityProvider).isSchedulesLoading;
        final bool isCalendarLimited = ref.watch(activityProvider).isCalendarLimited;
        if (listOf45CalendarDaysFromNow.isEmpty) {
          return const SizedBox();
        }
        return /* loading ? const CalendarSkeleton() : */ Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loading
                ? SkeletonCard(width: 220.w)
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: CustomText(
                      text: "Выберите дату и удобное время",
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: Colors.black,
                    ),
                  ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.only(left: 16.w, bottom: 16.h),
              child: SizedBox(
                //color: Colors.green.shade300,
                height: 75.h,
                //padding: EdgeInsets.symmetric(vertical: 4.w),
                width: double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.w),
                  child: ScrollablePositionedList.builder(
                  itemCount: listOf45CalendarDaysFromNow.length + (isCalendarLimited ? 1 : 0),
                  scrollDirection: Axis.horizontal,
                  itemScrollController: itemScrollController,
                  itemBuilder: (context, index) {
                    if (index == listOf45CalendarDaysFromNow.length && isCalendarLimited) {
                      return wantToSeeMoreButton(context);
                    }
                    final String currentDate = listOf45CalendarDaysFromNow[index].formattedCalendarDay;
                    bool isAvailable = daysInWhichWeHaveLessons.contains(currentDate);
                    bool isSelected = selectedCalendarDay == currentDate;
                    final parts = currentDate.split(" ");
                    if (loading) {
                      return Padding(
                            padding: EdgeInsets.only(right: 9.w),
                            child: SkeletonCard(width: 41, height: 70.h),
                          );
                    }
                    return GestureDetector(
                        onTap: () async {
                          if (isAvailable && currentDate != selectedCalendarDay) {
                            await event.setSelectedCalendarDay(currentDate);
                            event.getLessonsToShowAfterSelectingADay(currentDate);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 9.w),
                          child: AnimationButtonEffect(
                            disabled: isAvailable ? false : true,
                            child: SizedBox(
                              //color: Colors.red,
                              width: 41.w,
                              child: Card(
                                margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h),
                                shadowColor: const Color.fromRGBO(123, 163, 225, 0.73),
                                elevation: isSelected ? 2.1 : 0,
                                color: isSelected ? AppColors.blueColor : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  side: BorderSide(color: isSelected ? AppColors.blueColor
                                          : isAvailable ? AppColors.greyBorder : Colors.transparent,
                                      width: 1.w),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    InterText(
                                      text: parts[0].toUpperCase(),
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : isAvailable
                                              ? Colors.black: const Color.fromRGBO(176, 176, 176, 1),
                                    ),
                                    3.verticalSpace,
                                    CustomText(
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w500,
                                        text: parts[1],
                                        color: isSelected
                                            ? Colors.white : isAvailable ? Colors.black
                                                : const Color.fromRGBO(176, 176, 176, 1)),
                                    CustomText(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w500,
                                      text: parts[2],
                                      color: isSelected ? Colors.white : isAvailable
                                              ? Colors.black : const Color.fromRGBO(176,176,176,1),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),);
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget wantToSeeMoreButton(BuildContext context){
    return AnimationButtonEffect(
      child: GestureDetector(
        onTap: () {
        showSeeMoreInfoPopUp(context);
        },
        child: Container(
        width: 82.w,
        height: 70.h,
        margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 2.h).copyWith(right: 20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.blueColor, width: 1.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/svg/question.svg",
            ),
            5.verticalSpace,
            Flexible(
              child: CustomText(
                text: "Хочу видеть больше дней",
                fontSize: 10.sp,
                fontWeight: FontWeight.w500,
                height: 1.1,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
          ),
      ),
    );
}

void showSeeMoreInfoPopUp(BuildContext context) {
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
                  text: "Почему я вижу не весь календарь записи?",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
                16.verticalSpace,
                CustomText(
                  text:"Дело в том, что ваш диапазон дат для записи ограничен оплаченным периодом",
                  fontSize: 14.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
                ),
                16.verticalSpace,
                CustomText(
                  text:"Как только пройдёт оплата за следующий период - в расписании появятся новые дни для записи.",
                  fontSize: 14.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
                ),
                16.verticalSpace,
                CustomText(
                  text:"Если вам хочется иметь возможность записываться заранее за полтора или два месяца - попробуйте подписку на 3 месяца.",
                  fontSize: 14.sp,
                  height: 1.1,
                  fontWeight: FontWeight.w400,
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
          ),
        );
      });
}