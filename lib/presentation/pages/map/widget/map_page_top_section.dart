import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_provider.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/pages/map/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MapPageTopSection extends StatelessWidget {
  final MapNotifier event;
  final MapState state;
  const MapPageTopSection(
      {super.key, required this.event, required this.state});

  @override
  Widget build(BuildContext context) {
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
              AppHelpers.showCustomModalBottomSheet(
                context: context,
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 16.w,
                  bottom: 40.h,
                ),
                height: 290.h,
                child: Consumer(builder: (context, ref, child) {
                  final stateConsumer = ref.watch(mapProvider);
                  final eventConsumer = ref.read(mapProvider.notifier);
                  return DiapozoneBottomSheet(
                    event: eventConsumer,
                    state: stateConsumer,
                  );
                }),
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
        content: const SizedBox(),
      ),
      Step(
        title: CustomText(text: "2"),
        content: const SizedBox(),
      ),
      Step(
        title: CustomText(text: "3"),
        content: const SizedBox(),
      ),
    ];
    return steps;
  }
}
