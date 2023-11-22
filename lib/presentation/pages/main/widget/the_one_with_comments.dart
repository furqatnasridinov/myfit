import 'package:activity/application/main/main_notifier.dart';
import 'package:activity/application/main/main_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_stepper/stepper.dart';

class TheOneWithComments extends StatelessWidget {
  final MainState state;
  final MainNotifier event;
  const TheOneWithComments(
      {super.key, required this.state, required this.event});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: 'Что говорят наши пользователи:',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          height: 143.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: AppColors.greyBorder,
              width: 1.w,
            ),
            color: Colors.white,
          ),
          padding: EdgeInsets.all(16.r),
          child: state.isloading || state.comments == null
              ? const SizedBox()
              : Stack(
                  children: [
                    SizedBox(
                      width: 290.w,
                      //color: Colors.black26,
                      child: CarouselSlider.builder(
                        itemCount: state.comments?.commentsBody?.length,
                        itemBuilder: (context, index, realIndex) {
                          final currentComment =
                              state.comments?.commentsBody?[index];
                          final yearFromBack =
                              currentComment?.user?.birthdayDate;
                          final parts = yearFromBack?.split("-");
                          final formattedYear =
                              DateTime.now().year - int.parse(parts![0]);
                          return _comments(
                            currentComment?.message ?? "",
                            AppConstants.owlNetworkImage,
                            "${currentComment?.user?.lastName} ${currentComment?.user?.firstName}",
                            currentComment?.user?.city?.name ?? "??",
                            "$formattedYear лет",
                          );
                        },
                        options: CarouselOptions(
                          viewportFraction: 1,
                          enableInfiniteScroll: false,
                          scrollDirection: Axis.vertical,
                          autoPlay: state.commentsAutoPlayMode,
                          onPageChanged: (index, reason) {
                            event.commenSetStep(index);
                            if (reason == CarouselPageChangedReason.manual) {
                              event.stopCommentsAutoPlayMode();
                            }
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: DotStepper(
                        activeStep: state.commentActiveStepper,
                        dotCount: state.comments?.commentsBody?.length ?? 2,
                        direction: Axis.vertical,
                        dotRadius: 6,
                        spacing: 35.w,
                        lineConnectorsEnabled: true,
                        fixedDotDecoration: FixedDotDecoration(
                          color: Colors.white,
                          strokeColor: Colors.blue,
                          strokeWidth: 1.w,
                        ),
                        indicatorDecoration: const IndicatorDecoration(
                          color: Colors.blue,
                        ),
                        indicator: Indicator.jump,
                        lineConnectorDecoration: LineConnectorDecoration(
                          linePadding: 3.w,
                          color: Colors.blue,
                          strokeWidth: 1.w,
                        ),
                        tappingEnabled: false,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _comments(
    String comment,
    String img,
    String name,
    String city,
    String year,
  ) {
    return SizedBox(
      //color: Colors.red,
      width: 292.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 65.h,
            ),
            child: SizedBox(
              //color: Colors.amber,
              width: double.maxFinite,
              //height: 65.h,
              child: InterText(
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                text: comment,
                //text: "cndjcndjcn nj nj n j n jn jnjcdcdcdc   cd c dc d cd CBHCHBHBCHCBCH cdjcndjcn JNJNCJNCJNCC JNJNJN",
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          7.verticalSpace,
          Row(
            children: [
              SizedBox(
                width: 37.0,
                height: 37.0,
                child: ClipOval(
                  child: Image.network(img),
                ),
              ),
              const SizedBox(width: 10.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InterText(
                    text: name,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  2.verticalSpace,
                  InterText(
                    text: "$city $year",
                    fontWeight: FontWeight.w400,
                    fontSize: 12.sp,
                    color: AppColors.greyText,
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
