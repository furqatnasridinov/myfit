import 'package:flutter/material.dart';


class UiDropDownMenu extends StatelessWidget {
  // Список в виде массива объектов
  final List<Map<String, dynamic>> dropDownItemsList;
  // Элемент(триггер) списка
  final Widget? dropDownChild;
  // Отрисовка бордера
  final bool? leftCornerShape;
  // Кастомное расположение
  final List? customOffset;

  // Коллбэки
  final VoidCallback? onOpenedAction;
  final VoidCallback? onClosedAction;

  const UiDropDownMenu(
      {super.key,
      required this.dropDownItemsList,
      this.dropDownChild,
      this.customOffset,
      this.leftCornerShape,
      this.onOpenedAction,
      this.onClosedAction});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      offset: customOffset != null
          ? Offset(customOffset?[0], customOffset?[1])
          : const Offset(0, 10),
      onOpened: onOpenedAction,
      onCanceled: onClosedAction,
      shape: OutlineInputBorder(
          borderSide: const BorderSide(color: Color.fromRGBO(119, 170, 249, 1)),
          borderRadius: BorderRadius.only(
            bottomLeft: const Radius.circular(16.0),
            bottomRight: const Radius.circular(16.0),
            topLeft: leftCornerShape == true
                ? const Radius.circular(4.0)
                : const Radius.circular(16.0),
            topRight: leftCornerShape == true
                ? const Radius.circular(16.0)
                : const Radius.circular(4.0),
          )),
      color: Colors.white,
      position: PopupMenuPosition.under,
      itemBuilder: (BuildContext context) => [
        ...dropDownItemsList
            .map((el) => _dropDownMenuRow(el['title'].toString(), el['icon'],
                el['iconColor'], el['action']))
            .toList()
      ],
      child: dropDownChild,
    );
  }

  PopupMenuItem _dropDownMenuRow(
      String? title, Widget? icon, Color? iconColor, VoidCallback? action) {
    return PopupMenuItem(
      onTap: action,
      child: Row(
        children: [
          icon != null
              ? Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6.0),
                      child: Container(
                          color: const Color.fromRGBO(245, 249, 255, 1),
                          padding: const EdgeInsets.all(3.0),
                          child: icon),
                    ),
                    const SizedBox(width: 13.0),
                  ],
                )
              : const SizedBox(),
          Flexible(
            child: Text(
              title.toString(),
              //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
            ),
          )
        ],
      ),
    );
  }
}
