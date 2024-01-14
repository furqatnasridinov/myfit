import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Contacts extends StatelessWidget {
  final ActivityNotifier event;
  const Contacts({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    // event.getNameFromTgUrl("https://t.me/furqatnasridinov");
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Контакты",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          10.verticalSpace,
          Consumer(builder: (context, ref, child) {
            final state = ref.watch(activityProvider);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    event.callTo(
                      state.gym?.phone ?? "+79650292555",
                    );
                  },
                  child: SizedBox(
                    width: 165.w,
                    //color: Colors.red,
                    //height: 24.h,
                    child: Row(
                      children: [
                        SvgPicture.asset("assets/svg/phone.svg"),
                        10.horizontalSpace,
                        CustomText(
                          text: state.gym?.phone ?? "+7 (965) 029 25-55",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.gym?.telegram != null)
                  telegram(() {
                    event.launchTelegram(state.gym?.telegram ?? "");
                  }, event.getNameFromTgUrl(state.gym?.telegram ?? "")),
                if (state.gym?.telegram == null && state.gym?.vk != null)
                  vk(() {
                    event.launchVk(state.gym?.vk ?? "");
                  }, event.getNameFromVkUrl(state.gym?.vk ?? ""))
              ],
            );
          }),
        ],
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
