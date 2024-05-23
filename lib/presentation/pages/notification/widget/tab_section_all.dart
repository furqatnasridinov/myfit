import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';

import 'widget.dart';

class TabSectionAll extends StatelessWidget {
  const TabSectionAll({super.key});

  @override
  Widget build(BuildContext context) {
    final list = DummyData().notifications;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 16.h),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    height: 40.h,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.greyBorder,
                          width: 1.w,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: 0.8,
                                child: CupertinoSwitch(
                                  value: false,
                                  activeColor: AppColors.blueColor,
                                  onChanged: (val) {},
                                ),
                              ),
                              16.horizontalSpace,
                              CustomText(
                                text: "Отображать только новые",
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ],
                          )),
                    ),
                  ),
                  // three dots
                  const Spacer(),
                  UiDropDownMenu(
                    maxWidth: 300.w,
                    customOffset: [-45.0.w, -40.h],
                    dropDownItemsList: [
                      {
                        'title': 'Отметить всё прочитанным',
                        'icon': SvgPicture.asset('assets/svg/doneAll.svg'),
                        'action': () {},
                      },
                    ],
                    dropDownChild: AnimationButtonEffect(
                      child: SizedBox(
                        height: 40.h,
                        width: 40.w,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColors.greyBorder,
                              width: 1.w,
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.more_vert,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              ListView.builder(
                itemCount: list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final notification = list[index];
                  if (notification.type == NotificationType.lessonCompleted) {
                    return LessonCompleted(
                      lessonType: notification.lessonType,
                      unread: notification.unread,
                      time: notification.time,
                      gymName: notification.gymName,
                      gymId: notification.gymId,
                    );
                  }
                  if (notification.type == NotificationType.lessonConfirmed) {
                    return LessonConfirmed(
                      lessonType: notification.lessonType,
                      unread: notification.unread,
                      description: notification.description,
                      time: notification.time,
                      gymName: notification.gymName,
                      gymId: notification.gymId,
                    );
                  }
                  if (notification.type == NotificationType.lessonCancelled) {
                    return LessonCancelled(
                      lessonType: notification.lessonType,
                      unread: notification.unread,
                      time: notification.time,
                      gymName: notification.gymName,
                      gymId: notification.gymId,
                      reason: notification.reason ?? "",
                      visitsLeft: notification.visitsLeft,
                      tottalVisits: notification.tottalVisits,
                    );
                  }
                  if (notification.type == NotificationType.lessonChanged) {
                    return LessonChanged(
                      lessonType: notification.lessonType,
                      unread: notification.unread,
                      time: notification.time,
                      gymName: notification.gymName,
                      gymId: notification.gymId,
                      updates: notification.body,
                    );
                  }
                  if (notification.type == NotificationType.visitsCountIsGettingLowOrEnded) {
                    return VisitsCountEnding(
                      lessonType: notification.lessonType,
                      unread: notification.unread,
                      title: notification.title,
                      description: notification.description,
                      time: notification.time,
                      gymName: notification.gymName,
                      gymId: notification.gymId,
                      visitsLeft: notification.visitsLeft,
                      tottalVisits: notification.tottalVisits,
                    );
                  }
                  if (notification.type == NotificationType.lessonStartsWithin15minutes) {
                    return LessonStartsWithin15Minutes(
                      lessonType: notification.lessonType,
                      unread: notification.unread,
                      time: notification.time,
                      gymName: notification.gymName,
                      gymId: notification.gymId,
                      visitsLeft: notification.visitsLeft,
                      tottalVisits: notification.tottalVisits,
                    );
                    
                  }
                },
              ),
            ],
          ),
        ));
  }
}
