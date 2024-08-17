import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/map/map_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/animation_button_effect.dart';
import 'package:myfit/presentation/pages/map/widget/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class MapPageTopSection extends StatelessWidget {
  const MapPageTopSection(
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Consumer(
        builder: (context, ref, child) {
          final event = ref.read(mapProvider.notifier);
          final double selectedDiapozone = ref.watch(mapProvider).selectedDiapozone;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                      text: 'Карта активностей',
                      style: GoogleFonts.raleway(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    WidgetSpan(child: SizedBox(width: 7.w,)),
                    TextSpan(
                      text: selectedDiapozone.toInt() == 5 ? "${selectedDiapozone.toInt().toString()}+ км" : "${selectedDiapozone.toInt().toString()} км", 
                      style: GoogleFonts.raleway(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.greyText,
                        fontFeatures: const [FontFeature.liningFigures()],
                      ),
                    ),
                    ],
                  ),
                ),
              GestureDetector(
                onTap: () {
                  event.removePopUp();
                  AppHelpers.showCustomModalBottomSheet(
                    context: context,
                    padding: EdgeInsets.only(
                      left: 16.w,
                      right: 16.w,
                      bottom: 30.h,
                    ),
                    height: 360.h,
                    child: DiapozoneBottomSheet(
                      event: event,
                    ),
                  );
                },
                child: AnimationButtonEffect(
                  child: SizedBox(
                    width: 40.w,
                    height: 40.h,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.w, color: AppColors.greyBorder),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/svg/icon_filter.svg",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
