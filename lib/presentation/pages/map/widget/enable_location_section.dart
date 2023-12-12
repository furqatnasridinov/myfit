import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class EnableLocationSection extends StatelessWidget {
  final MapNotifier event;
  const EnableLocationSection({super.key, required this.event});


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 10.h),
      child: CustomCard(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    "Чтобы мы могли более точно показывать активности рядом с вами - включите определение местоположения.",
                style: GoogleFonts.raleway(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              WidgetSpan(child: SizedBox(width: 3.w)),
              TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = () async {
                    await Geolocator.openAppSettings();
                   /*  .then((value) async {
                      LocationPermission permission =
                          await Geolocator.checkPermission();
                      if (permission == LocationPermission.always ||
                          permission == LocationPermission.whileInUse) {
                        // Perform the next action, e.g., call setUserPosition()
                        event.setUserPosition();
                      }
                    }); */
                  },
                text: "Включить",
                style: GoogleFonts.raleway(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blueText,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
