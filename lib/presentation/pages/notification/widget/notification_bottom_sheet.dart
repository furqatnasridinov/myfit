import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';
import 'package:myfit/presentation/pages/notification/widget/lesson_completed.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class NotificationBottomSheet extends StatelessWidget {
   NotificationBottomSheet({super.key});
final list = DummyData().notifications;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Wrap(
        spacing: 32.h,
        children: [
          // grey line
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 73.w,
              height: 3.h,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.greyBorder,
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),

          32.verticalSpace,

          // icon and text
          Row(
            children: [
              // back icon
              GestureDetector(
                onTap: () {
                  context.popRoute();
                },
                child: SizedBox(
                  height: 40.h,
                  width: 40.w,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.greyBorder,
                        width: 1.w,
                      ),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        "assets/svg/back_icon.svg",
                        width: 5.w,
                        height: 10.h,
                      ),
                    ),
                  ),
                ),
              ),
              10.horizontalSpace,
              // title
              CustomText(
                text: "Новые уведомления",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),

          32.verticalSpace,
          // list of notifications
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 500.h,
            ),
            child: ListView.builder(
              itemCount: list.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final notification = list[index];
                return LessonCompleted(
                  lessonType: notification.lessonType,
                  unread: notification.unread,
                  time: notification.time,
                  gymName: notification.gymName,
                  gymId: notification.gymId,
                );
              },
            ),
          ),

          32.verticalSpace,
          // button
          CustomButton(
            onPressed: () {
              context.router.push(const NotificationRoute());
            },
            text: "Посмотреть все уведомления",
            buttonColor: AppColors.blueColor,
            textColor: Colors.white,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            height: 40.h,
          ),
        ],
      ),
    );
  }
}
