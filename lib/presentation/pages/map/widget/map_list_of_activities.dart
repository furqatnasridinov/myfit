import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/radio_button.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class MapListOfActivities extends StatelessWidget {
  final MapState state;
  final MapNotifier event;
  YandexMapController? controller;

  MapListOfActivities(
    this.controller, {
    super.key,
    required this.state,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return state.listOfActivitiesFromSelectedDiapozone.isEmpty
        ? Padding(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
            child: CustomCard(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "В этом радиусе ничего не найдено, увеличьте радиус поиска.",
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 3.w)),
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => choseDiapozoneModal(event,state, context),
                      text: "Изменить радиус",
                      style: GoogleFonts.raleway(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.blueText),
                    ),
                  ],
                ),
              ),
            ),
          )
        : ListView.builder(
            padding:
                EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
            itemCount: state.listOfActivitiesFromSelectedDiapozone.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final currentActivity =
                  state.listOfActivitiesFromSelectedDiapozone[index];
              //print("eachData ${eachData[index]["name"]}");
              return _listBuilder(
                currentActivity.name,
                currentActivity.distanceFromClient!,
                "",
                () {
                  event.changeCameraPosition(
                    controller!,
                    currentActivity.latitude!,
                    currentActivity.longitude!,
                  );
                  event
                      .setMarkerAsOpened(
                        currentActivity.latitude!,
                        currentActivity.longitude!,
                      )
                      .then(
                        (value) => event.showPopUpOnMap(context),
                      );
                },
              );
            },
          );
  }

  _listBuilder(
    String? title,
    double distance,
    String? icon,
    void Function()? onTap,
  ) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.greyBorder, width: 1.w),
      ),
      margin: EdgeInsets.only(bottom: 5.h),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
          side: BorderSide(
            color: Colors.red,
            width: 1.w,
          ),
        ),
        title: CustomText(
          text: title ?? "",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        trailing: CustomText(
          text: "${distance.toString()} km",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
        leading: SvgPicture.asset(
          icon == "" ? "assets/svg/activity.svg" : icon ?? "",
          width: 24.w,
          height: 24.h,
          color: AppColors.blueColor,
        ),
      ),
    );
  }
}

void choseDiapozoneModal(
    MapNotifier event, MapState state, BuildContext context) {
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
          ],
        ),
      );
    },
  );
}
