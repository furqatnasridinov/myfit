import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/radio_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MapPageTopSection extends StatefulWidget {
  const MapPageTopSection({super.key});

  @override
  State<MapPageTopSection> createState() => _MapPageTopSectionState();
}

class _MapPageTopSectionState extends State<MapPageTopSection> {
  @override
  Widget build(BuildContext context) {
    List items700 = [false, true, false, false];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: "Карта активностей",
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                // isDismissible: false,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 40.h,
                    ),
                    height: 280.h,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.r),
                        topRight: Radius.circular(16.r),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.verticalSpace,
    
                        // серая полоска
                        Center(
                          child: Container(
                            width: 70.w,
                            height: 3.h,
                            decoration: BoxDecoration(
                              color: AppColors.greyBorder,
                              //color: Colors.red,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                        32.verticalSpace,
    
                        // text Настройки поиска
                        CustomText(
                          text: "Настройки поиска",
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        32.verticalSpace,
                        CustomText(
                          text: "Радиус поиска",
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        5.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RadioButton700(
                              title: '700 м',
                              ontap: () {
                                /*  setState(() {
                                        dzone = '700 m';
                                        dddd(0.7);
                                        // Обновите состояние выбора, чтобы включить или выключить элементы.
                                        items700 = [true, false, false, false];
                                      }); */
                              },
                              isFalse700: items700[0],
                            ),
                            Expanded(
                              child: Divider(color: Colors.blue.shade100),
                            ),
                            RadioButton700(
                              title: '1.5 км',
                              ontap: () {
                                /*   setState(() {
                                        dzone = '1.5 km';
                                        dddd(1.5);
                                        items700 = [false, true, false, false];
                                      }); */
                              },
                              isFalse700: items700[1],
                            ),
                            Expanded(
                              child: Divider(color: Colors.blue.shade100),
                            ),
                            RadioButton700(
                              title: '3 км',
                              ontap: () {
                                /* setState(() {
                                        dzone = '3 km';
                                        dddd(3);
                                        items700 = [false, false, true, false];
                                      }); */
                              },
                              isFalse700: items700[2],
                            ),
                            Expanded(
                              child: Divider(color: Colors.blue.shade100),
                            ),
                            RadioButton700(
                              title: '5+ km',
                              ontap: () {
                                /* setState(() {
                                        dzone = '5+ км';
                                        dddd(5);
                                        items700 = [false, false, false, true];
                                      }); */
                              },
                              isFalse700: items700[3],
                            ),
                          ],
                        ),
                        32.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: CustomButton(
                                    onPressed: () {},
                                    text: "Отменить",
                                    buttonColor: Colors.white,
                                  )),
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  Navigator.pop(context);
                                },
                                child: CustomButton(
                                  onPressed: () {},
                                  buttonColor: AppColors.blueColor,
                                  text: "Сохранить",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Container(
              width: 40.w,
              height: 40.h,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.5.w,
                  color: const Color(0xffE9E9E9),
                ),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset("assets/svg/icon_filter.svg"),
            ),
          ),
        ],
      ),
    );
  }
}
