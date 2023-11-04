import 'package:flutter/material.dart';

class UiButtonOutlined extends StatelessWidget {
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

  const UiButtonOutlined(
      {super.key,
      required this.btnText,
      this.btnLeadingIcon,
      this.btnTrailingIcon,
      this.isFullWidth,
      this.onPressedAction});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressedAction,
        style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 11.0),
            minimumSize:
                isFullWidth == true ? const Size.fromHeight(50.0) : null,
            side: const BorderSide(
              width: 1.0,
              color: Color.fromRGBO(89, 154, 254, 1),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            )),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(btnLeadingIcon),
            Text(
              btnText,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Icon(btnTrailingIcon),
          ],
        ));
  }
}
