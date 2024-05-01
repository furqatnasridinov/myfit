// ignore_for_file: must_be_immutable

import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PopUpMap extends StatelessWidget {
  final String name;
  final String address;
  void Function()? onNavigate;
  void Function()? onCancel;
  PopUpMap({
    super.key,
    this.onNavigate,
    this.onCancel,
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
                Container(
                  alignment: Alignment.centerRight,
                  //color: Colors.red,
                  height: 26.h,
                  child: Consumer(
                    builder: (context, ref, child) {
                      final activityTypes = ref.watch(activityProvider).activityTypes;
                      //final activityEvent = ref.read(activityProvider.notifier);
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: activityTypes?.length,
                        itemBuilder: (context, index) {
                          final name = activityTypes?[index];
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
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomButton(
                    onPressed: onCancel,
                    text: "Скрыть",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    textColor: Colors.black,
                    height: 40.h,
                  ),
                ),
                5.horizontalSpace,
                Expanded(
                  flex: 7,
                  child: CustomButton(
                    onPressed: onNavigate,
                    text: "Подробнее",
                    buttonColor: AppColors.blueColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    textColor: Colors.white,
                    height: 40.h,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
