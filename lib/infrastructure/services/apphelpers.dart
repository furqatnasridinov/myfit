import 'dart:developer';

import 'package:flutter_svg/svg.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
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
      CustomSnackBar.info(
        message: text,
        maxLines: 3,
      ),
    );
  }

  static showSuccessSnack(BuildContext context, String text) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.info(
        message: text,
        maxLines: 3,
      ),
    );
  }

  static showErrorSnack(BuildContext context, String text) {
    return showTopSnackBar(
      Overlay.of(context),
      CustomSnackBar.error(
        message: text,
        maxLines: 3,
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
    String path = "assets/svg/boxing.svg"; // будет по умолчанию
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
        //return "Отменено заведением";
        return "Записаться";
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
        //return Colors.red;
        return AppColors.blueText;
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

  String getFormattedLessonType(String? lessonType) {
    String prefix = "Яхай";
    switch (lessonType) {
      case "Кардио-тренировки":
        prefix = "на";
        break;
      case "Секция бокса":
        prefix = "на";
        break;
      case "Смешанные единоборства":
        prefix = "на";
        break;
      case "Спортзал":
        prefix = "на";
        break;
      case "Силовые тренировки":
        prefix = "на";
        break;
      case "Массаж":
        prefix = "на";
        break;
      case "Бассейн":
        prefix = "в";
        break;
      case "Йога":
        prefix = "в";
        break;
      case "Медитации":
        prefix = "на";
        break;
    }
    return prefix;
  }

  Color getColorOfActivity(String activityName) {
    Color color = Colors.black;
    switch (activityName) {
      case "Йога":
        color = AppColors.blueColor;
        break;
      case "Бассейн":
        color = AppColors.goldText;
        break;
      case "Медитации":
        color = Colors.red;
        break;
      case "Спортзал":
        color = Colors.brown;
        break;
      case "Секция бокса":
        color = AppColors.blueText;
        break;
      case "Кардио-тренировки":
        color = AppColors.green;
        break;
      case "Массаж":
        color = AppColors.massageColor;
        break;
      case "Силовые тренировки":
        color = AppColors.purpleText;
        break;
      case "Смешанные единоборства":
        color = AppColors.purpleBorder;
        break;
    }
    return color;
  }


  String getCorrectWordFromUsersCount(int usersCount) {
    int lastDigit = usersCount % 10;
    int lastTwoDigits = usersCount % 100;

    if (lastDigit == 1 && lastTwoDigits != 11) {
      return "пользователь";
    } else if ([2, 3, 4].contains(lastDigit) &&
        ![12, 13, 14].contains(lastTwoDigits)) {
      return "пользователя";
    } else {
      return "пользователей";
    }
  }

  String getMonthWord(int month) {
    if (month < 1 || month > 12) {
      throw ArgumentError(
          'Invalid month value. Only numbers from 1 to 12 are allowed.');
    }

    if (month == 1) {
      return "1 месяц";
    } else if (month >= 2 && month <= 4) {
      return "$month месяца";
    } else if (month == 6) {
      return "Пол года";
    } else {
      return "$month месяцев";
    }
  }

  Widget getBatteryIcon(int visited, int total) {
    double percent = 100 - (visited / total * 100);
    log("getBatteryIcon visited :  $visited");
    log("getBatteryIcon total : $total");
    log("getBatteryIcon percent : $percent");
    if (percent >= 1 && percent <= 19) {
      return SvgPicture.asset("assets/svg/1-19_percent.svg");
    } else if (percent >= 20 && percent <= 49) {
      return SvgPicture.asset("assets/svg/20-49_percent.svg");
    } else if (percent >= 50 && percent <= 79) {
      return SvgPicture.asset("assets/svg/50-79_percent.svg");
    } else if (percent >= 80 && percent <= 100) {
      return SvgPicture.asset("assets/svg/80-100_percent.svg");
    } else {
      // if 0
      return SvgPicture.asset("assets/svg/0_percent.svg");
    }
  }

  String getTranslatedLessonType({required String engLessonType}){
    String translatedLessonType = "Яхай";
    switch (engLessonType) {
      case "CARDIO":
        translatedLessonType = "Кардио-тренировки";
        break;
      case "BOX":
        translatedLessonType = "Секция бокса";
        break;
      case "MMA":
        translatedLessonType = "Смешанные единоборства";
        break;
      case "GYM":
        translatedLessonType = "Спортзал";
        break;
      case "POWER":
        translatedLessonType = "Силовые тренировки";
        break;
      case "MASSAGE":
        translatedLessonType = "Массаж";
        break;
      case "POOL":
        translatedLessonType = "Бассейн";
        break;
      case "YOGA":
        translatedLessonType = "Йога";
        break;
      case "MEDITATION":
        translatedLessonType = "Медитации";
        break;
    }
    return translatedLessonType;
  }
}
