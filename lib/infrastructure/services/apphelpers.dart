
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
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

  static void showCustomBottomSnack(BuildContext context,  String text, String svgPath, {int marginBottom = 25}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 28.w,
                height: 28.h,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),  
                  child: Padding(
                    padding: EdgeInsets.all(5.r),
                    child: SvgPicture.asset(
                      svgPath,
                      colorFilter: const ColorFilter.mode(
                        AppColors.blueColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
              20.horizontalSpace,
              Flexible(
                child: Text(
                  text,
                  style: GoogleFonts.raleway(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    height: 1.1,
                    fontFeatures: const [FontFeature.liningFigures()],
                  ),
                ),
              ),
            ],
          ),
          margin: EdgeInsets.only(left: 25.w, right: 25.w, bottom: marginBottom.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
            side: BorderSide(color: AppColors.blueColor, width: 1.w),
          ),
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white),
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
    Color color = Colors.red;
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

  static String getYearPrefix(int year) {
    int lastDigit = year % 10;
    int lastTwoDigits = year % 100;

    if (lastDigit == 1 && lastTwoDigits != 11) {
      return "год";
    } else if ([2, 3, 4].contains(lastDigit) &&
        ![12, 13, 14].contains(lastTwoDigits)) {
      return "года";
    } else {
      return "лет";
    }
  }

  Widget getBatteryIcon(int visited, int total) {
    double percent = 100 - (visited / total * 100);
/*     log("getBatteryIcon visited :  $visited");
    log("getBatteryIcon total : $total");
    log("getBatteryIcon percent : $percent"); */
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

  static String getFormattedDay(DateTime dateTime){
    // from 2024-05-25 00:00:00.000 to Cуббота, 25 мая
    String day = getWeekDay(dateTime.weekday);
    return "$day, ${dateTime.day} ${getMonth(dateTime.month)}";
  }

  static String getFormattedDay2(String day){
    // from 2024-05-25 to Cуббота, 25 мая
    DateTime dateTime = DateTime.parse(day);
    String dayName = getWeekDay(dateTime.weekday);
    return "$dayName, ${dateTime.day} ${getMonth(dateTime.month)}";
  }

  static String getFormattedTime(DateTime dateTime) {
    String hours = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
}

  static String getMonth(int month) {
    switch (month) {
      case 1:
        return "января";
      case 2:
        return "февраля";
      case 3:
        return "марта";
      case 4:
        return "апреля";
      case 5:
        return "мая";
      case 6:
        return "июня";
      case 7:
        return "июля";
      case 8:
        return "августа";
      case 9:
        return "сентября";
      case 10:
        return "октября";
      case 11:
        return "ноября";
      case 12:
        return "декабря";
      default:
        return "";
    }
  }

  static String getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return "Понедельник";
      case 2:
        return "Вторник";
      case 3:
        return "Среда";
      case 4:
        return "Четверг";
      case 5:
        return "Пятница";
      case 6:
        return "Суббота";
      case 7:
        return "Воскресенье";
      default:
        return "";
    }
  }

  static NotificationType getNotificationType(String str) {
    switch (str) {
      case "FINISH_LESSON":
        return NotificationType.lessonCompleted;
      case "UPDATE_LESSON":
        return NotificationType.lessonChanged;
      case "CANCEL_LESSON":
        return NotificationType.lessonCancelled;
      case "CONFIRM_LESSON":
        return NotificationType.lessonConfirmed;
      case "ENDED_LESSON":
        return NotificationType.visitsCountIsGettingLowOrEnded;
      case "QR_CODE":
        return NotificationType.lessonStartsWithin15minutes;
      default: return NotificationType.system;
    }
  }

  static String getLessonStartsAt(DateTime time) {
    // from 2024-05-25 00:00:00.000 to 25 мая в 12:00
    String hours = time.hour.toString().padLeft(2, '0');
    String minutes = time.minute.toString().padLeft(2, '0');
    return "${time.day} ${getMonth(time.month)} в $hours:$minutes";
  }

  static String getChangedLessonStartsAt(DateTime time) {
    // from 2024-05-25 00:00:00.000 to 25.05 в 12:00
    String hours = time.hour.toString().padLeft(2, '0');
    String minutes = time.minute.toString().padLeft(2, '0');
    String month = time.month.toString().padLeft(2, '0');
    return "${time.day}.$month в $hours:$minutes";
  }

  static String getChangedLessonEndsAt({required DateTime startTime, required String durationInString}){
    // from start time 2024-05-25 10:00:00.000 and durationInString 01:00:00 to 25.05 до 11:00
    // consider minutes too
    List<String> durationParts = durationInString.split(':');
    int hours = int.parse(durationParts[0]);
    int minutes = int.parse(durationParts[1]);
    DateTime endTime = startTime.add(Duration(hours: hours, minutes: minutes));
    String hoursStr = endTime.hour.toString().padLeft(2, '0');
    String minutesStr = endTime.minute.toString().padLeft(2, '0');
    String month = endTime.month.toString().padLeft(2, '0');
    return "${endTime.day}.$month до $hoursStr:$minutesStr";   
}

  static String getStringFromDateTime(DateTime dateTime) {
    // from 2024-05-25 08:00:00.000 to 2024-05-25@08:00
    String hours = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.minute.toString().padLeft(2, '0');
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    return "${dateTime.year}-$month-$day@$hours:$minutes";
    }

  static String getCalendarlikeStringFromDateTime(DateTime dateTime) {
    // from 2024-05-25 08:00:00.000 to 25.05.2024
    try {
      String month = dateTime.month.toString().padLeft(2, '0');
      String day = dateTime.day.toString().padLeft(2, '0');
      return "$day.$month.${dateTime.year}";
    } catch (e) {
      return "catched error getCalendarlikeStringFromDateTime";
    }
  }

  static String getBirthdayLikeInServer(String text){
    // from 18.11.2003 to 2003-11-18
    List<String> parts = text.split('.');
    return "${parts[2]}-${parts[1]}-${parts[0]}";
  }

  static String getBirthdayLikeInApp(String text){
    // from 2003-11-18 to 18.11.2003
    List<String> parts = text.split('-');
    return "${parts[2]}.${parts[1]}.${parts[0]}";
  }

  static int getYearFromBirthday(String birthday){
    // from 2003-11-18 to 20 
    List<String> parts = birthday.split('-');
    int month = int.parse(parts[1]);
    int day = int.parse(parts[2]);
    int year = int.parse(parts[0]);
    final bool monthCoorect = month > 0 && month < 13;
    final bool dayCorrect =  month == 2 ? day > 0 && day <= 29 : day > 0 && day < 32;
    if (monthCoorect && dayCorrect) {
      return DateTime.now().year - year;
    }else{
      return 0;
    }
  }

  static String getCostPerMonth(int actualPrice, double priceAfterPromocode, int durationInMonth){
    if (priceAfterPromocode == 0.0) {
      return (actualPrice / durationInMonth).toString();
    }else{
      return (priceAfterPromocode / durationInMonth).toString();
    }
  }

  static String getBirthdayErrorMes(String controllerText){
    if (controllerText.isEmpty) {
      return "Поле не может быть пустым";
    }else if (controllerText.length != 10) {
      return "Неверный формат даты";
    }else if(controllerText.length == 10){
      // 12.12.2000
      final List<String> parts = controllerText.split('.');
      final int day = int.parse(parts[0]);
      final int month = int.parse(parts[1]);
      final int year = int.parse(parts[2]);
      final bool monthCorrect = month > 0 && month < 13;
      final bool dayCorrect = month == 2 ? day > 0 && day <= 29 : day > 0 && day < 32;
      final bool yearCorrect = year > DateTime.now().year - 100 && year < DateTime.now().year;
      if (!monthCorrect && !dayCorrect && !yearCorrect) {
        return "Неверный формат даты";
      } 
      if (!monthCorrect && !dayCorrect && yearCorrect) {
        return "Неверно указаны месяц и день";
      }
      if (!monthCorrect && dayCorrect && yearCorrect) {
        return "Неверно указан месяц";
      }
      if (monthCorrect && !dayCorrect && yearCorrect) {
        return "Неверно указан день";
      }
      if (monthCorrect && dayCorrect && !yearCorrect) {
        return "Неверно указан год";
      }
      if (monthCorrect && !dayCorrect && !yearCorrect) {
        return "Неверно указаны день и год";
      }
      if (!monthCorrect && dayCorrect && !yearCorrect) {
        return "Неверно указаны месяц и год";
      }

    }
    return "";
}
}

