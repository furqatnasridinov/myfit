import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/models/data/gym_with_tags.dart';
import 'package:activity/infrastructure/models/request/add_note_request.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier(this._scheduleRepositoryInterface)
      : super(const ScheduleState());
  final ScheduleRepositoryInterface _scheduleRepositoryInterface;

  Future<void> getUsersSchedules(BuildContext context) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.getUsersSchedules();
      response.when(
        success: (data) {
          print("getUsersSchedules notifier success");
          print("getUsersSchedules notifier data $data");
          state = state.copyWith(schedulesInMapForm: data["object"]);
        },
        failure: (error, statusCode) {
          print("getUsersSchedules notifier success");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  String formatDay(String day) {
    final List<String> parts = day.split("-");
    String month = parts[1];
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
        month = "Декабр";
        break;
    }
    String _day = parts[2];
    switch (_day) {
      case "01":
        _day = "1";
        break;
      case "02":
        _day = "2";
        break;
      case "03":
        _day = "3";
        break;
      case "04":
        _day = "4";
        break;
      case "05":
        _day = "5";
        break;
      case "06":
        _day = "6";
        break;
      case "07":
        _day = "7";
        break;
      case "08":
        _day = "8";
        break;
      case "09":
        _day = "9";
        break;
      default:
    }
    return "$month $_day";
  }

  String determineWeekday(String day) {
    DateTime dateTime = DateTime.parse(day);
    String dayOfWeek = DateFormat("EEE").format(dateTime);
    switch (dayOfWeek) {
      case "Mon":
        dayOfWeek = "Понедельник";
        break;
      case "Tue":
        dayOfWeek = "Вторник";
        break;
      case "Wed":
        dayOfWeek = "Среда";
        break;
      case "Thu":
        dayOfWeek = "Четверг";
        break;
      case "Fri":
        dayOfWeek = "Пятница";
        break;
      case "Sat":
        dayOfWeek = "Суббота";
        break;
      case "Sun":
        dayOfWeek = "Воскресенье";
        break;
      default:
    }
    return dayOfWeek;
  }

  String durationToHour(String duration) {
    List<String> parts = duration.split(':');
    if (parts.length != 2) {
      return 'Неверный формат';
    }
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    double durationInHours = hours + minutes / 60;
    String formattedDuration = durationInHours.toStringAsFixed(1) + ' часа';
    return formattedDuration;
  }

  String durationToTillWhen(String startTime, String duration) {
    List<String> startParts = startTime.split(':');
    List<String> durationParts = duration.split(':');
    if (startParts.length != 2 || durationParts.length != 2) {
      return 'Неверный формат';
    }
    int startHours = int.parse(startParts[0]);
    int startMinutes = int.parse(startParts[1]);
    int durationHours = int.parse(durationParts[0]);
    int durationMinutes = int.parse(durationParts[1]);
    int totalMinutes =
        startHours * 60 + startMinutes + durationHours * 60 + durationMinutes;
    int newHours = totalMinutes ~/ 60;
    int newMinutes = totalMinutes % 60;
    String formattedTime = '$newHours:${newMinutes.toString().padLeft(2, '0')}';
    return formattedTime;
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
    String days = duration.inDays > 0 ? "${duration.inDays} дня" : "";
    String hours =
        duration.inHours % 24 > 0 ? "${duration.inHours % 24} час" : "";
    String minutes =
        duration.inMinutes % 60 > 0 ? "${duration.inMinutes % 60} минут" : "";

    List<String> parts = [days, hours, minutes];
    parts.removeWhere((part) => part.isEmpty);

    return parts.join(' ');
  }

  Future<void> getNearestLesson(BuildContext context) async {
    state = state.copyWith(isloading: true);
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.getNearestLesson();
      response.when(
        success: (data) {
          if (data.bodyData != null) {
            print("getNearestLesson notifier success, data >> $data");
            determineWhenActivityStarts(data.bodyData!.date!);
            state = state.copyWith(nearestLesson: data);
          }
        },
        failure: (error, statusCode) {
          print("getNearestLesson notifier failure");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
    state = state.copyWith(isloading: false);
  }

  Future<void> getUserStatsMonth(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.getUserStatsMonth();
      response.when(
        success: (data) {
          print(
              "notifier getUserStatsMonth success, data >>  ${data.bodyData?.length}");
          // sorting list by its count
          final _list = data.bodyData;
          _list?.sort(
            (a, b) => a.count!.compareTo(b.count!),
          );
          state = state.copyWith(statsForMonth: _list!.reversed.toList());
        },
        failure: (error, statusCode) {
          print("notifier getUserStatsMonth failure");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getNotes(BuildContext context, String gymName) async {
    print("getNotes called");
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isloading: true);
      final response = await _scheduleRepositoryInterface.getNotes();
      response.when(
        success: (data) {
          print("getNotes notifier success");
          if (gymName.isNotEmpty) {
            List<GymWithTags> _list = [];
            final mapData = data["object"];
            mapData.forEach((key, value) {
              value.forEach((element) {
                if (gymName == element["gym"]["name"]) {
                  final data = GymWithTags(
                    date: element["date"],
                    id: element["id"],
                    description: element["description"],
                    duration: element["duration"],
                    gym: Gym.fromJson(element["gym"] ?? {}),
                    tag: (element["tag"] as List<dynamic>?)
                        ?.map((tag) => Tag.fromJson(tag))
                        .toList(),
                  );
                  _list.add(data);
                }
              });
            });
            state = state.copyWith(listOfGymWithTags: _list);
          } else {
            List<GymWithTags> _list = [];
            final mapData = data["object"];
            mapData.forEach((key, value) {
              value.forEach((element) {
                final data = GymWithTags(
                  date: element["date"],
                  id: element["id"],
                  description: element["description"],
                  duration: element["duration"],
                  gym: Gym.fromJson(element["gym"] ?? {}),
                  tag: (element["tag"] as List<dynamic>?)
                      ?.map((tag) => Tag.fromJson(tag))
                      .toList(),
                );
                _list.add(data);
              });
            });
            state = state.copyWith(listOfGymWithTags: _list);
          }

          state = state.copyWith(isloading: false);
          //state = state.copyWith(notesMapData: mapData);
        },
        failure: (error, statusCode) {
          print("getNotes notifier failure");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> addNote(
      String tag, String description, int id, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final request = AddNoteRequest(
        tag: tag,
        description: description,
        lesson: Lesson(id: id),
      );
      final response = await _scheduleRepositoryInterface.addNotes(request);
      response.when(
        success: (data) {
          print("addNote notifier success");
        },
        failure: (error, statusCode) {
          print("addNote notifier failure");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void showTilWhen() {
    state = state.copyWith(showTillWhen: true);
  }

  void hideTilWhen() {
    state = state.copyWith(showTillWhen: false);
  }

  void triggerPlusState() {
    state = state.copyWith(plusState: true);
  }

  void removePlusState() {
    state = state.copyWith(plusState: false);
  }

  void enableLocationButton() {
    state = state.copyWith(isLocationButtonActivated: true);
  }

  void disnableLocationButton() {
    state = state.copyWith(isLocationButtonActivated: false);
  }

  void enableFlashButton() {
    state = state.copyWith(isFlashButtonActivated: true);
  }

  void disnableFlashButton() {
    state = state.copyWith(isFlashButtonActivated: false);
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

  void changeNotificationTime(String newTime) {
    state = state.copyWith(notificationTime: newTime);
  }

  Future<void> cancelActivity(int id, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.cancelActivity(id);
      response.when(
        success: (data) {
          print("cancelActivity notifier success");
        },
        failure: (error, statusCode) {
          print("cancelActivity notifier failure");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }
}
