import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PopUpMap extends StatelessWidget {
  final String name;
  final String address;
  const PopUpMap({super.key, required this.name, required this.address});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      borderColor: AppColors.blueColor,
      radius: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // icons
          SizedBox(
            width: 160.w,
            height: 26.h,
            //color: Colors.red,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(right: 10.w),
                  width: 24.w,
                  height: 24.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    color: AppColors.backgroundColor,
                  ),
                  child: const Icon(
                    Icons.sports_gymnastics_sharp,
                    color: AppColors.blueColor,
                  ),
                );
              },
            ),
          ),

          10.verticalSpace,
          // name
          SizedBox(
            //color: Colors.red,
            child: IntrinsicHeight(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 60.h,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      width: 160.w,
                      //color: Colors.amber,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InterText(
                            //text: "Спорткомплекс “Газпром”",
                            text: name,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          InterText(
                            //text: "ул. Казимира, Строение 12, корпус 42б”",
                            text: address,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.greyText,
                          ),
                        ],
                      ),
                    ),
                    10.horizontalSpace,

                    // button
                    Container(
                      width: 60.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.blueColor,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_forward_ios,
                          color: AppColors.blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
