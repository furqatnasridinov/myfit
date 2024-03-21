import 'package:activity/application/main2/main2_notifier.dart';
import 'package:activity/application/main2/main2_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingActivity extends StatelessWidget {
  final Main2State state;
  final Main2Notifier event;
  const ComingActivity({super.key, required this.state, required this.event});

  @override
  Widget build(BuildContext context) {
    List<String> parts = state.nearestLesson!.bodyData!.date!.split("@");
    final today = event.dateTimeNowToString(DateTime.now());
    final String formattedDay = event.formatDay(parts[0]);
    return UiCard(
      cardValue: Column(
        children: [
          Row(
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
                  text: state.lessonIsAlreadyStarted
                      ? "Занятие уже началось"
                      : "через ${state.whenActivityStarts}",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText,
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Column(children: [
            sectionBuilder(
              Icons.flash_on_outlined,
              state.nearestLesson?.bodyData?.description ?? "Empty",
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
              state.nearestLesson?.bodyData?.gym?.address ?? "Empty",
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
