import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_card.dart';
import 'package:activity/presentation/components/ya_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TheOneWithMap extends StatelessWidget {
  const TheOneWithMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: 'Рядом с вами есть чем заняться:',
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        UiCard(
          cardMaxWidth: MediaQuery.of(context).size.width * 1,
          cardValue: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  _taskRow(Icons.adb, 'Силовые тренировки', '5'),
                  _taskRow(Icons.adb, 'Йога', '5'),
                ],
              ),
              10.verticalSpace,
              const UiYaMap()
            ],
          ),
        )
      ],
    );
  }

  _taskRow(IconData? icon, String? name, String? count) {
    return Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Container(
          color: const Color.fromRGBO(245, 249, 255, 1),
          padding: const EdgeInsets.all(5.0),
          child: Icon(
            icon,
            color: const Color.fromRGBO(62, 134, 245, 1),
            size: 18.0,
          ),
        ),
      ),
      const SizedBox(
        width: 6.0,
      ),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: '$name - ',
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: Colors.black),
            ),
            TextSpan(
              text: count,
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    ]);
  }
}
