import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_textfield.dart';
import 'package:myfit/presentation/components/inter_text.dart';

class PromocodeSection extends StatelessWidget {
   const PromocodeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Consumer(
         builder: (context, ref, child) {
        final notifier = ref.read(settingsProvider.notifier);
        final promoValue = ref.watch(settingsProvider).promocodeValue;
        final bool showHistory =ref.watch(settingsProvider).promocodesQueue.isNotEmpty;
        final bool isPromocodeLoading = ref.watch(settingsProvider).isPromocodeLoading;
        final bool isPromocodeSuccess = ref.watch(settingsProvider).isPromocodeSuccess;
        final bool isPromocodeError = ref.watch(settingsProvider).isPromocodeError;
        final String promocodeErrorMessage = ref.watch(settingsProvider).promocodeErrorMessage;
        final String newPromocodeDescription = ref.watch(settingsProvider).newPromocodeDescription;
        final TextEditingController controller = ref.watch(settingsProvider).promocodeController ?? TextEditingController();
          return Column(
            children: [
              Row(
                children: [
                  CustomText(
                    text: "Применить промокод",
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  const Spacer(),
                  if(showHistory)
                  GestureDetector(
                    onTap: () {
                      // show modal
                      showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          elevation: 0,
                          insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: myPromocodesDialog(),
                        );
                      },
                    );
                    },
                    child: CustomText(
                      text: "Мои промокоды",
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueText,
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
              CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40.h,
                          child: Row(
                            children: [
                              Expanded(
                                //height: 40.h,
                                child: CustomTextField(
                                  //hintText: "Например : ref1811friend",
                                  hintText: "Введите промокод",
                                  controller: controller,
                                  style: GoogleFonts.raleway(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    fontFeatures: const [FontFeature.liningFigures()],
                                  ),
                                  onChanged: (value) {
                                    notifier.setPromocodeValue(value.trim());
                                  },
                                  onTapOutside: (p0) {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  },
                                  contentPadding: EdgeInsets.zero.copyWith(left: 6.w),
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.all(6.r),
                                    child: SvgPicture.asset("assets/svg/promocode.svg"),
                                  ),
                                ),
                              ),
                              10.horizontalSpace,
                              AnimationButtonEffect(
                                disabled: promoValue.isEmpty,
                                child: GestureDetector(
                                  onTap: ()  {
                                     notifier.applyPromocede(context, code: promoValue);
                                  },
                                  child: SizedBox(
                                    width: 40.w,
                                    height: 40.h,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                          color: promoValue.isEmpty ? AppColors.disabledButton :AppColors.blueColor,
                                          borderRadius: BorderRadius.circular(8.r),
                                          border: Border.all(
                                              color: promoValue.isEmpty
                                                  ? AppColors.disabledButton
                                                  : AppColors.blueBorder)),
                                      child: isPromocodeLoading
                                          ? const CupertinoActivityIndicator(color: Colors.white) :
                                       Icon(Icons.done,color: Colors.white, size: 18.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if(isPromocodeError || isPromocodeSuccess)
                        Padding(
                          padding: EdgeInsets.only(top: 16.h),
                          child: InterText(
                            text: isPromocodeError
                                ? promocodeErrorMessage
                                : "Промокод активирован: ($newPromocodeDescription)",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: isPromocodeError ? AppColors.redText : Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
          ]);
        }
      ),
    );
  }
}


Widget myPromocodesDialog(){
  return Padding(
    padding: EdgeInsets.all(16.r),
    child: Consumer(
      builder: (context, ref, child) {
        final promocodesQueue = ref.watch(settingsProvider).promocodesQueue;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Очередь промокодов",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            5.verticalSpace,
            CustomText(
              text: AppConstants.promoLongText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 1.1,
            ),
            24.verticalSpace,
            ListView.builder(
              shrinkWrap: true,
              itemCount: promocodesQueue.length,
              itemBuilder: (context, index) {
                final current = promocodesQueue[index];
                return eachPromo(
                    current.promotional?.description ?? "",
                    current.promotionalState ?? PromocodeState.notUsed,
                    DateTime.tryParse(current.promotional?.activateData.toString().replaceAll("T", " ") ?? ""),
                    DateTime.tryParse(current.promotional?.endData.toString().replaceAll("T", " ") ?? ""),
                );
              },
            ),
            24.verticalSpace,
            CustomButton(
              onPressed: () {
                context.router.pop();
              },
              text: "Назад",
              height: 40.h,
              buttonColor: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        );
      },
    ),
  );
}


Widget eachPromo(
  String description,
  PromocodeState promoState,
  DateTime? activateTime,
  DateTime? endTime,
) {
  return Padding(
    padding: EdgeInsets.only(bottom: 10.h),
    child: Row(
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: CustomText(
              text: description,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        10.horizontalSpace,
        Flexible(
          child: CustomText(
            text: getCorrectText(promoState, activateTime),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.1,
          ),
        )
      ],
    ),
  );
}

String getCorrectText(PromocodeState state, DateTime? activateData){
  final String activateTime = AppHelpers.getCalendarlikeStringFromDateTime(activateData ?? AppConstants.myBitrh);
  if (state == PromocodeState.notUsed) {
    return "В очереди ";
  }
  if (state == PromocodeState.used) {
    return "Активирован $activateTime";
  }
  if (state == PromocodeState.waiting) {
    return "Будет использован следующим ";
  }
  return "null";
}