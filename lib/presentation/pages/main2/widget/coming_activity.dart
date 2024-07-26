import 'package:auto_route/auto_route.dart';
import 'package:myfit/application/main2/main2_notifier.dart';
import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_card.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';

class ComingActivity extends StatelessWidget {
  final GetNearestLesson nearestLesson;
  final Main2Notifier event;
  const ComingActivity(
      {super.key, required this.event, required this.nearestLesson});

  @override
  Widget build(BuildContext context) {
    List<String> parts = nearestLesson.bodyData!.date!.split("@");
    final today = event.dateTimeNowToString(DateTime.now());
    final String formattedDay = event.formatDay(parts[0]);
    return CustomCard(
      child:  Consumer(builder: (context, ref, child) {
        final lessonIsAlreadyStarted = ref.watch(main2Provider).lessonIsAlreadyStarted;
        final whenActivityStarts = ref.watch(main2Provider).whenActivityStarts;
        final Main2Notifier notifier = ref.read(main2Provider.notifier);
        return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  child: CustomText(
                    text: 'Ближайшее событие:',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: CustomText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: lessonIsAlreadyStarted
                      ? "Занятие уже началось"
                      : "через $whenActivityStarts",
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.greyText,
                ),
              )
            ],
          ),
          SizedBox(height: 10.h),
          Column(children: [
            sectionBuilder(
              SvgPicture.asset("assets/svg/flash.svg"),
              nearestLesson.bodyData?.description ?? "Empty",
            ),
            10.verticalSpace,
            sectionBuilder(
              SvgPicture.asset("assets/svg/handwatch.svg"),
              today == formattedDay ? "${parts[1]}, Сегодня" : "${parts[1]}, $formattedDay",
            ),
            10.verticalSpace,
            sectionBuilder(
              SvgPicture.asset("assets/svg/location.svg"),
              "${nearestLesson.bodyData?.gym?.name}&&${nearestLesson.bodyData?.gym?.address}",
              isTwoLine: true,
              ontap: () {
                showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  elevation: 0,
                  insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: modalBody(
                    context,
                    onLaunchMap: (){
                      final double lat = double.parse(nearestLesson.bodyData?.gym?.latitude ?? AppConstants.maktabi21Lat.toString());
                      final double lon = double.parse(nearestLesson.bodyData?.gym?.longitude ?? AppConstants.maktabi21Lon.toString());
                      notifier.launchMap(lat, lon);
                    },
                    onNavigate: (){
                      context.router.pop();
                      context.router.push(ActivityRoute(gymId: nearestLesson.bodyData?.gym?.id ?? 0));
                    },
                    ),
                );
              },
            );
                
              },
            ),
          ]),
        ],
      );
      },),
    );
  }
}

Widget sectionBuilder(Widget icon, String text, {Function()? ontap, bool isTwoLine = false}) {
  return GestureDetector(
    onTap: ontap,
    child: SizedBox(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.fadedBlueBorder)),
        child: Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            children: [
              icon,
              //Icon(icondata, size: 18.r, color: AppColors.blueColor),
              7.horizontalSpace,
              if(!isTwoLine)
              Flexible(
                child: CustomText(
                  text: text,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if(isTwoLine)
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: "${text.split("&&")[0]}.",
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      maxLines: 1,
                    ),
                    CustomText(
                      text: text.split("&&")[1],
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
      ),
    ),
  );
}

Widget modalBody(BuildContext context, {Function()? onNavigate, Function()? onLaunchMap}){
  return Padding(
    padding: EdgeInsets.all(16.r),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomText(
          text: "Что вы хотите сделать?",
          fontSize: 16.sp,
          height: 1.1,
          fontWeight: FontWeight.w600,
        ),
        16.verticalSpace,
        CustomText(
          text: "Открыть карточку заведения или построить маршрут до заведения в вашем навигаторе?",
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          height: 1.1.h,
        ),
        
        16.verticalSpace,
        Row(
          children: [
            AnimationButtonEffect(
              child: GestureDetector(
                onTap: () {
                  context.router.pop();
                },
                child: SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: DecoratedBox(decoration: BoxDecoration(
                    color: AppColors.blueColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: AppColors.blueBorder)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Icon(
                      Icons.arrow_back_ios,
                      size: 13.r,
                      color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            5.horizontalSpace,
            Expanded(
              child: CustomButton(
                onPressed: onNavigate,
                text: "Заведение",
                height: 40.h,
                buttonColor: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            5.horizontalSpace,
            Expanded(
              child: CustomButton(
                onPressed: onLaunchMap,
                text: "Маршрут",
                height: 40.h,
                buttonColor: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}