import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UiBottomModal {
  static void openModal(
    context,
    String title,
    Widget modalChild,
  ) {
    showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0))),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.only(
                top: 16.0, left: 16.0, right: 16.0, bottom: 40.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 38,
                  child: Divider(
                    height: 3,
                    thickness: 3,
                    color: Color.fromRGBO(217, 217, 217, 1),
                  ),
                ),
                const SizedBox(height: 32.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomText(
                    text: title,
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                const SizedBox(height: 16.0),
                modalChild
              ],
            ),
          );
        });
  }
}
