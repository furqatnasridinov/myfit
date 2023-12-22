import 'package:activity/presentation/components/components.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Description extends StatelessWidget {
  const Description({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Описание",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          InterText(
            text:
                "Смешанные единоборства в нашем зале представляют собой смесь из разных видов единоборств. Освоить все виды могут не только лишь все, мало кто может это делать.",
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
          )
        ],
      ),
    );
  }
}
