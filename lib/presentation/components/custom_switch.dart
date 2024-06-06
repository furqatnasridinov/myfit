import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';

class CustomSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomSwitch({Key? key, required this.value, required this.onChanged})
      : super(key: key);

  @override
  CustomSwitchState createState() => CustomSwitchState();
}

class CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  Animation? _circleAnimation;
  AnimationController? _animationController;
  

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _circleAnimation = AlignmentTween(
            begin: widget.value ? Alignment.centerRight : Alignment.centerLeft,
            end: widget.value ? Alignment.centerLeft : Alignment.centerRight)
        .animate(CurvedAnimation(
            parent: _animationController!, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return GestureDetector(
          onTap: () {
            if (_animationController!.isCompleted) {
              _animationController!.reverse();
            } else {
              _animationController!.forward();
            }
            widget.value == false
                ? widget.onChanged(true)
                : widget.onChanged(false);
          },
          child: SizedBox(
            width: 44.h,
            height: 24.h,
            child: DecoratedBox(
              decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.0),
              border: Border.all(color: AppColors.blueColor),
              color: _circleAnimation!.value == Alignment.centerLeft
                  ? Colors.white
                  : AppColors.blueColor
            ),
              child: Padding(
                padding:  EdgeInsets.all(2.r),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 25.w,
                        height: 2.h,
                        child: DecoratedBox( decoration: BoxDecoration(
                          color: AppColors.fadedBlueBorder,
                          borderRadius: BorderRadius.circular(18.r),
                        ),),
                      ),
                    ),
                    Align(
                      alignment: _circleAnimation!.value,
                      child: Padding(
                        padding: EdgeInsets.only(left: 3.w),
                        child: SizedBox(
                          width: 18.w,
                          height: 18.h,
                          child: DecoratedBox(
                            decoration:  BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                    color: _circleAnimation!.value ==
                                            Alignment.centerLeft
                                        ? AppColors.blueColor
                                        : Colors.transparent),
                            color: Colors.white,
                          ),
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: widget.value
                                  ? Icon(
                                      Icons.check,
                                      size: 12.r,
                                      color: AppColors.blueColor,
                                    ) : const SizedBox.shrink(),
                            ),
                          )
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}