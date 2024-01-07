// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/models/response/user_schedules_response.dart';
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
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isloading: true);
      final response = await _scheduleRepositoryInterface.getUsersSchedules();
      response.when(
        success: (data) {
          if (data.isNotEmpty) {
            List<UserSchedulesResponse> listToCollect = [];
            final Map<String, dynamic> dataObject = data["object"];
            dataObject.forEach((key, value) {
              final item = UserSchedulesResponse(
                calendarDate: key,
                dateTime: DateTime.now(),
                isPlusStateTriggered: false,
                listOfSchedules: (value as List)
                    .map((e) => ListOfSchedules.fromJson(e))
                    .toList(),
              );
              listToCollect.add(item);
            });
            state = state.copyWith(
              listOfuserSchedules: listToCollect,
              isloading: false,
            );
          }
        },
        failure: (error, statusCode) {
          AppHelpers.showErrorSnack(context, "$error $statusCode");
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
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

  Future<void> cancelActivity(int id, BuildContext context) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _scheduleRepositoryInterface.cancelActivity(id);
      response.when(
        success: (data) {},
        failure: (error, statusCode) {},
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
}
