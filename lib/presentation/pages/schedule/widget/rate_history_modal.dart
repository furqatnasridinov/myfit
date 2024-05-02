// ignore_for_file: use_build_context_synchronously

import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class RateHistoryDialog extends StatefulWidget {
  final int id;
  final String gymName;
  final String describtion;
  final String comment;
  final int rate;
  const RateHistoryDialog(
      {super.key,
      required this.id,
      required this.gymName,
      required this.describtion,
      required this.comment,
      required this.rate});

  @override
  State<RateHistoryDialog> createState() => _RateDialogState();
}

class _RateDialogState extends State<RateHistoryDialog> {
  bool hasFocus = false;
  double rating = 0;
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
              text: "Ваш отзыв",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            16.verticalSpace,
            Row(
              children: [
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: AppColors.backgroundColor),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: SvgPicture.asset("assets/svg/location.svg"),
                    ),
                  ),
                ),
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
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.r),
                        color: AppColors.backgroundColor),
                    child: Padding(
                      padding: EdgeInsets.all(4.r),
                      child: SvgPicture.asset("assets/svg/docs.svg"),
                      //child : SvgPicture.asset(AppHelpers().getIconSvg(lessonType)),
                    ),
                  ),
                ),
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
                  initialRating: 5.0,
                  minRating: 0,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.w),
                  direction: Axis.horizontal,
                  itemCount: 5,
                  glow: false,
                  unratedColor: AppColors.blueColor,
                  itemBuilder: (context, index) {
                    return SvgPicture.asset(
                      widget.rate >= index + 1
                          ? "assets/svg/star_filled.svg"
                          : "assets/svg/star_outlined.svg",
                    );
                  },
                  onRatingUpdate: (value) {},
                ),
              ),
            ),

            // text field
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
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.greyBorder, width: 1.w),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: CustomText(
                    text: widget.comment.isEmpty ? "Пусто" : widget.comment,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                /*  CustomTextFormField(
                  //controller: controller,
                  readOnly: true,
                  initialValue:
                      widget.comment.isEmpty ? "Пусто" : widget.comment,
                ), */
              ],
            ),

            // buttons
            16.verticalSpace,
            CustomButton(
              text: "Назад",
              onPressed: () {
                context.router.pop();
              },
              height: 40.h,
              buttonColor: Colors.white,
              textColor: Colors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}
