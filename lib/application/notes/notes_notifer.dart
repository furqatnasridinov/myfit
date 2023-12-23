import 'package:activity/application/notes/notes_state.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/models/data/gym_with_tags.dart';
import 'package:activity/infrastructure/models/request/add_note_request.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:activity/infrastructure/services/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesNotifier extends StateNotifier<NotesState> {
  NotesNotifier(this._scheduleRepositoryInterface) : super(const NotesState());
  final ScheduleRepositoryInterface _scheduleRepositoryInterface;
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

  Future<void> getNotes(BuildContext context, String gymName) async {
    final connect = await AppConnectivity().connectivity();
    if (connect) {
      state = state.copyWith(isloading: true);
      final response = await _scheduleRepositoryInterface.getNotes();
      response.when(
        success: (data) {
          if (gymName.isNotEmpty) {
            List<GymWithTags> list = [];
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
                  list.add(data);
                }
              });
            });
            state = state.copyWith(listOfGymWithTags: list);
          } else {
            List<GymWithTags> gymList = [];
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
                gymList.add(data);
              });
            });
            state = state.copyWith(listOfGymWithTags: gymList);
          }
          state = state.copyWith(isloading: false);
          //state = state.copyWith(notesMapData: mapData);
        },
        failure: (error, statusCode) {
          state = state.copyWith(isloading: false);
        },
      );
    } else {
      // ignore: use_build_context_synchronously
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
        success: (data) {},
        failure: (error, statusCode) {},
      );
    } else {
      // ignore: use_build_context_synchronously
      AppHelpers.showCheckTopSnackBar(context);
    }
  }

  void addNewNote(Tag tag) {
    List<GymWithTags> newAddedTages = [];
    newAddedTages.addAll(state.listOfGymWithTagsWithNewAddedTags);
    newAddedTages.add(GymWithTags(tag: [tag]));
    state = state.copyWith(listOfGymWithTagsWithNewAddedTags: newAddedTages);
  }
}
