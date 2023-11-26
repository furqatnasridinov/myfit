import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/inter_text.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:activity/presentation/components/ui_card.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithButton extends StatefulWidget {
  const TheOneWithButton({super.key});

  @override
  State<TheOneWithButton> createState() => _TheOneWithButtonState();
}

class _TheOneWithButtonState extends State<TheOneWithButton> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: 'Раз! Два! И готово!',
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      UiCard(
          cardValue: Column(
        children: [
          InterText(
            text:
                'Пара простых вопросов и мы подберём для вас идеальный вариант, который поможет достигать целей и будет на оптимальном расстоянии от вашего местоположения!',
            fontWeight: FontWeight.w400,
            fontSize: 12.sp,
          ),
          const SizedBox(height: 10.0),
          UiButtonFilled(
            isFullWidth: true,
            btnText: 'То, что нужно! Вперёд!',
            onPressedAction: () {
              //context.router.push(const Main2Route());
              /*   setState(() {
                activeStepState++;
              }); */
            },
          )
        ],
      ))
    ]);
  }
}
