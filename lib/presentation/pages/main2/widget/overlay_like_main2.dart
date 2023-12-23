import 'package:activity/application/main2/main2_notifier.dart';
import 'package:activity/application/main2/main2_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OverlayLikeMain2 extends StatefulWidget {
final Main2State state;
  final Main2Notifier event;
  final TextEditingController controller;
  const OverlayLikeMain2({
    super.key,
    required this.state,
    required this.event,
    required this.controller,
  });

  @override
  State<OverlayLikeMain2> createState() => _OverlayLikeMain2State();
}

class _OverlayLikeMain2State extends State<OverlayLikeMain2> {
  GlobalKey containerKey = GlobalKey();
  Size? containerSize;
  Offset? containerOffset;
  getSizeAndOffsets() {
    RenderBox box =
        containerKey.currentContext?.findRenderObject() as RenderBox;
    containerSize = box.size;
    containerOffset = box.localToGlobal(Offset.zero);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getSizeAndOffsets();
    });
  }

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapOutside: (pointerDownEvent) {
        // Get the position of the tap
        final tapPosition = pointerDownEvent.localPosition;
        // Check if the tap occurred below the widget
        if (containerOffset != null &&
            containerSize != null &&
            tapPosition.dy > containerOffset!.dy + containerSize!.height) {
          // Tapped below OverlayLikeMain2, close the search box
          widget.event.closeSearchBar();
        }
      },
      child: Container(
        key: containerKey,
        height: widget.controller.text.isEmpty ||
                widget.state.schedulesFoundBySearching.isEmpty
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                          widget.state.schedulesFoundBySearching.isEmpty
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
                                itemCount: widget
                                    .state.schedulesFoundBySearching.length,
                                itemBuilder: (context, index) {
                                  final currentGym = widget
                                      .state.schedulesFoundBySearching[index];
                                  return _listiles(
                                    currentGym.description ?? "??",
                                    currentGym.gym?.address ?? "??",
                                    () {
                                      context.router
                                          .push(const ScheduleRoute());
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
      ),
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
      //color: Colors.red,
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
