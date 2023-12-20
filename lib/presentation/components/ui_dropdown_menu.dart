// ignore_for_file: must_be_immutable

import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiDropDownMenu extends StatelessWidget {
  // Список в виде массива объектов
  final List<Map<String, dynamic>> dropDownItemsList;
  // Элемент(триггер) списка
  final Widget? dropDownChild;
  // Отрисовка бордера
  final bool? leftCornerShape;
  // Кастомное расположение
  final List? customOffset;
  double? width;
  double? height;
  double? maxWidth;

  // Коллбэки
  final VoidCallback? onOpenedAction;
  final VoidCallback? onClosedAction;

  UiDropDownMenu({
    super.key,
    required this.dropDownItemsList,
    this.dropDownChild,
    this.width,
    this.height,
    this.customOffset,
    this.leftCornerShape,
    this.onOpenedAction,
    this.onClosedAction,
    this.maxWidth = 250,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      //padding: EdgeInsets.zero,

      elevation: 0,
      color: Colors.white,
      offset: customOffset != null
          ? Offset(customOffset?[0], customOffset?[1])
          : const Offset(0, -10),
      onOpened: onOpenedAction,
      onCanceled: onClosedAction,
      constraints: BoxConstraints(maxWidth: 255.w),
      shape: OutlineInputBorder(
        borderSide: const BorderSide(color: Color.fromRGBO(119, 170, 249, 1)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16.r),
          bottomRight: Radius.circular(16.r),
          topLeft: leftCornerShape == true
              ? Radius.circular(4.r)
              : Radius.circular(16.r),
          topRight: leftCornerShape == true
              ? Radius.circular(16.r)
              : Radius.circular(4.r),
        ),
      ),
      //color: Colors.white,
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
      child: SizedBox(
        width: width,
        height: height,
        child: Row(
          children: [
            icon != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(6.0),
                    child: Container(
                      color: AppColors.backgroundColor,
                      padding: const EdgeInsets.all(3.0),
                      child: icon,
                    ),
                  )
                : const SizedBox(),
            13.horizontalSpace,
            Flexible(
              child: CustomText(
                text: title!,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            )
          ],
        ),
      ),
    );
  }
}
