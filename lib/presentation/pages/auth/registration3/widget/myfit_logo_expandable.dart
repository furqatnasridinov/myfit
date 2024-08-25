import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MyfitLogoExpandable extends StatelessWidget {
  final bool isAllFieldsSumbitted;
  const MyfitLogoExpandable({super.key, required this.isAllFieldsSumbitted});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return AnimatedPositioned(
            top: isAllFieldsSumbitted ? 0 : 100.h,
            left: isAllFieldsSumbitted ? 0 : width/2 - 70.w,
            right: isAllFieldsSumbitted ? 0 : width/2 - 70.w,
            duration: const Duration(milliseconds: 500),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              width: isAllFieldsSumbitted ? width : 140.w,
              height: isAllFieldsSumbitted ? height : 140.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32.r),
              ),
              child: Wrap(
                alignment: WrapAlignment.center,
                runAlignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  AnimatedScale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    scale: isAllFieldsSumbitted ? 1 : 0.65,
                    child: SvgPicture.asset(
                      'assets/svg/MY.svg',
                    ),
                  ),
                  10.horizontalSpace,
                  AnimatedScale(
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOut,
                    scale: isAllFieldsSumbitted ? 1 : 0.65,
                    child: SvgPicture.asset(
                      'assets/svg/FIT.svg',
                    ),
                  ),
                ],
              ),
            ),
            
          );
  }
}