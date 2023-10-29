import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/domain/interface/activity.dart';
import 'package:activity/infrastructure/models/request/get_gym_photos_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier(this._activityRepositoryInterface) : super(const ActivityState());
  final ActivityRepositoryInterface _activityRepositoryInterface;

  Future<void> determineDefaultActivity() async {
    await Future.delayed(const Duration(seconds: 1));
    //print("determineDefaultActivity started");
    if (state.activities!.isNotEmpty) {
      //print("print activities isNotEmpty");
      state = state.copyWith(selectedActivity: state.activities?[0]);
    }
  }

  Future<void> determineDefaultData() async {
    if (state.originalDates.isNotEmpty) {
      state = state.copyWith(defaultDate: state.originalDates[0]);
    }
  }

  Future<void> getGymInfo() async {
    state = state.copyWith(isloading: true);
    final response = await _activityRepositoryInterface.getInfoAboutGym();
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

  Future<void> getActivitiesList() async {
    await Future.delayed(const Duration(milliseconds: 10));
    state = state.copyWith(isloading: true);
    final response = await _activityRepositoryInterface.getActivities();
    response.when(
      success: (data) {
        //print("notifier get activitis success");
        //print("getActivitiesList notifier data[object] ${data["object"]}");
        state = state.copyWith(activities: data.object);
      },
      failure: (error, statusCode) {
        //print("notifier get activitis failure");

        //print("getActivitiesList notifier failure>> $error");
      },
    );
  }

  void setSingleSelectedActivity(String? value) {
    if (value == state.selectedActivity) {
      return;
    } else {
      state = state.copyWith(selectedActivity: value);
    }
  }

  Future<void> getGymPhotos(String? lessonType) async {
    //print("notifier getGymPhotos started ");
    final request = GetGymPhotosRequest(lessonType: lessonType);
    //print("request to get photos LessonType >> ${request.toJson()}");
    final response =
        await _activityRepositoryInterface.getGymPhotos(request: request);
    response.when(
      success: (data) {
        //print("getGymPhotos notifier success");
        final _list = data.object;
        for (var i = 0; i < _list!.length; i++) {
          List<String> photoUrls = [];
          photoUrls.add(_list[i].pictureUrl!);
          state = state.copyWith(photos: photoUrls);
        }
      },
      failure: (error, statusCode) {
        //print("getGymPhotos notifier failure");
      },
    );
  }

  Future<void> getSchedulesDates({required int id}) async {
    //print("(notifier) >>> getSchedules strted ");
    final response = await _activityRepositoryInterface.getSchedules(id: id);
    response.when(
      success: (data) {
        //print("(notifier success)");
        //print("(notifier) data ${data}");
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

        state = state.copyWith(availableDates: formattedDates());
      },
      failure: (error, statusCode) {
        //print("(notifier failure)");
      },
    );
  }

  getSchedulesList(String data) {
    final Map<String, dynamic> mapData = state.scheddules;
    if (mapData.containsKey(data)) {
      //print("Найден ключ: $data");
      state = state.copyWith(listOfSchedules: mapData[data]);
    }
  }

  Future<void> setSelectedOriginalDate(String calendarDate) async {
    state = state.copyWith(isloading: true);
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

    String? convertToFormattedDate(String dateString) {
      // Разбить входную строку на части
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
        isloading: false,
        selectedOriginalDate: convertToFormattedDate(calendarDate)!);
  }

  void removeOriginalSelectedDate() {
    state = state.copyWith(selectedOriginalDate: "");
  }

  List<String> getListOfDates() {
    String month = DateFormat("MMM").format(DateTime.now());
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
    List<String> _dates = [];
    DateTime currentDate =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    while (currentDate.month.toString() == DateTime.now().month.toString()) {
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
      String formattedDate = '$dayOfWeek ${currentDate.day} $month';
      _dates.add(formattedDate);
      currentDate = currentDate.add(const Duration(days: 1));
    }
    state = state.copyWith(listOfDates: _dates);
    return _dates;
  }

  void selectADay(String day) {
    state = state.copyWith(selectedDay: day);
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
}
