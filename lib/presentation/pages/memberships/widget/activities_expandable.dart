// ignore_for_file: unused_element, must_be_immutable

import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';

class ActivitiesExpandable extends StatefulWidget {
  final List<String> activities;
  int maxLines;
  bool showIconOnChips;
  bool showBigButton;
  ActivitiesExpandable({
    super.key,
    required this.activities,
    this.maxLines = 1,
    this.showIconOnChips = true,
    this.showBigButton = false,
  });

  @override
  State<ActivitiesExpandable> createState() => _ActivitiesExpandableState();
}

class _ActivitiesExpandableState extends State<ActivitiesExpandable> {
  final Map<String, GlobalKey> keys = {};
  final GlobalKey sizedBoxKey = GlobalKey();
  int maxElements = 0;
  bool iterationCompleted = false;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    for (var activity in widget.activities) {
      keys[activity] = GlobalKey();
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      double maxWidth =sizedBoxKey.currentContext?.size?.width ?? double.maxFinite;
      final double buttonWidth = widget.showBigButton ? 170.w : 34.w;
      maxWidth = maxWidth - buttonWidth;
      double currentWidth = 0;
      int currentLine = 1;
      maxElements = 0;

      // расчитать размеры каждого чипа
      if (widget.activities.isEmpty) {
        iterationCompleted = true;
      } else {
        for (var activity in widget.activities) {
          final RenderBox? renderBox = keys[activity]!.currentContext?.findRenderObject() as RenderBox?;
          if (renderBox is RenderBox) {
            final double width = renderBox.size.width;
            currentWidth += width + 10.w;
            if (currentWidth > maxWidth) {
              currentLine++;
              if (currentLine > widget.maxLines) {
                break;
              }
              currentWidth = width + 10.h; // Начинаем новый ряд
            }
            maxElements++;
          }
        }
        iterationCompleted = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
    //height: 34.h,
    key: sizedBoxKey,
    width: double.infinity,
    child: Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children:  iterationCompleted ? [
        for (var i = 0; i < widget.activities.length; i++)
          if (i < maxElements || isExpanded)
            _EachChipBuilder(
              key: keys[widget.activities[i]],
              activity: widget.activities[i],
              showIcon: widget.showIconOnChips,
              borderColor: const Color.fromRGBO(226, 226, 226, 1),
              onTap: (){},
            ),
        if (widget.activities.length > maxElements || isExpanded)
          GestureDetector(
            onTap: () {
              if(widget.showBigButton){
                isExpanded = !isExpanded;
                setState(() {});
              }else{
                // show modal
                AppHelpers.showCusomDialog(
                  context: context,
                  child: _dialogContent(context, list: widget.activities),
                );
              }
            },
            child: widget.showBigButton ? 
              bigButton(
                remains: widget.activities.length - maxElements, 
                isOpened: isExpanded) : 
              miniButton(),
          ),
      ] : widget.activities.map((activity) => _EachChipBuilder(
        key: keys[activity],
        activity: activity,
        showIcon: true,
        borderColor: AppColors.blueColor,
        onTap: (){},
      )).toList(),
    ),
  );
  }
}


class _EachChipBuilder extends StatelessWidget {
  final String activity;
  final bool showIcon;
  final Color borderColor;
  final VoidCallback onTap;
  const _EachChipBuilder({super.key, required this.activity, required this.showIcon, required this.borderColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 34.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: borderColor),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon)
              SvgPicture.asset(AppHelpers.getIconSvg(activity)),
              if (showIcon) 5.horizontalSpace,
              CustomText(
                text: activity,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    ),
  );
  }
}

Widget miniButton() {
  return SizedBox(
    height: 34.h,
    width: 34.w,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: AppColors.blueColor),
      ),
      child: Center(
        child: CustomText(
          text: '...',
          fontSize: 20.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
  );
}

Widget bigButton({
  required int remains,
  bool isOpened = false,
  Function()? onTap,
}){
  final String text = isOpened ? "Скрыть" : "Показать ещё $remains";
  final double width = isOpened ? 170.w : 170.w;
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      height: 34.h,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: AppColors.blueColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: text,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
            ),
            5.horizontalSpace,
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 300),
              tween: Tween(begin: 0, end: isOpened ? 1.0 : 0),
              builder: (BuildContext context, double angle, Widget? child) {
                return Transform.rotate(
                  angle: angle * pi,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: Colors.black.withOpacity(0.5),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _dialogContent(
  BuildContext context,
  {String title = "Полный список",
  required List<String> list,
  }
){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      CustomText(
          text: title,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600),
      16.verticalSpace,
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 440.h),
        child: Scrollbar(
          radius: Radius.circular(10.r),
          thickness: 7.w,
          child: ListView.builder(
            itemCount: list.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final String item = list[index];
              return CustomText(
                text: item ,
                fontSize: 14.sp,
                height: 1.1,
              );
            },
          ),
        ),
      ),
      16.verticalSpace,
      CustomButton(
        height: 40.h,
        buttonColor: AppColors.blueColor,
        borderColor: AppColors.blueBorder,
        textColor: Colors.white,
        fontSize: 14.sp,
        onPressed: () {
          context.router.pop();
        },
        text: "Закрыть",
      )
    ],
  );
}