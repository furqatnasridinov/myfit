import 'package:flutter/material.dart';


class UiActionButtonOutlined extends StatelessWidget {
  // Текст кнопки
  final String title;

  // Иконка слева
  final IconData? btnLeadingIcon;

  // Коллбэк при тапе на кнопку
  final VoidCallback? onTapAction;

  const UiActionButtonOutlined(
      {super.key,
      required this.title,
      required this.btnLeadingIcon,
      this.onTapAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapAction,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              width: 1.0,
              color: const Color.fromRGBO(233, 233, 233, 1),
            ),
            borderRadius: BorderRadius.circular(8.0)),
        padding: const EdgeInsets.only(
            top: 6.0, bottom: 6.0, left: 8.0, right: 16.0),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Container(
              color: const Color.fromRGBO(245, 249, 255, 1),
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                btnLeadingIcon,
                color: const Color.fromRGBO(62, 134, 245, 1),
                size: 18.0,
              ),
            ),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Text(
            title,
            //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
          ),
        ]),
      ),
    );
  }
}
