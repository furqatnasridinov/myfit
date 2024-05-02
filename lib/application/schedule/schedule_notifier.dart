// ignore_for_file: use_build_context_synchronously
import 'package:myfit/application/schedule/schedule_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/schedule.dart';
import 'package:myfit/infrastructure/models/data/completed_schedule.dart';
import 'package:myfit/infrastructure/models/request/rate_request.dart';
import 'package:myfit/infrastructure/models/response/user_schedules_response.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleNotifier extends StateNotifier<ScheduleState> {
  ScheduleNotifier(this._scheduleRepositoryInterface)
      : super(const ScheduleState());
  final ScheduleRepositoryInterface _scheduleRepositoryInterface;

  Future<void> getUsersSchedules(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isloading: true);
      final response = await _scheduleRepositoryInterface.getUsersSchedules();
      response.when(
        success: (data) {
          if (data.isNotEmpty) {
            List<UserSchedulesResponse> listToCollect = [];
            List<CompletedSchedule> waitingListToCollect = [];
            final Map<String, dynamic> dataObject = data["object"];
            dataObject.forEach((key, value) {
              final allSchedules = (value as List)
                  .map((e) => ListOfSchedules.fromJson(e))
                  .toList();

              final completedAndConfirmedSchedules = allSchedules
                  .where((schedule) =>
                      //schedule.lessonState == "COMPLETED" ||
                      schedule.lessonState == "CONFIRMED" || 
                      schedule.lessonState == "PROGRESS")
                  .toList();

              final waitingSchedules = allSchedules
                  .where((schedule) => schedule.lessonState == "WAITING")
                  .toList();

              if (completedAndConfirmedSchedules.isNotEmpty) {
                final item = UserSchedulesResponse(
                  calendarDate: key,
                  dateTime: DateTime.now(),
                  isPlusStateTriggered: false,
                  listOfSchedules: completedAndConfirmedSchedules,
                );
                listToCollect.add(item);
              }

              if (waitingSchedules.isNotEmpty) {
                final item = UserSchedulesResponse(
                  calendarDate: key,
                  dateTime: DateTime.now(),
                  isPlusStateTriggered: false,
                  listOfSchedules: waitingSchedules,
                );
                item.listOfSchedules?.forEach((el) {
                  final lesson = CompletedSchedule(
                    id: el.id ?? 0,
                    gymName: el.gym?.name ?? '',
                    describtion: el.description ?? '',
                    time: formatTime(el.date ?? ""),
                    grade: 0,
                    gymId: el.gym?.id ?? 0,
                    comment: "",
                  );
                  waitingListToCollect.add(lesson);
                });
              }
            });
            state = state.copyWith(
              listOfuserSchedules: listToCollect,
              waitingSchedules: waitingListToCollect,
              isloading: false,
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> makeARate(BuildContext context,
      {required RateRequest request}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response =
          await _scheduleRepositoryInterface.makeRate(request: request);
      response.when(
        success: (data) {
          debugPrint(data.toString());
        },
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> deleteRate(BuildContext context, {required int id}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.deleteRate(id: id);
      response.when(success: (data) {
        debugPrint(data.toString());
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
            context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void>makeLessonInProgress(BuildContext context, {required int gymId, required int lessonId}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.makeLessonInProgress(
        gymId: gymId,
        lessonId: lessonId,
      );
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            //AppHelpers.showSnack(context, data["operationInfo"]);
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
  } 

  Future<void>makeLessonCompleted(BuildContext context, {required int gymId, required int lessonId}) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.makeLessonCompleted(
        gymId: gymId,
        lessonId: lessonId,
      );
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            AppHelpers.showSnack(context, "Занятие завершено");
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
  }

  void setQrLoading(){
    state = state.copyWith(qrLoading: true);
  }

  void setQrNotLoading(){
    state = state.copyWith(qrLoading: false);
  }

  Future<void> getCompletedSchedules(BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response =
          await _scheduleRepositoryInterface.getCompletedSchedules();
      response.when(success: (data) {
        if (data["object"].length > 0) {
          final List<CompletedSchedule> listToCollect = [];
          final List<dynamic> dataObject = data["object"];
          for (var element in dataObject) {
            final item = CompletedSchedule(
              id: element["id"],
              gymName: element["gymName"],
              describtion: element["description"],
              time: formatTime(element["date"]),
              grade: element["grade"],
              gymId: element["gymId"],
              comment: element["commentMessage"] ?? "",
            );
            listToCollect.add(item);
          }
          state = state.copyWith(completedSchedules: listToCollect);
        }
      }, failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
      });
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  String formatTime(String time) {
    // from "2023-12-24@16:15" to 26.08.24 17:00
    List<String> split1 = time.split("@");
    List<String> split2 = split1[0].split("-");
    List<String> split3 = split1[1].split(":");
    final String year = split2[0].substring(2);
    final String month = split2[1];
    final String day = split2[2];
    final String hour = split3[0];
    final String minute = split3[1];
    return "$day.$month.$year $hour:$minute";
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

  void getTwoWeekDays() {
    var listToCollect = <String>[];
    DateTime now = DateTime.now();

    for (var i = 0; i < 14; i++) {
      String year = now.year.toString();
      String month = now.month <= 9 ? "0${now.month}" : now.month.toString();
      String day = now.day <= 9 ? "0${now.day}" : now.day.toString();
      String oneDay = "$year-$month-$day";
      listToCollect.add(oneDay);
      now = now.add(const Duration(days: 1));
    }

    state = state.copyWith(daysFromLastWeek: listToCollect);
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

  void changeNotificationTime(String newTime) {
    state = state.copyWith(notificationTime: newTime);
  }

  void showCompletedSchedules() {
    state = state.copyWith(completedSchedulesShown: true);
  }

  Future<void> hideCompletedSchedules() async{
    await Future.delayed(const Duration(milliseconds: 450));
    state = state.copyWith(completedSchedulesShown: false);
  }

  void showPendingSchedules() {
    state = state.copyWith(pendingSchedulesShown: true);
  }

  void hidePendingSchedules() {
    state = state.copyWith(pendingSchedulesShown: false);
  }

  Future<void> setAnimationCompletedLessons(bool val)async{
    await Future.delayed(const Duration(milliseconds: 100));
    state = state.copyWith(completedLessonListAnimaion: val);
  }

  Future<void> cancelActivity(int id, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.cancelActivity(id);
      response.when(
        success: (data) {
          AppHelpers.showSnack(context, "Запись отменена");
        },
        failure: (error, statusCode, operationInfo) {
         AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  DateTime getDateTime(String time) {
    List<String> split1 = time.split("@");
    List<String> split2 = split1[0].split("-");
    List<String> split3 = split1[1].split(":");
    final String year = split2[0];
    final String month = split2[1];
    final String day = split2[2];
    final String hour = split3[0];
    final String minute = split3[1];
    return DateTime(
      int.parse(year),
      int.parse(month),
      int.parse(day),
      int.parse(hour),
      int.parse(minute),
    );
  }

  DateTime getFinishTime(String time, String tillWhen){
    final parts = time.split("@");
    String tillwhenModified = tillWhen.length == 4 ? "0$tillWhen" : tillWhen;
    final DateTime result = DateTime.parse("${parts[0]}" " $tillwhenModified");
    return result;
  }
}
