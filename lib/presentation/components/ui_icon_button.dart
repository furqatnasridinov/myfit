import 'package:flutter/material.dart';

class UiIconButton extends StatelessWidget {
  // Иконка
  final Widget iconButton;
  // Размер иконки
  final double? iconSize;

  // Коллбэки
  final VoidCallback? onPressedAction;

  const UiIconButton({
    super.key,
    required this.iconButton,
    this.iconSize = 24.0,
    this.onPressedAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
            width: 1.0, color: const Color.fromRGBO(233, 233, 233, 1)),
      ),
      child: IconButton(
          iconSize: iconSize,
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
          ),
          padding: const EdgeInsets.all(8.0),
          icon: iconButton,
          onPressed: onPressedAction),
    );
  }
}
