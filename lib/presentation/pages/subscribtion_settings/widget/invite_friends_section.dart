import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_card.dart';

class InviteFriendsSection extends StatelessWidget {
  const InviteFriendsSection({super.key});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ).copyWith(top: 32.h),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomText(
                  text: "Пригласите друзей - получите подписку в подарок!",
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  height: 1,
                ),
              ),
              10.horizontalSpace,
              GestureDetector(
                onTap: () {
                  showInviteInfoPopUp(context);
                },
                child: Container(
                  width: 26.w,
                  height: 26.h,
                  padding: EdgeInsets.all(3.5.r),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: SvgPicture.asset(
                    "assets/svg/question.svg",
                  ),
                ),
              ),
            ],
          ),
          16.verticalSpace,
          CustomCard(
            child: Column(
              children: [
                CustomText(
                  text: AppConstants.inviteFriendLongText2,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
                16.verticalSpace,
                CustomText(
                  text:
                      "Друзья должны перейти именно по вашей ссылке, скопируйте её из поля ниже:",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
                16.verticalSpace,
                // textfield and copy button
                SizedBox(
                  height: 40.h,
                  child: Row(
                    children: [
                      Expanded(
                        child: buildTextField(),
                      ),
                      10.horizontalSpace,
                      AnimationButtonEffect(
                        child: GestureDetector(
                          onTap: () {
                            // copy to clipboard
                            Clipboard.setData(const ClipboardData(text: "myfit.ru/invite/adv23rd"));
                            AppHelpers.showCustomBottomSnack(
                              context, 
                              "Ссылка для приглашения скопирована в буфер обмена",
                              "assets/svg/copy.svg",
                              marginBottom: Platform.isIOS ? 25 : 110, // в андроиде снизу открывается дефолтная всплывашка
                              );
                          },
                          child: SizedBox(
                            width: 40.w,
                            height: 40.h,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                  color: AppColors.blueColor,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border:
                                      Border.all(color: AppColors.blueBorder)),
                              child: Padding(
                                padding: EdgeInsets.all(9.r),
                                child: SvgPicture.asset(
                                  "assets/svg/copy.svg",
                                  colorFilter: const ColorFilter.mode(
                                      Colors.white, BlendMode.srcIn),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // three progress indicators
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: 30.h,
                            //width: 100.w, //
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: AppColors.fadedPrimary3,
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(color: AppColors.fadedBlueBorder),
                              ),
                              child: const Center(
                                child: SizedBox(),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:  EdgeInsets.all(5.r),
                              child: SizedBox(
                                height: 20.h,
                                width: double.infinity,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryFadedBorder,
                                    borderRadius: BorderRadius.circular(16.r),
                                   /*  gradient:  LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        AppColors.blueColor.withOpacity(0.26),
                                        AppColors.blueBorder.withOpacity(0.49),
                                      ],
                                    ), */
                                  ),
                                  child: Icon(Icons.done, color: Colors.white, size: 16.sp),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: SizedBox(
                        height: 30.h,
                        //width: 100.w, //
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.fadedPrimary3,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.fadedBlueBorder),
                          ),
                          child: Center(
                            child: SvgPicture.asset("assets/svg/user.svg"),
                          ),
                        ),
                        
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: SizedBox(
                        height: 30.h,
                        //width: 100.w, //
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColors.fadedPrimary3,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(color: AppColors.fadedBlueBorder),
                          ),
                          child: Center(
                            child: SvgPicture.asset("assets/svg/user.svg"),
                          ),
                        ),
                        
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void showInviteInfoPopUp(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
          side: const BorderSide(
            color: AppColors.blueBorder,
          ),
        ),
        elevation: 0,
        insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: "Как работает реферальная программа?",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                height: 1,
              ),
              16.verticalSpace,
              CustomText(
                text: AppConstants.inviteFriendLongText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                height: 1.1,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildTextField() {
  return TextField(
    readOnly: true,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.zero.copyWith(left: 6.w),
      hintText: "myfit.ru/invite/adv23rd",
      hintStyle: GoogleFonts.raleway(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.blueText,
        fontFeatures: const [FontFeature.liningFigures()],
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: AppColors.blueColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.r),
        borderSide: const BorderSide(
          color: AppColors.blueColor,
        ),
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.all(6.r),
        child: SvgPicture.asset(
          "assets/svg/friends.svg",
        ),
      ),
    ),
  );
}
