// ignore_for_file: must_be_immutable

import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PopUpMap extends StatelessWidget {
  final String name;
  final String address;
  void Function()? onTap;
  PopUpMap({
    super.key,
    this.onTap,
    required this.name,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Material(
      child: CustomCard(
        width: width,
        //height: 145.h,
        radius: 8.r,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    //color: Colors.green,
                    child: InterText(
                      text: name,
                      fontSize: 12.sp,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: SizedBox(
                    //color: Colors.red,
                    height: 26.h,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final activityState = ref.watch(activityProvider);
                        //final activityEvent = ref.read(activityProvider.notifier);
                        return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: activityState.activityTypes?.length,
                          itemBuilder: (context, index) {
                            final name = activityState.activityTypes?[index];
                            return Container(
                              margin: EdgeInsets.only(right: 10.w),
                              width: 24.w,
                              height: 24.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: AppColors.backgroundColor,
                              ),
                              child: SvgPicture.asset(
                                AppHelpers().getIconSvg(name!).isEmpty
                                    ? "assets/svg/gym.svg"
                                    : AppHelpers().getIconSvg(name),
                                height: 15.h,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            InterText(
              text: address,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.greyText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            10.verticalSpace,
            CustomButton(
              onPressed: onTap,
              text: "Подробнее",
              width: double.maxFinite,
              buttonColor: AppColors.blueColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              textColor: Colors.white,
              height: 40.h,
            ),
          ],
        ),
      ),
    );
  }
}
