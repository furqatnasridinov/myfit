// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/domain/interface/activity.dart';
import 'package:activity/infrastructure/models/data/activity.dart';
import 'package:activity/infrastructure/models/data/description_and_peculiarities.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier(this._activityRepositoryInterface)
      : super(const ActivityState());
  final ActivityRepositoryInterface _activityRepositoryInterface;

  Future<void> getGymInfo(BuildContext context, {required int gymId}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isGymLoading: true);
      final response =
          await _activityRepositoryInterface.getInfoAboutGym(id: gymId);
      response.when(
        success: (data) {
          state = state.copyWith(gym: data, isGymLoading: false);
        },
        failure: (error, statusCode) {
          state = state.copyWith(isGymLoading: false);
          AppHelpers.showErrorSnack(context, "$error $statusCode");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getActivityTypes(BuildContext context,
      {required int gymId}) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isActivitiesListLoading: true);
      final response =
          await _activityRepositoryInterface.getActivities(gymId: gymId);
      response.when(
        success: (data) {
          state = state.copyWith(
            activityTypes: data.object,
            isActivitiesListLoading: false,
          );
        },
        failure: (error, statusCode) {
          state = state.copyWith(isActivitiesListLoading: false);
          AppHelpers.showErrorSnack(context, "$error $statusCode");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> determineDefaultActivity() async {
    //await Future.delayed(const Duration(seconds: 1));
    if (state.activityTypes!.isNotEmpty) {
      state = state.copyWith(selectedActivity: state.activityTypes?[0]);
    }
  }

  Future<void> getGymPhotos(BuildContext context, int gymId) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(isPhotosLoading: true);
      final response = await _activityRepositoryInterface.getGymPhotos(
        gymId: gymId,
      );
      response.when(
        success: (data) {
          if (data["object"] != null) {
            state = state.copyWith(
              allPhotos: data["object"],
              isPhotosLoading: false,
            );
          }
        },
        failure: (error, statusCode) {
          state = state.copyWith(isPhotosLoading: false);
          AppHelpers.showErrorSnack(context, "$error $statusCode");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getInfoForType(BuildContext context, {required int id}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      final response =
          await _activityRepositoryInterface.getInfoForType(id: id);
      response.when(
        success: (data) {
          if (data["object"] != null) {
            state = state.copyWith(infosForType: data["object"]);
          }
        },
        failure: (error, statusCode) {
          AppHelpers.showErrorSnack(context, "$error $statusCode");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getDescribtionAndPeculiarities(String selectedActivity) async{
    final mapData = state.infosForType;
    if (mapData.containsKey(selectedActivity)) {
      for (var element in mapData[selectedActivity]) {
        final data = DescribtionAndPeculiarities(
            typeDescription: element["typeDescription"],
            peculiarities: element["peculiarities"]);
        state = state.copyWith(describtionAndPeculiarities: data);
      }
    }
  }

  void getPhotosOfSelectedActivity(String selectedActivity) {
    final mapData = state.allPhotos;
    List<String> photos = [];
    if (mapData.containsKey(selectedActivity)) {
      for (var element in mapData[selectedActivity]) {
        photos.add(element);
      }
    }
    state = state.copyWith(photosOfSelectedActivity: photos);
  }

  Future<void> determineDefaultOriginalDate() async {
    final all15OriginalDays = state.listOf15OriginalDaysFromNow;
    final availableOriginalDays = state.originalDates;
    final list = <String>[];
    for (var element in availableOriginalDays) {
      if (all15OriginalDays.contains(element)) {
        list.add(element);
      }
    }

    state = state.copyWith(selectedOriginalDate: list.first);
  }

  Future<void> determineDefaultFormattedDate() async {
    final original = state.selectedOriginalDate;
    final formatted = formatOriginalToCalendar(original);
    state = state.copyWith(selectedFormattedDay: formatted);
  }

  String formatOriginalToCalendar(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String day = DateFormat('d').format(date);
    String month = DateFormat('MMM').format(date);
    switch (month) {
      case 'Jan':
        month = 'Янв';
        break;
      case 'Feb':
        month = 'Фев';
        break;
      case 'Mar':
        month = 'Мар';
        break;
      case 'Apr':
        month = 'Апр';
        break;
      case 'May':
        month = 'Май';
        break;
      case 'Jun':
        month = 'Июн';
        break;
      case 'Jul':
        month = 'Июль';
        break;
      case 'Aug':
        month = 'Авг';
        break;
      case 'Sep':
        month = 'Сен';
        break;
      case 'Oct':
        month = 'Окт';
        break;
      case 'Nov':
        month = 'Ноя';
        break;
      case 'Dec':
        month = 'Дек';
        break;
    }
    String dayOfWeek = DateFormat.E().format(date);
    switch (dayOfWeek) {
      case "Mon":
        dayOfWeek = "Пн";
        break;
      case "Tue":
        dayOfWeek = "Вт";
        break;
      case "Wed":
        dayOfWeek = "Ср";
        break;
      case "Thu":
        dayOfWeek = "Чт";
        break;
      case "Fri":
        dayOfWeek = "Пт";
        break;
      case "Sat":
        dayOfWeek = "Сб";
        break;
      case "Sun":
        dayOfWeek = "Вс";
        break;
    } // Get the day of the week
    return '$dayOfWeek $day $month';
  }

  String formatOriginalToCalendarFullNames(String inputDate) {
    DateTime date = DateTime.parse(inputDate);
    String day = DateFormat('d').format(date);
    String month = DateFormat('MMM').format(date);
    switch (month) {
      case 'Jan':
        month = 'Январь';
        break;
      case 'Feb':
        month = 'Февраль';
        break;
      case 'Mar':
        month = 'Март';
        break;
      case 'Apr':
        month = 'Апрель';
        break;
      case 'May':
        month = 'Май';
        break;
      case 'Jun':
        month = 'Июнь';
        break;
      case 'Jul':
        month = 'Июль';
        break;
      case 'Aug':
        month = 'Август';
        break;
      case 'Sep':
        month = 'Сентябрь';
        break;
      case 'Oct':
        month = 'Октябрь';
        break;
      case 'Nov':
        month = 'Ноябрь';
        break;
      case 'Dec':
        month = 'Декабрь';
        break;
    }
    return '$month $day';
  }

  Future<void> setSingleSelectedActivity(String? value) async {
    if (value == state.selectedActivity) {
      return;
    } else {
      state = state.copyWith(selectedActivity: value);
    }
  }

  Future<void> getSchedulesDates(
    BuildContext context, {
    required int id,
  }) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isSchedulesLoading: true);
      final response = await _activityRepositoryInterface.getSchedules(id: id);
      response.when(
        success: (data) {
          state = state.copyWith(scheddules: data);
          List<String> originalDates = data.keys.toList();
          state = state.copyWith(originalDates: originalDates);
          //print("originalDates $originalDates");
          List<String> formattedDates() {
            return originalDates.map((date) {
              DateTime dateTime = DateTime.parse(date);
              String day = DateFormat('d').format(dateTime);
              String month = DateFormat('MMM').format(dateTime);
              switch (month) {
                case 'Jan':
                  month = 'Янв';
                  break;
                case 'Feb':
                  month = 'Фев';
                  break;
                case 'Mar':
                  month = 'Мар';
                  break;
                case 'Apr':
                  month = 'Апр';
                  break;
                case 'May':
                  month = 'Май';
                  break;
                case 'Jun':
                  month = 'Июн';
                  break;
                case 'Jul':
                  month = 'Июль';
                  break;
                case 'Aug':
                  month = 'Авг';
                  break;
                case 'Sep':
                  month = 'Сен';
                  break;
                case 'Oct':
                  month = 'Окт';
                  break;
                case 'Nov':
                  month = 'Ноя';
                  break;
                case 'Dec':
                  month = 'Дек';
                  break;
              }
              String dayOfWeek = DateFormat.E().format(dateTime);
              switch (dayOfWeek) {
                case "Mon":
                  dayOfWeek = "Пн";
                  break;
                case "Tue":
                  dayOfWeek = "Вт";
                  break;
                case "Wed":
                  dayOfWeek = "Ср";
                  break;
                case "Thu":
                  dayOfWeek = "Чт";
                  break;
                case "Fri":
                  dayOfWeek = "Пт";
                  break;
                case "Sat":
                  dayOfWeek = "Сб";
                  break;
                case "Sun":
                  dayOfWeek = "Вс";
                  break;
              } // Get the day of the week
              return '$dayOfWeek $day $month';
            }).toList();
          }

          state = state.copyWith(
              availableFormattedDates: formattedDates(),
              isSchedulesLoading: false);
        },
        failure: (error, statusCode) {
          state = state.copyWith(isSchedulesLoading: false);
          AppHelpers.showErrorSnack(context, "$error $statusCode");
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  getSchedulesList(String data) {
    final Map<String, dynamic> mapData = state.scheddules;
    List<Activity> activities = [];
    if (mapData.containsKey(data)) {
      for (var element in mapData[data]) {
        final activity = Activity(
          element["id"],
          returnOnlyTime(element["date"]),
          getEndingTime(returnOnlyTime(element["date"]), element["duration"]),
          formatDuration(element["duration"]),
          element["description"],
        );
        activities.add(activity);
      }
      //print("Найден ключ: $data");
      state = state.copyWith(listOfSchedules: activities);
    }
  }

  String formatDuration(String time) {
    final parts = time.split(':');
    if (parts.length != 2) {
      throw const FormatException('Неверный формат времени');
    }
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);

    if (hours == null || minutes == null) {
      throw const FormatException('Неверный формат времени');
    }

    String hoursText = '';
    String minutesText = '';

    // Склонение часов
    if (hours > 0) {
      if (hours % 10 == 1 && hours % 100 != 11) {
        hoursText = '$hours час';
      } else if ([2, 3, 4].contains(hours % 10) &&
          ![12, 13, 14].contains(hours % 100)) {
        hoursText = '$hours часа';
      } else {
        hoursText = '$hours часов';
      }
    }

    // Склонение минут
    if (minutes % 10 == 1 && minutes % 100 != 11) {
      minutesText = '$minutes минута';
    } else if ([2, 3, 4].contains(minutes % 10) &&
        ![12, 13, 14].contains(minutes % 100)) {
      minutesText = '$minutes минуты';
    } else {
      minutesText = '$minutes минут';
    }

    return '${hoursText.isNotEmpty ? "$hoursText " : ""}$minutesText';
  }

  String returnOnlyTime(String text) {
    final parts = text.split("@");
    return parts[1];
  }

  Future<void> callTo(String phone) async {
    Uri phoneScheme = Uri(scheme: "tel", path: phone);
    if (await canLaunchUrl(phoneScheme)) {
      await launchUrl(phoneScheme);
    }
  }

  Future<void> launchTelegram() async {
    const url = "https://t.me/furqatnasridinov";
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  String? convertToOriginalDate(String dateString) {
    final parts = dateString.split(' ');

    if (parts.length != 3) {
      return null;
    }
    final monthMapping = {
      'Янв': '01',
      'Фев': '02',
      'Мар': '03',
      'Апр': '04',
      'Май': '05',
      'Июн': '06',
      'Июль': '07',
      'Авг': '08',
      'Сен': '09',
      'Окт': '10',
      'Ноя': '11',
      'Дек': '12',
    };

    final dayOfWeekMapping = {
      'Пн': 'Monday',
      'Вт': 'Tuesday',
      'Ср': 'Wednesday',
      'Чт': 'Thursday',
      'Пт': 'Friday',
      'Сб': 'Saturday',
      'Вс': 'Sunday',
    };

    final fullMonth = monthMapping[parts[2]];
    final fullDayOfWeek = dayOfWeekMapping[parts[0]];

    if (fullMonth == null || fullDayOfWeek == null) {
      return null;
    }
    final formattedDate =
        "${DateTime.now().year}-$fullMonth-${parts[1].padLeft(2, '0')}";

    return formattedDate;
  }

  Future<void> setSelectedOriginalDate(String calendarDate) async {
    // Маппинг для месяцев и дней недели
    final monthMapping = {
      'Янв': '01',
      'Фев': '02',
      'Мар': '03',
      'Апр': '04',
      'Май': '05',
      'Июн': '06',
      'Июль': '07',
      'Авг': '08',
      'Сен': '09',
      'Окт': '10',
      'Ноя': '11',
      'Дек': '12',
    };

    final dayOfWeekMapping = {
      'Пн': 'Monday',
      'Вт': 'Tuesday',
      'Ср': 'Wednesday',
      'Чт': 'Thursday',
      'Пт': 'Friday',
      'Сб': 'Saturday',
      'Вс': 'Sunday',
    };

    String? convertToOriginalDate(String dateString) {
      final parts = dateString.split(' ');

      if (parts.length != 3) {
        return null;
      }

      final fullMonth = monthMapping[parts[2]];
      final fullDayOfWeek = dayOfWeekMapping[parts[0]];

      if (fullMonth == null || fullDayOfWeek == null) {
        return null;
      }
      final formattedDate =
          "${DateTime.now().year}-$fullMonth-${parts[1].padLeft(2, '0')}";

      return formattedDate;
    }

    state = state.copyWith(
        selectedOriginalDate: convertToOriginalDate(calendarDate)!);
  }

  void removeOriginalSelectedDate() {
    state = state.copyWith(selectedOriginalDate: "");
  }

  Future<void> getListOf15CalendarDatesFromToday() async {
    List<String> dates = [];
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 15; i++) {
      String dayOfWeek = DateFormat('EEE').format(currentDate);
      switch (dayOfWeek) {
        case "Mon":
          dayOfWeek = "Пн";
          break;
        case "Tue":
          dayOfWeek = "Вт";
          break;
        case "Wed":
          dayOfWeek = "Ср";
          break;
        case "Thu":
          dayOfWeek = "Чт";
          break;
        case "Fri":
          dayOfWeek = "Пт";
          break;
        case "Sat":
          dayOfWeek = "Сб";
          break;
        case "Sun":
          dayOfWeek = "Вс";
          break;
      }
      String month = DateFormat("MMM").format(currentDate);
      switch (month) {
        case 'Jan':
          month = 'Янв';
          break;
        case 'Feb':
          month = 'Фев';
          break;
        case 'Mar':
          month = 'Мар';
          break;
        case 'Apr':
          month = 'Апр';
          break;
        case 'May':
          month = 'Май';
          break;
        case 'Jun':
          month = 'Июн';
          break;
        case 'Jul':
          month = 'Июль';
          break;
        case 'Aug':
          month = 'Авг';
          break;
        case 'Sep':
          month = 'Сен';
          break;
        case 'Oct':
          month = 'Окт';
          break;
        case 'Nov':
          month = 'Ноя';
          break;
        case 'Dec':
          month = 'Дек';
          break;
      }
      String formattedDate = '$dayOfWeek ${currentDate.day} $month';
      dates.add(formattedDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    state = state.copyWith(listOf15CalendarDaysFromNow: dates);
  }

  Future<void> getListOf15OriginalDatesFromToday() async {
    List<String> dates = [];
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 15; i++) {
      String month = DateFormat("MMM").format(currentDate);
      switch (month) {
        case 'Jan':
          month = '01';
          break;
        case 'Feb':
          month = '02';
          break;
        case 'Mar':
          month = '03';
          break;
        case 'Apr':
          month = '04';
          break;
        case 'May':
          month = '05';
          break;
        case 'Jun':
          month = '06';
          break;
        case 'Jul':
          month = '07';
          break;
        case 'Aug':
          month = '08';
          break;
        case 'Sep':
          month = '09';
          break;
        case 'Oct':
          month = '10';
          break;
        case 'Nov':
          month = '11';
          break;
        case 'Dec':
          month = '12';
          break;
      }
      String formattedDate = "${currentDate.year}-$month-${currentDate.day}";
      dates.add(formattedDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    state = state.copyWith(listOf15OriginalDaysFromNow: dates);
  }

  void selectADay(String day) {
    state = state.copyWith(selectedFormattedDay: day);
  }

  String getEndingTime(String startingTime, String duration) {
    var parts = startingTime.split(":");
    final initialTime =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    var durationParts = duration.split(":");
    final durationToAdd = Duration(
      hours: int.parse(
        durationParts[0],
      ),
      minutes: int.parse(durationParts[1]),
    );
    final initialDuration =
        Duration(hours: initialTime.hour, minutes: initialTime.minute);
    final newDuration = initialDuration + durationToAdd;
    final newTime = TimeOfDay(
      hour: newDuration.inHours,
      minute: newDuration.inMinutes.remainder(60),
    );
    final String hour = newTime.hour.toString();
    final String minute = newTime.minute.toString();
    return "$hour:$minute";
  }

  Future<void> enrollToGym(BuildContext context, int id) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      final response = await _activityRepositoryInterface.enrollToGym(id: id);
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            //context.replaceRoute(const Main2Route());
          }
        },
        failure: (error, statusCode) {},
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }
}
