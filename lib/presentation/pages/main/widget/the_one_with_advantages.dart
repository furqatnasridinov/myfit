import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class TheOneWithAdvantages extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  TheOneWithAdvantages({super.key, required this.state, required this.event});

  CarouselController carouselController = CarouselController();

  double opacityValue = 1;

  /* late AnimationController _animationController;
i   nt activePageIndex = 0;
  late Animation<double> _nextPage;

  int _currentPage = 0;

  PageController _pageController = PageController(initialPage: 0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _nextPage = Tween(begin: 0.0, end: 1.0).animate(_animationController);
    //Add listener to AnimationController for know when end the count and change to the next page
    _animationController.addListener(() {
      if (_animationController.status == AnimationStatus.completed) {
        _animationController.repeat();
        final int page = widget.state.comments!.bodyData!.length;
        if (_currentPage < page) {
          _currentPage++;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInSine,
          );
        } else {
          _currentPage = 0;
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  } */
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      height: 140.h,
      width: double.maxFinite,
      child: state.advantages == null
          ? const SizedBox()
          : Stack(
              children: [
                SizedBox(
                  width: double.maxFinite,
                  //color: Colors.black26,
                  child:
                      /* PageView.builder(
                    controller: _pageController,
                    itemCount: widget.state.advantages?.bodyData?.length,
                    onPageChanged: (value) {
                      widget.event.setStep(value + 1);
                    },
                    itemBuilder: (context, index) {
                      final currentAdvantage =
                          widget.state.advantages?.bodyData?[index];
                      return scrollableTexts(
                        currentAdvantage?.heading ?? "",
                        currentAdvantage?.description ?? "",
                        opacityValue,
                      );
                    },
                  ), */

                      CarouselSlider.builder(
                    carouselController: carouselController,
                    itemCount: state.advantages?.bodyData?.length,
                    itemBuilder: (context, index, realIndex) {
                      print("realIndex $realIndex");
                      final currentAdvantage =
                          state.advantages?.bodyData?[index];
                      return scrollableTexts(
                        currentAdvantage?.heading ?? "",
                        currentAdvantage?.description ?? "",
                        opacityValue,
                      );
                    },
                    options: CarouselOptions(
                      scrollDirection: Axis.horizontal,
                      enableInfiniteScroll: false,
                      viewportFraction: 1,
                      onPageChanged: (index, reason) {
                        event.setStep(index + 1);
                        if (reason == CarouselPageChangedReason.manual) {
                          opacityValue = 0;
                          event.stopAdvantagesAutoPlayMode();
                        }
                      },
                      autoPlay: state.advantagesAutoPlayMode,
                    ),
                  ),
                ),

                // stepper
                Positioned(
                  left: 0,
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
    double opacity,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            //color: Colors.red,
            //height: 75.h,
            width: 120.w,
            child: CustomText(
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              text: firstText,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
              opacity: opacity,
            ),
          ),
          16.horizontalSpace,
          SizedBox(
            //color: Colors.amber,
            //height: 180.h,
            width: 170.w,
            child: CustomText(
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              text: secondText,
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              opacity: opacity,
            ),
          ),
        ],
      ),
    );
  }

  Widget progress() {
    return LinearPercentIndicator(
      //backgroundColor: Colors.blue,
      width: 30.w,
      lineHeight: 3.h,
      animation: true,
      animationDuration: 4000,
      //fillColor: Colors.grey.shade300,
      progressColor: Colors.blue,
      percent: 1,
    );
  }
}
