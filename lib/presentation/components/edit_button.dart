// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: must_be_immutable
class EditButton extends StatelessWidget {
  void Function()? onTap;
  void Function()? cancelOntap;
  void Function()? submitOntap;
  bool editingEnabled;
  bool newDataAdded;
  EditButton({
    Key? key,
    this.onTap,
    this.cancelOntap,
    this.submitOntap,
    this.newDataAdded = false,
    this.editingEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return /* newDataAdded
        ? Row(
            children: [
              InkWell(
                onTap: cancelOntap,
                child: CustomText(
                  text: "Отменить",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              ),
              4.horizontalSpace,
              InkWell(
                onTap: submitOntap,
                child: CustomText(
                  text: "Сохранить",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.blueText,
                ),
              ),
            ],
          )
        : */ InkWell(
            onTap: onTap,
            child: CustomText(
              text: editingEnabled ? "Отменить" : "Изменить",
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: editingEnabled ? Colors.red : AppColors.blueText,
            ),
          );
  }
}
