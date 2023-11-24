import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/radio_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MapPageTopSection extends StatelessWidget {
  final MapNotifier event;
  final MapState state;
  const MapPageTopSection(
      {super.key, required this.event, required this.state});

  @override
  Widget build(BuildContext context) {
    print("build called");
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
              event.removePopUp();
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
                    height: 290.h,
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
                        20.verticalSpace,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            RadioButton700(
                              title: '1 км',
                              ontap: () {
                                event.changeDiapozoneAndPop(0, 1, context);
                              },
                              isSelected: state.listOfBool[0],
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.blue.shade100,
                              ),
                            ),
                            RadioButton700(
                                title: '2 км',
                                ontap: () {
                                  event.changeDiapozoneAndPop(1, 2, context);
                                },
                                isSelected: state.listOfBool[1]),
                            Expanded(
                              child: Divider(color: Colors.blue.shade100),
                            ),
                            RadioButton700(
                                title: '3 км',
                                ontap: () {
                                  event.changeDiapozoneAndPop(2, 3, context);
                                },
                                isSelected: state.listOfBool[2]),
                            Expanded(
                              child: Divider(color: Colors.blue.shade100),
                            ),
                            RadioButton700(
                              title: '5+ km',
                              ontap: () {
                                event.changeDiapozoneAndPop(3, 5, context);
                              },
                              isSelected: state.listOfBool[3],
                            ),
                          ],
                        ),
                        const Spacer(),
                        CustomButton(
                          height: 40.h,
                          buttonColor: Colors.white,
                          fontSize: 14.sp,
                          onPressed: () {
                            context.popRoute();
                          },
                          text: "Отменить",
                        ),

                        /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: CustomButton(
                                    onPressed: () {
                                      context.popRoute();
                                    },
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
                                  onPressed: () {
                                    if (state.listOfBool ==
                                        [false, false, false, true]) {
                                      event.changeSelectedDiapozone(5);
                                    }
                                    if (state.listOfBool ==
                                        [false, false, true, false]) {
                                      event.changeSelectedDiapozone(3);
                                    }
                                    if (state.listOfBool ==
                                        [false, true, false, false]) {
                                      event.changeSelectedDiapozone(2);
                                    }
                                    if (state.listOfBool ==
                                        [true, false, false, false]) {
                                      event.changeSelectedDiapozone(1);
                                    }
                                  },
                                  buttonColor: AppColors.blueColor,
                                  text: "Сохранить",
                                ),
                              ),
                            ),
                          ],
                        ), */
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
              child: SvgPicture.asset(
                "assets/svg/icon_filter.svg",
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Step> getSteps() {
    List<Step> steps = [
      Step(
        title: CustomText(text: "1"),
        content: SizedBox(),
      ),
      Step(
        title: CustomText(text: "2"),
        content: SizedBox(),
      ),
      Step(
        title: CustomText(text: "3"),
        content: SizedBox(),
      ),
    ];
    return steps;
  }
}
