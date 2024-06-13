// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/settings/settings_notifier.dart';
import 'package:myfit/application/settings/settings_provider.dart';
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
            child: Consumer(builder: (context, ref, child) {
              final notifier = ref.watch(settingsProvider.notifier);
              final referal = ref.watch(settingsProvider).referalInfo;
              final int receivedBonus = referal?.receivedBonus ?? 0;
              final int tottalFriends = referal?.invitedUsers ?? 0;
              const  int aim = 3;
              final int  currentProgress = receivedBonus == 0  ? 
                  tottalFriends : receivedBonus != 0 ? tottalFriends - (receivedBonus * aim) : 9999;
              return Column(
              children: [
                CustomText(
                  text: AppConstants.inviteFriendLongText2,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 1.1,
                ),
                16.verticalSpace,
                CustomText(
                  text:"Друзья должны перейти именно по вашей ссылке, скопируйте её из поля ниже:",
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
                        child: buildTextField(referal?.refLink ?? ""),
                      ),
                      10.horizontalSpace,
                      AnimationButtonEffect(
                        child: GestureDetector(
                          onTap: () {
                            // copy to clipboard
                            Clipboard.setData(ClipboardData(text: "myfit.ru/invite/${referal?.refLink}"));
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
                //getBonusButton(),
                if(currentProgress >= 3 && currentProgress != 9999) getBonusButton(notifier, context),
                if(currentProgress <3)
                Row(
                  children: [
                    currentProgress >= 1 ? doneIndicator() : notDoneIndicator(),
                    8.horizontalSpace,
                    currentProgress >= 2 ? doneIndicator() : notDoneIndicator(),
                    8.horizontalSpace,
                    notDoneIndicator(),
                  ],
                ),

                // в случае если все currentProgress == 9999 (ошибка)
                if(currentProgress == 9999)
                errorButton(),
              ],
            );
            },)
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

Widget buildTextField(String ref) {
  return TextField(
    readOnly: true,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.zero.copyWith(left: 6.w),
      hintText: "myfit.ru/invite/$ref",
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


Widget doneIndicator() {
  return Expanded(
    child: Stack(
      children: [
        SizedBox(
          height: 30.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.fadedPrimary3,
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(119, 170, 249, 0.16),
                  Color.fromRGBO(89, 154, 254, 0.29),
                ],
              ),
            ),
            child: const Center(
              child: SizedBox(),
            ),
          ),
        ),
         SizedBox(
          height: 29.h,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.fadedPrimary3,
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(119, 170, 249, 0.16),
                  Color.fromRGBO(89, 154, 254, 0.29),
                ],
              ),
            ),
            child: const Center(
              child: SizedBox(),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.all(5.r),
            child: SizedBox(
              height: 20.h,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  //color: AppColors.primaryFadedBorder,
                  borderRadius: BorderRadius.circular(16.r),
                  //border: Border.all(color: AppColors.fadedBlueBorder),
                   gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.blueColor.withOpacity(0.26),
                      AppColors.blueBorder.withOpacity(0.49),
                    ],
                  ),
                ),
                child: Icon(Icons.done, color: Colors.white, size: 16.sp),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget notDoneIndicator() {
  return Expanded(
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
  );
}

Widget getBonusButton(SettingsNotifier settingsNotifier, BuildContext context){
  return GestureDetector(
    onTap: () async{
       await settingsNotifier.getReferalBonus(context);
       settingsNotifier.getAllAvailableSubscribtions(context);
    },
    child: AnimationButtonEffect(
      child: Container(
        height: 30.h,
        width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.blueColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.blueText),
            boxShadow: const[
              BoxShadow(
                color: Color.fromRGBO(157, 193, 245, 1),
                offset: Offset(0, 11),
                blurRadius: 15.9,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Center(
            child: CustomText(
              text: "Получить награду!",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
      
      ),
    ),
  );
}


Widget errorButton(){
  return GestureDetector(
    onTap: () {
      //
    },
    child: AnimationButtonEffect(
      child: Container(
        height: 30.h,
        width: double.maxFinite,
          decoration: BoxDecoration(
            color: AppColors.redText.withOpacity(0.8),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.redBorder),
            boxShadow: [
              BoxShadow(
                color: AppColors.redText.withOpacity(0.4),
                offset: const Offset(0, 11),
                blurRadius: 15.9,
                spreadRadius: -10,
              ),
            ],
          ),
          child: Center(
            child: CustomText(
              text: "currentProgress == 9999",
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
      
      ),
    ),
  );
}