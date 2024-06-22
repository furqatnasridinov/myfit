// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'dart:developer';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/activity/activity_state.dart';
import 'package:myfit/application/main2/main2_notifier.dart';
import 'package:myfit/application/map/map_notifier.dart';
import 'package:myfit/application/schedule/schedule_notifier.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/activity.dart';
import 'package:myfit/infrastructure/models/data/calendar_data.dart';
import 'package:myfit/infrastructure/models/data/description_and_peculiarities.dart';
import 'package:myfit/infrastructure/models/data/enrolling_error_message.dart';
import 'package:myfit/infrastructure/models/data/lesson.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../presentation/components/custom_button.dart';

class ActivityNotifier extends StateNotifier<ActivityState> {
  ActivityNotifier(this._activityRepositoryInterface, this.scheduleNotifier,
      this.main2Notifier, this.mapNotifier)
      : super(const ActivityState());
  final ActivityRepositoryInterface _activityRepositoryInterface;
  final ScheduleNotifier scheduleNotifier;
  final Main2Notifier main2Notifier;
  final MapNotifier mapNotifier;

  Future<void> getGymInfo(BuildContext context, bool showLoading,
      {required int gymId}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      if (showLoading) {
        state = state.copyWith(isGymLoading: true);
      }
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

  Future<void> getListOf45CalendarDatesFromToday(DateTime? currentSubEnds) async {
      List<CalendarData> dates = [];
      DateTime currentDate = DateTime.now();
      // [ 'Пн 26 Дек', 'Вт 27 Дек' ...]

      Map<String, String> daysOfWeek = {
        "Mon": "Пн",
        "Tue": "Вт",
        "Wed": "Ср",
        "Thu": "Чт",
        "Fri": "Пт",
        "Sat": "Сб",
        "Sun": "Вс",
      };

      Map<String, String> months = {
        'Jan': 'Янв',
        'Feb': 'Фев',
        'Mar': 'Мар',
        'Apr': 'Апр',
        'May': 'Май',
        'Jun': 'Июн',
        'Jul': 'Июль',
        'Aug': 'Авг',
        'Sep': 'Сен',
        'Oct': 'Окт',
        'Nov': 'Ноя',
        'Dec': 'Дек',
      };

      for (int i = 0; i < 45; i++) {
        int year = currentDate.year;
        int day = currentDate.day;
        String dayOfWeek = daysOfWeek[DateFormat('EEE').format(currentDate)] ?? "";
        String month = months[DateFormat("MMM").format(currentDate)] ?? "";
        String formattedDate = '$dayOfWeek $day $month';
        DateTime dateTime = AppHelpers.getCalendarDateTime("$day $month $year");
        final data = CalendarData(formattedCalendarDay: formattedDate, dateTime: dateTime);
        dates.add(data);
        currentDate = currentDate.add(const Duration(days: 1));
      }

      // ограничить список дат, к дню окончания подписки только для тех кто имеет активную подписку сейчас
      

       final List<CalendarData> newDates = currentSubEnds != null ? dates.where((element) => element.dateTime.isBefore(currentSubEnds)).toList() : dates;
       final bool isCalendarLimited = newDates.length < dates.length;
        state = state.copyWith(
        listOf45CalendarDaysFromNow: newDates,
        isCalendarLimited: isCalendarLimited,
      );
    
}

  Future<void> getActivityTypes(
      BuildContext context, bool selectFirst, String selectedActivityFromMap,
      {bool isFromMap = false, required int gymId}) async {
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
            );
            if (selectedActivityFromMap.isNotEmpty) {
              state = state.copyWith(selectedActivity: selectedActivityFromMap);
            }
            if (selectFirst && selectedActivityFromMap.isEmpty) {
              state = state.copyWith(selectedActivity: data.object!.first);
            }
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

  void setIsFromSearch(bool value) {
    state = state.copyWith(isFromSearch: value);
  }

  Future<void> getInfoForType(BuildContext context, {required int id}) async {
    final connected = await AppConnectivity().connectivity();
    if (connected) {
      state = state.copyWith(infoForTypeLoading: true);
      final response =
          await _activityRepositoryInterface.getInfoForType(id: id);
      response.when(
        success: (data) {
          if (data["object"] != null) {
            state = state.copyWith(
              infosForType: data["object"],
              infoForTypeLoading: false,
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          state = state.copyWith(infoForTypeLoading: false);
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
    BuildContext context,
    bool showLoading, {
    required int id,
  }) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      if (showLoading) {
        state = state.copyWith(isSchedulesLoading: true);
      }
      final response = await _activityRepositoryInterface.getSchedules(id: id);
      response.when(
        success: (data) {
          if (data.isNotEmpty) {
            state = state.copyWith(
              allLessons: data,
            );
          }
          state = state.copyWith(isSchedulesLoading: false);
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
    final String selectedActivity = state.selectedActivity ?? "no activity selected";
    final List<Lesson> listToCollectLessons = [];
    final List<String> listToColllectDays = [];
    final List<String> keys = allLessons.keys.toList();
    for (var key in keys) {
      allLessons[key].forEach((el) {
        if (el["lessonType"] == selectedActivity) {
          try {
            final DateTime startTime =
                DateTime.parse(el["date"].toString().replaceAll("@", " "));
            final lesson = Lesson(
                id: el["id"],
                date: el["date"],
                calendarDate: formatOriginalToCalendar(el["date"]),
                startTime: returnOnlyTime(el["date"]),
                endTime:
                    getEndingTime(returnOnlyTime(el["date"]), el["duration"]),
                description: el["description"],
                duration: formatDuration(el["duration"]),
                lessonType: el["lessonType"],
                owner: el["owner"] != null ? Owner.fromJson(el["owner"]) : null,
                repeat: el["repeat"] != null ? el["repeat"].cast<int>() : [],
                canSignUp: el["canSignUp"],
                lessonState: el["lessonState"] ?? false,
                showInCalendar: DateTime.now()
                    .isBefore(startTime.subtract(const Duration(minutes: 30))),
                isDeleted: el["deleteLesson"] ?? false,
                isLoading: false,
                autoAccept: el["autoAccept"] ?? false);
            if (lesson.showInCalendar! &&
                !lesson.isDeleted! &&
                lesson.canSignUp!) {
              listToCollectLessons.add(lesson);
              if (!listToColllectDays.contains(lesson.calendarDate)) {
                listToColllectDays.add(lesson.calendarDate ?? "");
              }
            }
          } catch (e) {
            rethrow;
          }
        }
      });
    }
    // makimg first day that is in state.listOf15CalendarDaysFromNow
    // as selected day
    if (selectADefaultDay && !state.isFromSearch) {
      for (var element in listToColllectDays) {
        final bool isContains = state.listOf45CalendarDaysFromNow
            .any((element2) => element2.formattedCalendarDay == element);
        if (isContains) {
          state = state.copyWith(selectedCalendarDay: element);
          break; // stop the loop
        }
      }
    }

    if (state.isFromSearch && state.selectedDayFromSearch!.isNotEmpty) {
      final formatted = formatOriginalToCalendar(state.selectedDayFromSearch!);
      final bool thisDayisInCalendar = state.listOf45CalendarDaysFromNow
          .any((element) => element.formattedCalendarDay == formatted);
      final int index = state.listOf45CalendarDaysFromNow.indexWhere((element) => element.formattedCalendarDay == formatted);
      if (thisDayisInCalendar) {
        state = state.copyWith(selectedCalendarDay: formatted, selectedDayFromSearchIndex: index);
      }
    }

    state = state.copyWith(
      lessonsOfSelectedActivity: listToCollectLessons,
      daysInWhichWeHaveLessons: listToColllectDays,
    );
    getLessonsToShowAfterSelectingADay(state.selectedCalendarDay ?? "");
  }

  void setDayOfSelectedLessonFromSearch(String day) {
    state = state.copyWith(selectedDayFromSearch: day);
  }

  void removeSelectedDayFromSearchIndex() {
    state = state.copyWith(selectedDayFromSearchIndex: 9999);
  }

  void handleWebSocket(WebSocketChannel channel, BuildContext context) {
    //ws://77.222.53.122:8080/appSchedulePanel
    /// когда статус урока меняется на CONFIRMED или CANCELED
    channel.stream.listen(
      (data) async {
        // convert the incoming data to json
        Map<String, dynamic> lessonData = jsonDecode(data);
        if (context.router.current.path == "/activity") {
          final String gymIdFromCurrentPath = context.router.current.args
              .toString().split("gymId:")[1].replaceAll("}", "");
          if (int.parse(gymIdFromCurrentPath) == lessonData["gymId"]) {
            await getAllLessons(context, false, id: lessonData["gymId"]);
            await getLessonsOfSelectedActivity(state.selectedActivity ?? "", false);
            getGymInfo(context, false, gymId: lessonData["gymId"]);
          }
        }
        scheduleNotifier.getUsersSchedules(context, false);
        await mapNotifier.getGymsList(context, [], {});
        mapNotifier.getGetListOfGymsFromDiapozone();
        if (lessonData["lessonState"] == "CONFIRMED") {
          main2Notifier.getNearestLesson(context);
        }
      },
      onError: (error) {
        AppHelpers.showErrorSnack(context, "WebSocket1 ${error.message}");
        debugPrint(error.message);
      },
      onDone: () {
        debugPrint("done");
      },
    );
  }

  void handleWebSocket2(WebSocketChannel channel, BuildContext context) {
    //ws://77.222.53.122:8080/appGymPanel
    // когда урок добавляется или удаляется
    channel.stream.listen(
      (data) async {
        // convert the incoming data to json
        Map<String, dynamic> lessonData = jsonDecode(data);
        if (lessonData["lessonState"] == "OPEN") {
          if (context.router.current.path == "/activity") {
          final String gymIdFromCurrentPath = context.router.current.args
              .toString().split("gymId:")[1].replaceAll("}", "");
          if (int.parse(gymIdFromCurrentPath) == lessonData["gymId"]) {
            await getAllLessons(context, false, id: lessonData["gymId"]);
            await getLessonsOfSelectedActivity(state.selectedActivity ?? "", false);
          }
          //await mapNotifier.getGymsList(context, [], {});
          //mapNotifier.getGetListOfGymsFromDiapozone();
        }
        }
      },
      onError: (error) {
        AppHelpers.showErrorSnack(context, "WebSocket2 ${error.message}");
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
    // sort the list by startTime
    listToCollectLessons.sort((a, b) =>
        int.parse(a.startTime!.replaceAll(":", ""))
            .compareTo(int.parse(b.startTime!.replaceAll(":", ""))));
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

  

  String getEndingTime(String startingTime, String duration) {
    var parts = startingTime.split(":");
    final initialTime =
        TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    var durationParts = duration.split(":");
    final durationToAdd = Duration(
      hours: int.parse(durationParts[0]),
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
      if (state.isEnrollingError) {
        state = state.copyWith(isEnrollingError: false);
      }
      state = state.copyWith(isEnrollingLoading: true);
      final response = await _activityRepositoryInterface.enrollToGym(id: id);
      response.when(
        success: (data) {
          if (data["operationResult"] == "OK") {
            state = state.copyWith(isEnrollingLoading: false);
          } 
        },
        failure: (error, statusCode, operationInfo) {
          final String errorMessage = NetworkExceptions.getErrorMessage(error);
          if (errorMessage.contains("errorType")) {
            try {
              state = state.copyWith(isEnrollingError: true);
              final operationInfo = errorMessage.split("Internal Server Error, ")[1];
              final Map<String, dynamic> convertedToMap = jsonDecode(operationInfo);
              final String date = convertedToMap["date"].toString();
              // handle operation info and pass it to the dialog
              final EnrollingErrorMessage error = EnrollingErrorMessage(
                date: getDate(date),
                startTime: date.substring(date.length - 5),
                endTime: getEndingTime(date.substring(date.length - 5),
                    convertedToMap["duration"]),
                lessonType: convertedToMap["lessonType"],
                gymName: convertedToMap["gymName"],
              );
              if (convertedToMap["errorType"] == "conflictTime") {
                showConflictTimeDialog(error, context);
              } else if (convertedToMap["errorType"] == "conflictGym") {
                showConflictGymDialog(error, context);
              }
            } catch (e) {
              log(e.toString());
              state = state.copyWith(isEnrollingLoading: false, isEnrollingError: true);
              rethrow;
            }
          } else {
            state = state.copyWith(isEnrollingLoading: false, isEnrollingError: true);
            AppHelpers.showErrorSnack(context, errorMessage);
          }
          state = state.copyWith(isEnrollingLoading: false);
        },
      );
    } else {
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  String getDate(String inputDate) {
    // from 2024-05-07T17:00 to 7 мая
    final parts = inputDate.split("T");
    final date = parts[0];
    final dateParts = date.split("-");
    final day = dateParts[2];
    final month = int.tryParse(dateParts[1]);

    final monthNames = [
      "янв",
      "фев",
      "мар",
      "апр",
      "мая",
      "июня",
      "июля",
      "авг",
      "сен",
      "окт",
      "ноя",
      "дек"
    ];

    if (month != null && month >= 1 && month <= 12) {
      return "$day ${monthNames[month - 1]}";
    } else {
      return "error";
    }
  }

  void setButtonLoading(bool val){
    state = state.copyWith(buttonLoading: val);
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

  void showConflictTimeDialog(
      EnrollingErrorMessage error, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: const BorderSide(
                    color: AppColors.blueBorder,
                  )),
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: "Невозможно записаться",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/error.svg",
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: CustomText(
                            text:
                                "Нельзя записаться на два занятия, у которых совпадает время проведения.",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        34.horizontalSpace,
                        Flexible(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text:
                                  "${error.date} с ${error.startTime}-${error.endTime}",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                height: 1.1,
                                fontFeatures: const [
                                  FontFeature.liningFigures()
                                ],
                              ),
                            ),
                            WidgetSpan(child: 3.horizontalSpace),
                            TextSpan(
                              text:
                                  "вы уже записаны на занятие: “${error.lessonType}” в ${error.gymName}.",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                          ])),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    CustomButton(
                      onPressed: () {
                        context.popRoute();
                      },
                      text: "Понятно",
                      height: 40.h,
                      buttonColor: AppColors.blueColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ));
        });
  }
  void setAnimationDontHaveSub(bool val){
    state = state.copyWith(showAnimationDontHaveSubs: val);
  }

  void showConflictGymDialog(
      EnrollingErrorMessage error, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: const BorderSide(
                    color: AppColors.blueBorder,
                  )),
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      text: "Невозможно записаться",
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/error.svg",
                        ),
                        10.horizontalSpace,
                        Flexible(
                          child: CustomText(
                            text:
                                "В этом заведении в день можно посетить только одно занятие.",
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            height: 1.1,
                          ),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        //34.horizontalSpace,
                        Flexible(
                          child: RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: "Вы уже записаны в",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.1,
                                fontFeatures: const [
                                  FontFeature.liningFigures()
                                ],
                              ),
                            ),
                            WidgetSpan(child: 3.horizontalSpace),
                            TextSpan(
                              text: "${error.gymName},",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                            WidgetSpan(child: 3.horizontalSpace),
                            TextSpan(
                              text: "на активность",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.1,
                                fontFeatures: const [
                                  FontFeature.liningFigures()
                                ],
                              ),
                            ),
                            WidgetSpan(child: 3.horizontalSpace),
                            TextSpan(
                              text: "${error.lessonType}.",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                height: 1.1,
                              ),
                            ),
                            WidgetSpan(child: 3.horizontalSpace),
                            TextSpan(
                              text:
                                  "Пожалуйста выберите другой день, либо запишитесь в другое заведение.",
                              style: GoogleFonts.raleway(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.1,
                                fontFeatures: const [
                                  FontFeature.liningFigures()
                                ],
                              ),
                            ),
                          ])),
                        )
                      ],
                    ),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: CustomButton(
                            onPressed: () {
                              context.router.removeLast();
                              if (AutoTabsRouter.of(context).activeIndex != 2) {
                                AutoTabsRouter.of(context).setActiveIndex(2);
                              }
                            },
                            text: "Карта заведений",
                            height: 40.h,
                            buttonColor: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            textColor: Colors.black,
                          ),
                        ),
                        5.horizontalSpace,
                        Expanded(
                          flex: 4,
                          child: CustomButton(
                            onPressed: () {
                              context.popRoute();
                            },
                            text: "Понятно",
                            height: 40.h,
                            buttonColor: AppColors.blueColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            textColor: Colors.white,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ));
        });
  }
}
