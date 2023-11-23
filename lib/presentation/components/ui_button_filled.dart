import 'package:activity/presentation/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiButtonFilled extends StatelessWidget {
  // Текст кнопки
  final String btnText;

  // Иконки кнопки

  // Слева
  final IconData? btnLeadingIcon;
  // Справа
  final IconData? btnTrailingIcon;

  // Коллбэк
  final VoidCallback? onPressedAction;

  // 100% ширина кнопки
  final bool? isFullWidth;

  const UiButtonFilled(
      {super.key,
      required this.btnText,
      this.btnLeadingIcon,
      this.btnTrailingIcon,
      this.isFullWidth,
      this.onPressedAction});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
        onPressed: onPressedAction,
        style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 11.0),
            minimumSize:
                isFullWidth == true ? const Size.fromHeight(50.0) : null,
            backgroundColor: const Color.fromRGBO(119, 170, 249, 1),
            side: const BorderSide(
                width: 1.0, color: Color.fromRGBO(89, 154, 254, 1)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(btnLeadingIcon),
            CustomText(
              text: btnText,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            Icon(btnTrailingIcon),
          ],
        ));
  }
}
