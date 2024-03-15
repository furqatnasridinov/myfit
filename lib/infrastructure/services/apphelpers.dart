import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class AppHelpers {
  static showCheckTopSnackBar(
    BuildContext context,
  ) {
    return showTopSnackBar(
      Overlay.of(context),
      const CustomSnackBar.error(
        //backgroundColor: AppColors.yellowbuttonColor,
        message: "Проверьте интернет соединение",
      ),
    );
  }

  static showSnack(BuildContext context, String text) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  static showErrorSnack(BuildContext context, String text) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: text,
      ),
    );
  }

  static void showCustomModalBottomSheet({
    required BuildContext context,
    required EdgeInsets padding,
    required double height,
    Widget? child,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) {
        return Container(
          padding: padding,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.r),
              topRight: Radius.circular(16.r),
            ),
          ),
          child: child,
        );
      },
    );
  }

  String getIconSvg(String activityName) {
    String path = "";
    switch (activityName) {
      case "Йога":
        path = "assets/svg/yoga.svg";
        break;
      case "Бассейн":
        path = "assets/svg/pool.svg";
        break;
      case "Медитации":
        path = "assets/svg/meditation.svg";
        break;
      case "Спортзал":
        path = "assets/svg/gym.svg";
        break;
      case "Секция бокса":
        path = "assets/svg/boxing.svg";
        break;
      case "Кардио-тренировки":
        path = "assets/svg/cardio.svg";
        break;
    }
    return path;
  }

  String getStatusText(String? status) {
    switch (status) {
      case "OPEN":
        return "Записаться";
      case "WAITING":
        return "Ждём ответ от заведения";
      case "CONFIRMED":
        return "Вы записаны";
      case "CANCELED_GYM":
        return "Отменено заведением";
      case "CANCELED_USER":
        //return "Отменено вами";
        return "Записаться";
      case "PROGRESS":
        return "В процессе...";
      case "COMPLETED":
        return "Завершено";
      default:
        return status ?? "";
    }
  }

  Color getStatusTextColor(String? status) {
    switch (status) {
      case "OPEN":
        return AppColors.blueText;
      case "WAITING":
        return AppColors.blueText;
      case "CONFIRMED":
        return Colors.black;
      case "CANCELED_GYM":
        return Colors.red;
      case "CANCELED_USER":
      return AppColors.blueText;
        //return Colors.red;
      case "PROGRESS":
        return Colors.green;
      case "COMPLETED":
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}
