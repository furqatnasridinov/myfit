import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/notification/notification_notifier.dart';
import 'package:myfit/application/notification/notification_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_switch.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';

class SectionWithSwitch extends StatelessWidget {
  const SectionWithSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Consumer(
        builder: (context, ref, child) {
          final bool showOnlyNew = ref.watch(notificationProvider).showNewOnly;
          final NotificationNotifier notifier = ref.read(notificationProvider.notifier);
          return Row(
            children: [
              Expanded(
                child: SizedBox(
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
                            CustomSwitch(
                              value: showOnlyNew,
                              onChanged: (value) {
                                notifier.toggleShowNewOnly(value);
                              },
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
              ),
              // three dots
              10.horizontalSpace,
              UiDropDownMenu(
                maxWidth: 300.w,
                customOffset: [-45.0.w, -40.h],
                dropDownItemsList: [
                  {
                    'title': 'Отметить всё прочитанным',
                    'icon': SvgPicture.asset('assets/svg/doneAll.svg'),
                    'action': () {
                      // уже в базе мы отмечали как прочитанным при открытии bottom sheet
                      notifier.getAllNotifications();
                    },
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
          );
        },
      ),
    );
  }
}
