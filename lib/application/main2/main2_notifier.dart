import 'package:activity/application/main2/main2_state.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/models/data/schedule_and_gym.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Main2Notifier extends StateNotifier<Main2State> {
  Main2Notifier(this._scheduleRepositoryInterface) : super(const Main2State());
  final ScheduleRepositoryInterface _scheduleRepositoryInterface;

  String dateTimeNowToString(DateTime now) {
    // Декабр 16
    var month = now.month.toString();
    var day = now.day.toString();
    switch (month) {
      case "01":
        month = "Январ";
        break;
      case "02":
        month = "Феврал";
        break;
      case "03":
        month = "Март";
        break;
      case "04":
        month = "Апрель";
        break;
      case "05":
        month = "Май";
        break;
      case "06":
        month = "Июнь";
        break;
      case "07":
        month = "Июль";
        break;
      case "08":
        month = "Август";
        break;
      case "09":
        month = "Сентябрь";
        break;
      case "10":
        month = "Октябрь";
        break;
      case "11":
        month = "Ноябрь";
        break;
      case "12":
        month = "Декабрь";
        break;
    }
    switch (day) {
      case "01":
        day = "1";
        break;
      case "02":
        day = "2";
        break;
      case "03":
        day = "3";
        break;
      case "04":
        day = "4";
        break;
      case "05":
        day = "5";
        break;
      case "06":
        day = "6";
        break;
      case "07":
        day = "7";
        break;
      case "08":
        day = "8";
        break;
      case "09":
        day = "9";
        break;
      default:
    }
    return "$month $day";
  }

  String formatDay(String day) {
    final List<String> parts = day.split("-");
    String month = parts[1];
    switch (month) {
      case "01":
        month = "Января";
        break;
      case "02":
        month = "Февраля";
        break;
      case "03":
        month = "Марта";
        break;
      case "04":
        month = "Апреля";
        break;
      case "05":
        month = "Мая";
        break;
      case "06":
        month = "Июня";
        break;
      case "07":
        month = "Июля";
        break;
      case "08":
        month = "Августа";
        break;
      case "09":
        month = "Сентября";
        break;
      case "10":
        month = "Октября";
        break;
      case "11":
        month = "Ноября";
        break;
      case "12":
        month = "Декабря";
        break;
    }
    String daysplitted = parts[2];
    switch (daysplitted) {
      case "01":
        daysplitted = "1";
        break;
      case "02":
        daysplitted = "2";
        break;
      case "03":
        daysplitted = "3";
        break;
      case "04":
        daysplitted = "4";
        break;
      case "05":
        daysplitted = "5";
        break;
      case "06":
        daysplitted = "6";
        break;
      case "07":
        daysplitted = "7";
        break;
      case "08":
        daysplitted = "8";
        break;
      case "09":
        daysplitted = "9";
        break;
      default:
    }

    return "$daysplitted $month ";
  }

  void determineWhenActivityStarts(String startTime) {
    // startTime 2023-11-11@13:15
    List<String> parts = startTime.split("@");
    String formatted = "${parts[0]} ${parts[1]}:00";
    DateTime startingTimeInDTFormat = DateTime.parse(formatted);
    DateTime now = DateTime.now();
    Duration resultOnDuration = startingTimeInDTFormat.difference(now);
    String formattedDifference = formatDuration(resultOnDuration);
    state = state.copyWith(whenActivityStarts: formattedDifference);
  }

  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;

    String daysWord = getDayWord(days);
    String hoursWord = getHourWord(hours);
    String minutesWord = getMinuteWord(minutes);

    List<String> parts = [
      if (days > 0) '$days $daysWord',
      if (hours > 0) '$hours $hoursWord',
      if (minutes > 0) '$minutes $minutesWord'
    ];

    return parts.join(' ');
  }

  String getDayWord(int number) {
    number = number % 100;
    if (number >= 11 && number <= 19) {
      return 'дней';
    } else {
      switch (number % 10) {
        case 1:
          return 'день';
        case 2:
        case 3:
        case 4:
          return 'дня';
        default:
          return 'дней';
      }
    }
  }

  String getHourWord(int number) {
    number = number % 100;
    if (number >= 11 && number <= 19) {
      return 'часов';
    } else {
      switch (number % 10) {
        case 1:
          return 'час';
        case 2:
        case 3:
        case 4:
          return 'часа';
        default:
          return 'часов';
      }
    }
  }

  String getMinuteWord(int number) {
    number = number % 100;
    if (number >= 11 && number <= 19) {
      return 'минут';
    } else {
      switch (number % 10) {
        case 1:
          return 'минута';
        case 2:
        case 3:
        case 4:
          return 'минуты';
        default:
          return 'минут';
      }
    }
  }

  Future<void> getNearestLesson(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(nearestLessonIsLoading: true);
      final response = await _scheduleRepositoryInterface.getNearestLesson();
      response.when(
        success: (data) {
          if (data.bodyData != null) {
            determineWhenActivityStarts(data.bodyData!.date!);
            state = state.copyWith(
              nearestLesson: data,
              nearestLessonIsLoading: false,
            );
          }
          if (data.bodyData == null) {
            state = state.copyWith(
              nearestLesson: null,
              nearestLessonIsLoading: false,
            );
          }
        },
        failure: (error, statusCode) {
          state = state.copyWith(nearestLessonIsLoading: false);
          AppHelpers.showErrorSnack(context, error.toString());
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getUserStatsMonth(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(statsMonthIsloading: true);
      final response = await _scheduleRepositoryInterface.getUserStatsMonth();
      response.when(
        success: (data) {
          // sorting list by its count
          final list = data.bodyData;
          list?.sort(
            (a, b) => a.count!.compareTo(b.count!),
          );
          state = state.copyWith(
            statsMonthIsloading: false,
            statsForMonth: list!.reversed.toList(),
          );
        },
        failure: (error, statusCode) {
          state = state.copyWith(statsMonthIsloading: false);
          AppHelpers.showErrorSnack(context, error.toString());
        },
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> searchingSchedules(BuildContext context,
      {required String schedule}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.searchingForSchedules(
        schedule: schedule,
      );
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            final Map<String, dynamic> mapData = data["object"];
            final list = <ScheduleAndGym>[];
            mapData.forEach((key, value) {
              value.forEach((element) {
                final data = ScheduleAndGym(
                  id: element["id"],
                  date: element["date"],
                  description: element["description"],
                  duration: element["duration"],
                  gym: Gymdata.fromJson(element["gym"]),
                );
                list.add(data);
              });
            });
            state = state.copyWith(schedulesFoundBySearching: list);
          }
        },
        failure: (error, statusCode) {},
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void openSearchBar() {
    state = state.copyWith(isSearchbarOpened: true);
  }

  void closeSearchBar() {
    state = state.copyWith(isSearchbarOpened: false);
  }

  Future<void> cleanSearchList() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final listcha = <ScheduleAndGym>[];
    state = state.copyWith(schedulesFoundBySearching: listcha);
  }

  Color getColors(int index) {
    if (index == 0) {
      return AppColors.goldText;
    }
    if (index == 1) {
      return AppColors.purpleText;
    }
    if (index == 2) {
      return AppColors.blueColor;
    } else {
      return Colors.grey.shade400;
    }
  }
}
