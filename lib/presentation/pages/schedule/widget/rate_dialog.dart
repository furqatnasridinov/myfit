// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/schedule/schedule_provider.dart';
import 'package:activity/infrastructure/models/request/rate_request.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_textformfield.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RateDialog extends StatefulWidget {
  final int id;
  final String gymName;
  final String describtion;
  const RateDialog({super.key, required this.id, required this.gymName, required this.describtion});

  @override
  State<RateDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateDialog> {
  bool hasFocus = false;
  double rating = 3;
  bool ratingChanged = false;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Оставить отзыв",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            16.verticalSpace,
            Row(
              children: [
                SvgPicture.asset("assets/svg/location_filled.svg"),
                10.horizontalSpace,
                CustomText(
                  text: widget.gymName,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset("assets/svg/doc_filled.svg"),
                10.horizontalSpace,
                Flexible(
                  child: CustomText(
                    text: widget.describtion,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            // starts
            16.verticalSpace,
            Container(
              width: double.maxFinite,
              height: 50.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                border: Border.all(
                  color: AppColors.blueBorder,
                ),
              ),
              child: Center(
                child: RatingBar.builder(
                  initialRating: rating,
                  minRating: 1,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  direction: Axis.horizontal,
                  itemCount: 5,
                  glow: false,
                  unratedColor: AppColors.blueColor,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      rating >= index + 1
                          ? "assets/svg/star_filled.svg"
                          : "assets/svg/star_outlined.svg",
                    );
                  },
                  onRatingUpdate: (value) {
                    if (!ratingChanged) {
                      ratingChanged = true;
                      setState(() {});
                    }
                    rating = value;
                    debugPrint("rating: ${rating.toInt()}");
                  },
                ),
              ),
            ),

            // text field
            if (ratingChanged)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.verticalSpace,
                  CustomText(
                    text: "Ваш комментарий:",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                  5.verticalSpace,
                  CustomTextFormField(
                    controller: controller,
                    onTap: () {
                      hasFocus = true;
                      setState(() {});
                    },
                    onTapOutside: (event) {
                      hasFocus = false;
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                    onEditingComplete: () {
                      hasFocus = false;
                      FocusScope.of(context).unfocus();
                      setState(() {});
                    },
                    onChanged: (val) {
                      controller.text = val;
                      setState(() {});
                    },
                    hintText: "Введите текст",
                    hasFocus: hasFocus,
                  ),
                ],
              ),

            // buttons
            16.verticalSpace,
            Consumer(builder: (ctx, ref, child) {
              final event = ref.read(scheduleProvider.notifier);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: "Отменить",
                      onPressed: () {
                        if (ratingChanged) {
                          ratingChanged = false;
                          rating = 3;
                          setState(() {});
                        }
                        controller.clear();
                        context.router.pop();
                      },
                      height: 40.h,
                      buttonColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  10.horizontalSpace,
                  Expanded(
                    child: CustomButton(
                      text: "Отправить",
                      onPressed: () async {
                        // logic to send the review
                        final request = RateRequest(
                          grade: rating.toInt(),
                          message: controller.text,
                          lessonUser: LessonUser(id: widget.id),
                        );
                        await event.makeARate(context, request: request);
                        // get updated list of schedule
                        event.getCompletedSchedules(context);
                        context.router.pop();
                      },
                      height: 40.h,
                      buttonColor: AppColors.blueColor,
                      textColor: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
