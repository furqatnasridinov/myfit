// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_textfield.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_button_outlined.dart';

class NotesCardMaker extends StatelessWidget {
  final String address;
  final String startTime;
  final String description;
  const NotesCardMaker({
    Key? key,
    required this.address,
    required this.startTime,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 32.w),
      child: Column(
        children: [
          // blue container
          CustomCard(
            color: AppColors.blueColor,
            child: Column(
              children: [
                // top section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // location
                    SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/location.svg",
                            color: Colors.white,
                            width: 16.w,
                            height: 16.h,
                          ),
                          3.horizontalSpace,
                          SizedBox(
                            //color: Colors.amber,
                            width: 210.w,
                            child: InterText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: address,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/clock.svg",
                            color: Colors.white,
                          ),
                          3.horizontalSpace,
                          InterText(
                            text: startTime.substring(startTime.length - 5),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
    
                10.verticalSpace,
    
                // botoom section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: SvgPicture.asset(
                        "assets/svg/activity.svg",
                        color: Colors.white,
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                    3.horizontalSpace,
                    SizedBox(
                      width: 290.w,
                      child: InterText(
                        text: description,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          5.verticalSpace,
    
          // texfields
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 113.w,
                child: CustomTextField(
                  hintText: "Заметка",
                ),
              ),
              SizedBox(
                width: 225.w,
                child: CustomTextField(
                  hintText: "Описание",
                ),
              ),
            ],
          ),
    
          10.verticalSpace,
    
          // button
          CustomButton(
            onPressed: () {},
            text: "Добавить +",
          )
        ],
      ),
    );
  }
}
