// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/activity.dart';
import 'package:activity/infrastructure/models/data/description_and_peculiarities.dart';
import 'package:activity/infrastructure/models/data/lesson.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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
          state = state.copyWith(
            gym: data,
            isGymLoading: false,
          );
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(isGymLoading: false);
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
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
          if (data.object!.isNotEmpty) {
            state = state.copyWith(
              activityTypes: data.object,
              isActivitiesListLoading: false,
              selectedActivity:
                  data.object![0], // first item as selected activity by default
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(isActivitiesListLoading: false);
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getAllPhotos(BuildContext context, int gymId) async {
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
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(isPhotosLoading: false);
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
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
        failure: (error, statusCode, operationInfo) {
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getDescribtionAndPeculiarities(String selectedActivity) async {
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

  String formatOriginalToCalendar(String inputDate) {
    try {
      final List<String> parts = inputDate.split("@");
      DateTime date = DateTime.parse(parts[0]);
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
    } catch (e) {
      return "error";
    }
  }

  Future<void> setSingleSelectedActivity(String? value) async {
    if (value == state.selectedActivity) {
      return;
    } else {
      state = state.copyWith(selectedActivity: value);
    }
  }

  Future<void> getAllLessons(
    BuildContext context, {
    required int id,
  }) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isSchedulesLoading: true);
      final response = await _activityRepositoryInterface.getSchedules(id: id);
      response.when(
        success: (data) {
          if (data.isNotEmpty) {
            state = state.copyWith(
              allLessons: data,
              isSchedulesLoading: false,
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(isSchedulesLoading: false);
          AppHelpers.showErrorSnack(
              context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  Future<void> getLessonsOfSelectedActivity(
      String selectedActivity, bool selectADefaultDay) async {
    final Map<String, dynamic> allLessons = state.allLessons;
    final String selectedActivity =
        state.selectedActivity ?? "no activity selected";
    final List<Lesson> listToCollectLessons = [];
    final List<String> listToColllectDays = [];
    final List<String> keys = allLessons.keys.toList();
    for (var key in keys) {
      allLessons[key].forEach((el) {
        if (el["lessonType"] == selectedActivity) {
          final lesson = Lesson(
            id: el["id"],
            date: el["date"],
            calendarDate: formatOriginalToCalendar(el["date"]),
            startTime: returnOnlyTime(el["date"]),
            endTime: getEndingTime(returnOnlyTime(el["date"]), el["duration"]),
            description: el["description"],
            duration: formatDuration(el["duration"]),
            lessonType: el["lessonType"],
            owner: el["owner"] != null ? Owner.fromJson(el["owner"]) : null,
            repeat: el["repeat"].cast<int>(),
            canSignUp: el["canSignUp"],
            lessonState: el["lessonState"],
          );
          listToCollectLessons.add(lesson);
          if (!listToColllectDays.contains(lesson.calendarDate)) {
            listToColllectDays.add(lesson.calendarDate ?? "");
          }
        }
      });
    }
    // makimg first day that is in state.listOf15CalendarDaysFromNow
    // as selected day
    if (selectADefaultDay) {
      for (var element in listToColllectDays) {
        if (state.listOf15CalendarDaysFromNow.contains(element)) {
          state = state.copyWith(selectedCalendarDay: element);
          break; // stop the loop
        }
      }
    }

    state = state.copyWith(
      lessonsOfSelectedActivity: listToCollectLessons,
      daysInWhichWeHaveLessons: listToColllectDays,
    );
    getLessonsToShowAfterSelectingADay(state.selectedCalendarDay ?? "");
  }

  void handleWebSocket(WebSocketChannel channel) {
    /// Listen for all incoming data

    channel.stream.listen(
      (data) async {
        Map<String, dynamic> lessonData = jsonDecode(data);
        var allLessons = state.allLessons;
        String selectedDay = "";
        final List<String> keys = allLessons.keys.toList();
        for (var key in keys) {
          allLessons[key].forEach((el) {
            if (el["id"] == lessonData["id"]) {
              el["lessonState"] = lessonData["lessonState"];
              el["duration"] = lessonData["duration"];
              el["date"] = lessonData["date"];
              el["description"] = lessonData["description"];
              selectedDay = formatOriginalToCalendar(lessonData["date"]);
            }
          });
        }
        state = state.copyWith(
          allLessons: allLessons,
        );
        //await Future.delayed(const Duration(milliseconds: 400));
        getLessonsOfSelectedActivity(state.selectedActivity ?? "", false)
            .then((value) => state = state.copyWith(
                  selectedCalendarDay: selectedDay,
                ));
      },
      onError: (error) {
        debugPrint(error.message);
      },
      onDone: () {
        debugPrint("done");
      },
    );
  }

  Future<void> setSelectedCalendarDay(String calendarDate) async {
    state = state.copyWith(selectedCalendarDay: calendarDate);
  }

  void getLessonsToShowAfterSelectingADay(String selectedDay) {
    final List<Lesson> lessons = state.lessonsOfSelectedActivity;
    final List<Lesson> listToCollectLessons = [];
    for (var lesson in lessons) {
      if (lesson.calendarDate == selectedDay) {
        listToCollectLessons.add(lesson);
      }
    }
    state =
        state.copyWith(lessonsToShowAfterSelectingADay: listToCollectLessons);
  }

  Future<void> removeSelectedCalendarDay() async {
    state = state.copyWith(selectedCalendarDay: "");
  }

  String formatDuration(String time) {
    final parts = time.split(':');
    if (parts.length != 2) {
      throw const FormatException();
    }
    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);

    if (hours == null || minutes == null) {
      throw const FormatException();
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

    return '${hoursText.isNotEmpty ? "$hoursText " : ""} ${minutesText != "0 минут" ? minutesText : ""}';
  }

  String returnOnlyTime(String text) {
    //text = "2024-02-15@11:00";
    final parts = text.split("@");
    return parts[1];
  }

  Future<void> callTo(String phone) async {
    Uri phoneScheme = Uri(scheme: "tel", path: phone);
    if (await canLaunchUrl(phoneScheme)) {
      await launchUrl(phoneScheme);
    }
  }

  Future<void> launchTelegram(String? url) async {
    const placeholderUrl = "https://t.me/furqatnasridinov";
    final uri = Uri.parse(url ?? placeholderUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> launchVk(String? url) async {
    const placeholderUrl = "https://vk.com/furqatnasridinov";
    final uri = Uri.parse(url ?? placeholderUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri); // forceWebView is true now
    } else {
      throw 'Could not launch $url';
    }
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
    // [ 'Пн 26 Дек', 'Вт 27 Дек' ...]
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
    // добавить нули в начало, если минуты < 10
    if (newTime.minute < 10) {
      return "$hour:0$minute";
    } else {
      return "$hour:$minute";
    }
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
        failure: (error, statusCode, operationInfo) {},
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  String getLinkToCompressedPhoto(String fileName) {
    int lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) {
      // Если точка в имени файла не найдена, возвращаем исходное имя
      return fileName;
    }
    String nameWithoutExtension = fileName.substring(0, lastDotIndex);
    String extension = fileName.substring(lastDotIndex);
    return "${nameWithoutExtension}_icon$extension";
  }
}
