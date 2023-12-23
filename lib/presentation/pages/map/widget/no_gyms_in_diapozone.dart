import 'package:activity/application/map/map_notifier.dart';
import 'package:activity/application/map/map_provider.dart';
import 'package:activity/application/map/map_state.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widget.dart';

class NoGymsInSelectedDiapozone extends StatelessWidget {
  final MapState state;
  final MapNotifier event;
  const NoGymsInSelectedDiapozone(
      {super.key, required this.state, required this.event});

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
                  ..onTap = () {
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
    );
  }
}
