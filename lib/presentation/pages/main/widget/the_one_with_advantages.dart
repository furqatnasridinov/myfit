import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TheOneWithAdvantages extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  TheOneWithAdvantages({super.key, required this.state, required this.event});
  CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.greyBorder,
          width: 1.w,
        ),
      ),
      padding: EdgeInsets.all(16.r),
      child: Stack(
        children: [
          SizedBox(
            width: double.maxFinite,
            //color: Colors.black26,
            child: CarouselSlider.builder(
              carouselController: carouselController,
              itemCount: state.advantages?.bodyData?.length,
              itemBuilder: (context, index, realIndex) {
                final currentAdvantage = state.advantages?.bodyData?[index];
                return scrollableTexts(
                  currentAdvantage?.heading ?? "",
                  currentAdvantage?.description ?? "",
                );
              },
              options: CarouselOptions(
                scrollDirection: Axis.horizontal,
                enableInfiniteScroll: false,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  event.setStep(index + 1);
                  if (reason == CarouselPageChangedReason.manual) {
                    event.stopAdvantagesAutoPlayMode();
                  }
                },
                autoPlay: state.advantagesAutoPlayMode,
                autoPlayAnimationDuration: const Duration(seconds: 1),
              ),
            ),
          ),

          // stepper
          Positioned(
            bottom: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: state.activeStepState.toString(),
                        style: GoogleFonts.raleway(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(
                        text: '/${state.advantages?.bodyData?.length}',
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                2.horizontalSpace,
                StepProgressIndicator(
                  //selectedColor: Colors.
                  totalSteps: state.advantages!.bodyData!.length,
                  currentStep: state.activeStepState,
                  size: 3.w,
                  unselectedColor: Colors.grey.shade300,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget scrollableTexts(
    String firstText,
    String secondText,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          //color: Colors.red,
          height: 70.h,
          width: 120.w,
          child: CustomText(
            //overflow: TextOverflow.ellipsis,
            text: firstText,
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        16.horizontalSpace,
        SizedBox(
          //color: Colors.amber,
          width: 170.w,
          child: CustomText(
            text: secondText,
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
