// ignore_for_file: use_build_context_synchronously

import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/domain/interface/activity.dart';
import 'package:activity/infrastructure/models/request/get_gym_photos_request.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:activity/presentation/components/dummy_data.dart';
import 'package:activity/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier(this._activityRepositoryInterface)
      : super(const ActivityState());
  final ActivityRepositoryInterface _activityRepositoryInterface;

  Future<void> getInitData(BuildContext context, int gymId) async {
    getGymInfo(gymId: gymId).then((value) {
      getActivitiesList(gymId: gymId).then((value) {
        determineDefaultActivity().then((value) {
          getGymPhotos(state.selectedActivity, gymId).then((value) => {
                getSchedulesDates(context, id: gymId).then((value) {
                  getListOf15CalendarDatesFromToday().then((value) {
                    determineDefaultOriginalDate().then((value) => {
                          determineDefaultFormattedDate().then((value) {
                            getSchedulesList(state.selectedOriginalDate);
                          })
                        });
                  });
                })
              });
        });
      });
    });
  }

  Future<void> getGymInfo({required int gymId}) async {
    state = state.copyWith(isloading: true);
    final response =
        await _activityRepositoryInterface.getInfoAboutGym(id: gymId);
    response.when(
      success: (data) {
        state = state.copyWith(gym: data);
      },
      failure: (error, statusCode) {
        //print("getGymInfo notifier failure >> $error");
      },
    );
    state = state.copyWith(isloading: false);
  }

  Future<void> getActivitiesList({required int gymId}) async {
    await Future.delayed(const Duration(milliseconds: 10));
    state = state.copyWith(isloading: true);
    final response =
        await _activityRepositoryInterface.getActivities(gymId: gymId);
    response.when(
      success: (data) {
        //print("notifier get activitis success");
        //print("getActivitiesList notifier data[object] ${data["object"]}");
        state = state.copyWith(activities: data.object);
        state = state.copyWith(isloading: false);
      },
      failure: (error, statusCode) {
        //print("notifier get activitis failure");

        //print("getActivitiesList notifier failure>> $error");
        state = state.copyWith(isloading: false);
      },
    );
  }

  Future<void> determineDefaultActivity() async {
    //await Future.delayed(const Duration(seconds: 1));
    if (state.activities!.isNotEmpty) {
      state = state.copyWith(selectedActivity: state.activities?[0]);
    }
  }

  Future<void> getGymPhotos(String? lessonType, int gymId) async {
    final request = GetGymPhotosRequest(lessonType: lessonType);
    final response = await _activityRepositoryInterface.getGymPhotos(
      request: request,
      gymId: gymId,
    );
    response.when(
      success: (data) {
        final list = data.object;
        for (var i = 0; i < list!.length; i++) {
          List<String> photoUrls = [];
          photoUrls.add(list[i].pictureUrl!);
          state = state.copyWith(photos: photoUrls);
        }
      },
      failure: (error, statusCode) {},
    );
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

  void setSingleSelectedActivity(String? value) {
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

          state = state.copyWith(availableFormattedDates: formattedDates());
        },
        failure: (error, statusCode) {
          //print("(notifier failure)");
        },
      );
    // ignore: duplicate_ignore
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  getSchedulesList(String data) {
    if (DummyData().days15.contains(data)) {
      final Map<String, dynamic> mapData = state.scheddules;
      if (mapData.containsKey(data)) {
        //print("Найден ключ: $data");
        state = state.copyWith(listOfSchedules: mapData[data]);
      }
    } else {
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
            context.replaceRoute(const Main2Route());
          }
        },
        failure: (error, statusCode) {},
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }
}
