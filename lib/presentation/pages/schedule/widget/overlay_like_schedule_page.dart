import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverlayLikeSchedulePage extends StatefulWidget {
  final MapState state;
  final MapNotifier event;
  final TextEditingController controller;
  const OverlayLikeSchedulePage({
    super.key,
    required this.state,
    required this.event,
    required this.controller,
  });

  @override
  State<OverlayLikeSchedulePage> createState() => _OverlayLikeMain2State();
}

class _OverlayLikeMain2State extends State<OverlayLikeSchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.controller.text.isEmpty ||
              widget.state.gymFoundBySearching.isEmpty
          ? 160.h
          : 290.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.blueColor,
          width: 1.w,
        ),
      ),
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        widget.controller.text.isEmpty
            ? Center(
                child: CustomText(
                  text:
                      "Напишите в поиск названия занятия которого хотите найти!",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              )
            : widget.controller.text.length > 1 &&
                    widget.state.gymFoundBySearching.isEmpty
                ? CustomText(
                    text: "По вашему запросу ничего не найдено! ",
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  )
                : Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: Scrollbar(
                        thumbVisibility: false,
                        trackVisibility: false,
                        interactive: true,
                        radius: Radius.circular(32.r),
                        thickness: 0.r,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.state.gymFoundBySearching.length,
                          itemBuilder: (context, index) {
                            final currentGym =
                                widget.state.gymFoundBySearching[index];
                            return _listiles(
                              currentGym.name ?? "??",
                              currentGym.distanceFromClient.toString(),
                              () {
                                context.router.push(const ScheduleRoute());
                                widget.controller.clear();
                                widget.event.closeSearchBar();
                                FocusScope.of(context).unfocus();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
        SizedBox(height: 10.h),
        UiButtonFilled(
          btnText: 'Закрыть',
          onPressedAction: () {
            widget.event.closeSearchBar();
            widget.controller.clear();
            FocusScope.of(context).unfocus();
            setState(() {});
          },
          isFullWidth: true,
        )
      ]),
    );
  }
}

Widget _listiles(
  String name,
  String km,
  void Function()? onTap,
) {
  return InkWell(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.only(left: 10.w, bottom: 15.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: name,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          InterText(
            text: km,
            color: AppColors.greyText,
            fontSize: 10.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    ),
  );
}
