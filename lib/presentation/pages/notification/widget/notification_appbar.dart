import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class NotificationAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(245, 249, 255, 0.5),
      //color: Colors.red,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 5.h),
          child: Row(
           // mainAxisAlignment: MainAxisAlignment.end,
            children: [
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
              Text(
                "Ваши уведомления",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              // avatar
              GestureDetector(
                onTap: () {
                  context.router.push(const SettingsRoute());
                },
                child: Consumer(
                  builder: (context, ref, child) {
                    final avatar = ref.watch(settingsProvider).avatar;
                    final missingInfos = ref.watch(settingsProvider).missingInfo;
                    return Stack(children: [
                      CircleAvatar(
                          radius: 20.r,
                          backgroundColor: missingInfos.isEmpty
                              ? AppColors.blueColor
                              : AppColors.redBorder,
                          child: avatar.isEmpty
                              ? CircleAvatar(
                                  radius: 17.r,
                                  backgroundImage: const AssetImage(
                                      AppConstants.cristianBale))
                              : CircleAvatar(
                                  radius: 17.r,
                                  backgroundImage: NetworkImage(
                                      "http://77.222.53.122/image/$avatar"),
                                  onBackgroundImageError:
                                      (exception, stackTrace) {
                                    debugPrint(exception.toString());
                                  },
                                )),
                      if (missingInfos.isNotEmpty)
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 15.w,
                            height: 15.h,
                            decoration: const BoxDecoration(
                              color: AppColors.redBorder,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: CustomText(
                                  text: missingInfos.length.toString(),
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                    ]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(55.h);
}
