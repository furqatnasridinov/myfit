import 'package:activity/application/registration/registration_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/infrastructure/services/app_validator.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

@RoutePage()
class Registration1Screen extends ConsumerStatefulWidget {
  const Registration1Screen({super.key});

  @override
  ConsumerState<Registration1Screen> createState() =>
      _Registration1ScreenState();
}

class _Registration1ScreenState extends ConsumerState<Registration1Screen> {
  TextEditingController controller = TextEditingController();
  var phoneMask = AppValidators().phoneMask;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final event = ref.read(registrationProvider.notifier);
    final state = ref.watch(registrationProvider);
    debugPrint("phone number ${state.phoneNumber}");
    debugPrint("phone lenth ${state.phoneNumber.length}");
    debugPrint("phone isvalid ${state.isValidPhone}");
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // main body
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // with textfield one

                  CustomCard(
                    child: Column(
                      children: [
                        CustomText(
                          text:
                              "Войдите, используя свой номер телефона. Это быстро и безопасно.",
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        16.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // textfield
                            SizedBox(
                              width: 260.w,
                              height: 40.h,
                              //color: Colors.red,
                              child: TextField(
                                inputFormatters: [phoneMask],
                                //maxLength: 17,
                                maxLines: 1,
                                controller: controller,
                                onChanged: (value) {
                                  event.setPhone(phoneMask.getUnmaskedText());
                                },
                                onTapOutside: (onTapOutside) {
                                  FocusScope.of(context).unfocus();
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  counterStyle: const TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
                                  contentPadding:
                                      EdgeInsets.zero.copyWith(left: 5.w),
                                  hintText: "+7 (900) 855 45-58",
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.greyText,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: state.isValidPhone
                                          ? AppColors.blueColor
                                          : AppColors.greyBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide: BorderSide(
                                      color: state.isValidPhone
                                          ? AppColors.blueColor
                                          : AppColors.greyBorder,
                                      width: 1.w,
                                    ),
                                  ),
                                  prefixIcon: Container(
                                    margin: EdgeInsets.all(5.r),
                                    padding: EdgeInsets.all(5.r),
                                    width: 28.w,
                                    height: 28.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.backgroundColor,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: SvgPicture.asset(
                                      "assets/svg/phone_icon.svg",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // button
                            InkWell(
                              onTap: () {
                                if (state.isValidPhone) {
                                  event.sendPhoneNumber(
                                    "+${state.phoneNumber}",
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: state.isValidPhone
                                      ? AppColors.blueColor
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: EdgeInsets.all(5.r),
                                child: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 20.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  32.verticalSpace,
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            elevation: 0,
                            insetPadding:
                                REdgeInsets.symmetric(horizontal: 16.w),
                            child: CustomCard(
                                height: 270.h,
                                borderColor: Colors.transparent,
                                width: double.maxFinite,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      text: "Внимание!",
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    16.verticalSpace,
                                    CustomText(
                                      text: AppConstants.warningText,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    16.verticalSpace,
                                    CustomButton(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      buttonColor: AppColors.blueColor,
                                      textColor: Colors.white,
                                      height: 40.h,
                                      onPressed: () {
                                        context.popRoute();
                                      },
                                      text: "Регистрация по номеру телефона",
                                    ),
                                    5.verticalSpace,
                                    CustomButton(
                                      buttonColor: Colors.white,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      height: 40.h,
                                      onPressed: () {
                                        context.replaceRoute(const MainRoute());
                                      },
                                      text: "Понимаю. Всё равно пропустить",
                                    )
                                  ],
                                )),
                          );
                        },
                      );
                    },
                    child: InterText(
                      text: "Пропустить",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // waves
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              child: SvgPicture.asset(
                "assets/svg/Vector 13.svg",
                width: width,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
