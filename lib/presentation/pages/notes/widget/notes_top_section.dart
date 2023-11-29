import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesTopSection extends StatelessWidget {
  final ScheduleNotifier event;
  final ScheduleState state;
  final String formattedDay;
  const NotesTopSection(
      {super.key,
      required this.event,
      required this.state,
      required this.formattedDay});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Заметки на",
                style: GoogleFonts.raleway(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
              WidgetSpan(
                child: SizedBox(
                  width: 5.w,
                ),
              ),
              TextSpan(
                text: formattedDay,
                style: GoogleFonts.raleway(
                  color: AppColors.blueColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        //_scheduleItemAction(),
      ],
    );
  }

  scheduleItemAction() {
    return SizedBox(
      width: 90.w,
      height: 40.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // first
          InkWell(
            onTap: () {
              state.isLocationButtonActivated
                  ? event.disnableLocationButton()
                  : event.enableLocationButton();
            },
            child: Container(
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  width: 1.w,
                  color: state.isLocationButtonActivated
                      ? AppColors.blueColor
                      : AppColors.greyBorder,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/svg/location.svg",
                  width: 24.w,
                  height: 24.h,
                  color: state.isLocationButtonActivated
                      ? AppColors.blueColor
                      : Colors.black,
                ),
              ),
            ),
          ),

          // second
          InkWell(
            onTap: () {
              state.isFlashButtonActivated
                  ? event.disnableFlashButton()
                  : event.enableFlashButton();
            },
            child: Container(
              width: 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  width: 1.w,
                  color: state.isFlashButtonActivated
                      ? AppColors.blueColor
                      : AppColors.greyBorder,
                ),
                color: Colors.white,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/svg/activity.svg",
                  width: 24.w,
                  height: 24.h,
                  color: state.isFlashButtonActivated
                      ? AppColors.blueColor
                      : Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
