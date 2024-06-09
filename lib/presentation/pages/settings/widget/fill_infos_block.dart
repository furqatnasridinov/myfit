import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/pages/settings/widget/pop_up_body.dart';

class FillInfosBlock extends StatelessWidget {
  const FillInfosBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final missingInfos = ref.watch(settingsProvider).missingInfo;
        if (missingInfos.isEmpty) {
          return const SizedBox.shrink();
        } else {
          return Padding(
            padding: EdgeInsets.only(top: 32.h),
            child: CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset("assets/svg/infoOutlined.svg"),
                      10.horizontalSpace,
                      CustomText(
                        text: "Заполните свой профиль",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
                  12.verticalSpace,
                  CustomText(
                    text: AppConstants.fiilYourProfileLongText,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.1,
                  ),
                  10.verticalSpace,
                  CustomButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 0,
                            insetPadding:EdgeInsets.symmetric(horizontal: 16.w),
                            child: Consumer(builder: (context, ref, child) {
                              final stateConsumer = ref.watch(settingsProvider);
                              final eventConsumer = ref.read(settingsProvider.notifier);
                              return PopupBody(
                                event: eventConsumer,
                                state: stateConsumer,
                              );
                            }),
                          );
                        },
                      );
                    },
                    text: "Перейти в настройки профиля",
                    textColor: Colors.black,
                    buttonColor: Colors.white,
                    height: 40.h,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
