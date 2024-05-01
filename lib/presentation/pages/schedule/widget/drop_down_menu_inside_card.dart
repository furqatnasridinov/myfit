// ignore_for_file: must_be_immutable
import 'package:myfit/presentation/components/ui_dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class DropDownMenuInsideCard extends StatelessWidget {
  void Function()? onTap;
  void Function()? onTap2;
  DropDownMenuInsideCard({
    super.key,
    this.onTap,
    this.onTap2,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return UiDropDownMenu(
          width: 230.w,
          maxWidth: 255.w,
          height: 45.h,
          customOffset: [-25.0.w, -25.h],
          dropDownItemsList: [
            {
              'title': 'Открыть заметки',
              'icon': SvgPicture.asset(
                'assets/svg/edit_icon.svg',
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': onTap,
            },
            {
              'title': 'Подробнее о заведении',
              'icon': SvgPicture.asset(
                'assets/svg/copy.svg',
                colorFilter: const ColorFilter.mode(
                  Color.fromRGBO(62, 134, 245, 1),
                  BlendMode.srcIn,
                ),
                height: 18.h,
                width: 18.w,
              ),
              'action': onTap2,
            },
          ],
          dropDownChild: const Icon(
            Icons.more_vert,
            color: Colors.black,
          ),
          //
        );
      },
    );
  }
}
