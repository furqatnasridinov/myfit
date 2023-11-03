import 'dart:math';

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_dropdown_menu.dart';
import 'package:activity/presentation/pages/schedule/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleCard extends StatefulWidget {
  final String date;
  final String time;
  final int itemCount;
  final String describtion;
  final String duration;
  final String address;
  ScheduleCard({
    super.key,
    required this.date,
    required this.time,
    required this.itemCount,
    required this.describtion,
    required this.duration,
    required this.address,
  });

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool plusState = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // row (date and Plus button)

        Row(
          children: [
            CustomText(
              text: widget.date,
              fontWeight: FontWeight.w600,
            ),
            const Spacer(),
            _plusButton(),
          ],
        ),
        15.verticalSpace,
        // listview builder body info 'bout schedules
        Container(
          //width: 200.w,
          decoration: BoxDecoration(border: Border.all()),
          //height: 300.w,
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) {
              return IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // times
                    Column(
                      children: [
                        InterText(
                          text: widget.time.substring(widget.time.length - 5),
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        9.verticalSpace,
                        const Icon(
                          Icons.watch_later_outlined,
                          color: AppColors.blueColor,
                          size: 20.0,
                        ),
                        7.verticalSpace,
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: VerticalDivider(
                              color: AppColors.blueColor,
                              thickness: 1.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    CustomCard(
                      marginBottom: 5.h,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // top part
                          SizedBox(
                            width: 265.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // describtion
                                SizedBox(
                                  width: 220.w,
                                  child: CustomText(
                                    text: widget.describtion,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                10.horizontalSpace,
                                DropDownMenuInsideCard(),
                              ],
                            ),
                          ),
                          16.verticalSpace,

                          // bottom part
                          SizedBox(
                            width: 265.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // duration
                                SizedBox(
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.watch_later_outlined,
                                        color: AppColors.blueColor,
                                        size: 16.r,
                                      ),
                                      4.horizontalSpace,
                                      InterText(
                                        text: widget.duration,
                                        color: AppColors.greyText,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                ),
                                // location
                                SizedBox(
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: AppColors.blueColor,
                                        size: 16.r,
                                      ),
                                      4.horizontalSpace,
                                      InterText(
                                        text: widget.address,
                                        color: AppColors.greyText,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w400,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _plusButton() {
    return UiDropDownMenu(
      customOffset: const [-50.0, -40.0],
      dropDownItemsList: [
        {
          'title': 'Найти что то новое',
          'icon': SvgPicture.asset(
            "assets/svg/search.svg",
            colorFilter: const ColorFilter.mode(
              Color.fromRGBO(62, 134, 245, 1),
              BlendMode.srcIn,
            ),
            height: 18.h,
            width: 18.w,
          ),
          'action': () => {}
        },
        {
          'title': 'Выбрать из уже знакомых занятий',
          'icon': SvgPicture.asset(
            "assets/svg/copy.svg",
            colorFilter: const ColorFilter.mode(
              Color.fromRGBO(62, 134, 245, 1),
              BlendMode.srcIn,
            ),
            height: 18.h,
            width: 18.w,
          ),
          'action': () => {}
        },
      ],
      onOpenedAction: () => {
        setState(() {
          plusState = true;
        }),
      },
      onClosedAction: () => {
        setState(() {
          plusState = false;
        }),
      },
      dropDownChild: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            width: 1.w,
            color: const Color.fromRGBO(89, 154, 254, 1),
          ),
          color: const Color.fromRGBO(119, 170, 249, 1),
        ),
        padding: EdgeInsets.all(11.r),
        child: Transform.rotate(
          angle: plusState == true ? (45 * pi / 180) : (0 * pi / 180),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 18.r,
          ),
        ),
      ),
    );
  }
}
