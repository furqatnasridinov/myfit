import 'package:activity/application/main2/main2_notifier.dart';
import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingActivity extends StatelessWidget {
  final GetNearestLesson nearestLesson;
  final Main2Notifier event;
  const ComingActivity(
      {super.key, required this.event, required this.nearestLesson});

  @override
  Widget build(BuildContext context) {
    List<String> parts = nearestLesson.bodyData!.date!.split("@");
    final today = event.dateTimeNowToString(DateTime.now());
    final String formattedDay = event.formatDay(parts[0]);
    return UiCard(
      cardValue: Column(
        children: [
          Consumer(builder: (context, ref, child) {
            final lessonIsAlreadyStarted = ref.watch(main2Provider).lessonIsAlreadyStarted;
            final whenActivityStarts = ref.watch(main2Provider).whenActivityStarts;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    child: CustomText(
                      text: 'Ближайшее событие:',
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: CustomText(
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    text: lessonIsAlreadyStarted
                        ? "Занятие уже началось"
                        : "через $whenActivityStarts",
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyText,
                  ),
                )
              ],
            );
          }),
          SizedBox(height: 10.h),
          Column(children: [
            sectionBuilder(
              Icons.flash_on_outlined,
              nearestLesson.bodyData?.description ?? "Empty",
            ),
            10.verticalSpace,
            sectionBuilder(
              Icons.watch,
              today == formattedDay
                  ? "${parts[1]}, Сегодня"
                  : "${parts[1]}, $formattedDay",
            ),
            10.verticalSpace,
            sectionBuilder(
              Icons.location_on_outlined,
              nearestLesson.bodyData?.gym?.address ?? "Empty",
            ),
          ]),
        ],
      ),
    );
  }
}

Widget sectionBuilder(IconData icondata, String text) {
  return Container(
    padding: const EdgeInsets.all(10.0),
    decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.fadedBlueBorder)),
    child: Row(
      children: [
        Icon(icondata, size: 18.r, color: AppColors.blueColor),
        7.horizontalSpace,
        Flexible(
          child: CustomText(
            text: text,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}
