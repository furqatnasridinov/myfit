import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/domain/interface/schedule.dart';
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

  void showTilWhen(){
    state = state.copyWith(showTillWhen: true);
  }
  void hideTilWhen(){
    state = state.copyWith(showTillWhen: false);
  }
}
