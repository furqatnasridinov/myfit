import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Contacts extends StatelessWidget {
  final ActivityNotifier event;
  const Contacts({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Consumer(
        builder: (context, ref, child) {
          //final state = ref.watch(activityProvider);
          final phone = ref.watch(activityProvider).gym?.phone;
          final gymTelegram = ref.watch(activityProvider).gym?.telegram;
          final gymVk = ref.watch(activityProvider).gym?.vk;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Контакты",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              10.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      event.callTo(
                        phone ?? "+79650292555",
                      );
                    },
                    child: SizedBox(
                      width: 165.w,
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/svg/phone.svg"),
                          10.horizontalSpace,
                          CustomText(
                            text: phone ?? "Не указан",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (gymTelegram != null && gymTelegram != "")
                    telegram(() {
                      event.launchTelegram(gymTelegram);
                    }, gymTelegram),
                  if ((gymTelegram == null || gymTelegram == "") && gymVk != null)
                    vk(() {
                      event.launchVk(gymVk);
                    }, gymVk)
                ],
              ),
              32.verticalSpace,
              CustomText(
                text: "Описание",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              5.verticalSpace,
              InterText(
                text: ref.watch(activityProvider).gym?.description ?? "",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
              )
            ],
          );
        },
      ),
    );
  }
}

Widget telegram(void Function()? onTap, String? text) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 165.w,
      //color: Colors.red,
      //height: 24.h,
      child: Row(
        children: [
          SvgPicture.asset("assets/svg/tg.svg"),
          10.horizontalSpace,
          Flexible(
            child: CustomText(
              text: text ?? "",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget vk(
  void Function()? onTap,
  String? text,
) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      width: 165.w,
      //color: Colors.red,
      //height: 24.h,
      child: Row(
        children: [
          SvgPicture.asset("assets/svg/vk.svg"),
          10.horizontalSpace,
          CustomText(
            text: text ?? "",
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    ),
  );
}
