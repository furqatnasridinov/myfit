import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_text.dart';

class PaymentSection extends StatelessWidget {
  const PaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Consumer(builder: (contex, ref, child) {
          final cardNumber = ref.watch(settingsProvider).cardNumber;
          final event = ref.read(settingsProvider.notifier);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: "Оплата",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              16.verticalSpace,
              AnimationButtonEffect(
                disabled: cardNumber.isNotEmpty,
                child: GestureDetector(
                  onTap: () {
                    if (cardNumber.isEmpty) {
                      event.addCard("**** **** **** 1234");
                    }
                  },
                  child: SizedBox(
                    height: 50.h,
                    width: double.maxFinite,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(color: AppColors.fadedBlueBorder)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: cardNumber.isEmpty
                            ? Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    size: 15.r,
                                    color: AppColors.blueColor,
                                  ),
                                  10.horizontalSpace,
                                  CustomText(
                                    text: "Добавить новую карту",
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  )
                                ],
                              )
                            : Row(
                                children: [
                                  SvgPicture.asset("assets/svg/card_icon.svg"),
                                  10.horizontalSpace,
                                  CustomText(
                                    text: cardNumber,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      //event.deleteCard();
                                    },
                                    child: CustomText(
                                      text: "Удалить карту",
                                      fontSize: 14.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
              ),
              cardNumber.isEmpty ? 0.verticalSpace : 16.verticalSpace,
              if (cardNumber.isNotEmpty)
                Row(
                  children: [
                    Consumer(builder: (contex, ref, child) {
                      final autoRenewal = ref.watch(settingsProvider).autoRenewal;
                      final event = ref.read(settingsProvider.notifier);
                      return CupertinoSwitch(
                        value: autoRenewal,
                        activeColor: AppColors.blueColor,
                        onChanged: (val) {
                          event.toggleAutoRenewal(context, val: val);
                        },
                      );
                    }),
                    10.horizontalSpace,
                    CustomText(
                      text: "Автопродление подписки",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    )
                  ],
                )
            ],
          );
        }));
  }
}
