// ignore_for_file: use_build_context_synchronously
import 'package:myfit/application/main2/main2_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/schedule.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
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
    // 09 марта to 9 марта (making it INT then STRING)
    day = int.parse(day).toString();
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
    // 09 марта to 9 марта (making it INT then STRING)
    daysplitted = int.parse(daysplitted).toString();
    return "$daysplitted $month ";
  }

  String formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours % 24;
    int minutes = duration.inMinutes % 60;
    int seconds = duration.inSeconds % 60;

    String daysWord = getDayWord(days);
    String hoursWord = getHourWord(hours);
    String minutesWord = getMinuteWord(minutes + 1);

    List<String> parts = [
      if (days > 0) '$days $daysWord',
      if (hours > 0) '$hours $hoursWord',
      if (minutes > 0) '${minutes + 1} $minutesWord',
      if ((days == 0 && hours == 0 && minutes == 0) && seconds > 0)
        '$seconds секунд'
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
          if (data.bodyData != null &&
              data.bodyData?.lessonState == "CONFIRMED") {
            DateTime startingTimeInDTFormat =
                DateTime.parse(data.bodyData?.date?.replaceAll('@', 'T') ?? "");
            DateTime endTime = getEndTime(
                startingTimeInDTFormat, data.bodyData?.duration ?? "");
            DateTime fortyMinutesBeforeStart =
                startingTimeInDTFormat.subtract(const Duration(minutes: 40));
            bool lessonStartsWithin40Minutes =
                DateTime.now().isAfter(fortyMinutesBeforeStart) &&
                    DateTime.now().isBefore(startingTimeInDTFormat);
            determineWhenActivityStarts(startingTimeInDTFormat, endTime);
            state = state.copyWith(
              nearestLesson: data,
              nearestLessonIsLoading: false,
              lessonStartsAt: startingTimeInDTFormat,
              lessonEndsAt: endTime,
            );
            if (lessonStartsWithin40Minutes) {
              state = state.copyWith(lessonStartsWithin40Minutes: true);
            }
          }
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(nearestLessonIsLoading: false);
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }


  DateTime getEndTime(DateTime dateTime, String duration) {
    final durationParts = duration.split(':');
    final hours = int.parse(durationParts[0]);
    final minutes = int.parse(durationParts[1]);
    return dateTime.add(Duration(hours: hours, minutes: minutes));
  }

  void determineWhenActivityStarts(DateTime start, DateTime end) {
    DateTime now = DateTime.now();
    final fifteenMinutesBeforeStart =
        start.subtract(const Duration(minutes: 15));
    if (isBetween(fifteenMinutesBeforeStart, end, now)) {
      state = state.copyWith(showScanButton: true);
    }

    if (start.isAfter(now)) {
      Duration resultOnDuration = start.difference(now);
      String formattedDifference = formatDuration(resultOnDuration);
      state = state.copyWith(whenActivityStarts: formattedDifference);
    } else {
      state = state.copyWith(lessonIsAlreadyStarted: true);
    }
  }

  bool isBetween(DateTime start, DateTime end, DateTime now) {
    return now.isAfter(start) && now.isBefore(end);
  }

  void streamToListenDateTime() {
    if (state.lessonStartsWithin40Minutes && DateTime.now().
      isBefore(state.lessonStartsAt!.subtract(const Duration(minutes: 15)))) {
    final myDateTime = state.lessonStartsAt?.subtract(const Duration(minutes: 15));
    final timerStream = Stream.periodic(const Duration(seconds: 1), (i) => DateTime.now());
    timerStream.listen((now) {
    if (now.year == myDateTime?.year &&
        now.month == myDateTime?.month &&
        now.day == myDateTime?.day &&
        now.hour == myDateTime?.hour &&
        now.minute == myDateTime?.minute &&
        now.second == myDateTime?.second) {
      determineWhenActivityStarts(state.lessonStartsAt!, state.lessonEndsAt!);
    }
  });}
  }

  Future<void> getUserStatsMonth(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(statsMonthIsloading: true);
      final response = await _scheduleRepositoryInterface.getUserStatsMonth();
      response.when(
        success: (data) {
          List<String> listToCollectActivityNames = [];

          // sorting list by its count
          final list = data.bodyData;
          if (list != null) {
            for (var element in list) {
              listToCollectActivityNames.add(element.lessonType ?? "");
            }
          }
          // LocalStorage.setKnownActivities(listToCollectActivityNames);

          list?.sort(
            (a, b) => a.count!.compareTo(b.count!),
          );
          state = state.copyWith(
            statsMonthIsloading: false,
            statsForMonth: list!.reversed.toList(),
          );
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(statsMonthIsloading: false);
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

/*   Future<void> searchingSchedules(BuildContext context,
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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  } */

  

  void openSearchBar() {
    state = state.copyWith(isSearchbarOpened: true);
  }

  void closeSearchBar() {
    state = state.copyWith(isSearchbarOpened: false);
  }

  void hideBottomScanContainer() {
    state = state.copyWith(showScanButton: false);
  }

  void removeNearestLesson() {
    state = state.copyWith(nearestLesson: null);
  }


  
}
