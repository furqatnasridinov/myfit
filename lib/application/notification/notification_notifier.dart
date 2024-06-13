// ignore_for_file: use_build_context_synchronously

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/notification/notification_state.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/notification.dart';
import 'package:myfit/infrastructure/models/data/notification.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/infrastructure/services/connectivity.dart';

class NotificationNotifier extends StateNotifier<NotificationState>{
  NotificationNotifier(this._notificationRepositoryInterface) : super(const NotificationState());
  final NotificationRepositoryInterface _notificationRepositoryInterface;

  void setLoading(bool value){
    state = state.copyWith(isLoading: value);
  }
  
  Future<void> getAllNotifications(
      {bool showNewOnly = false, int page = 1, int limit = 200}) async {
    final isConnected = await AppConnectivity().connectivity();
    if (isConnected) {
      final response = await _notificationRepositoryInterface
          .getListOfNotifications(showNew: showNewOnly, page: page, limit: limit);
      response.when(
        success: (data) {
          List<NotificationModel> listToCollecAlltNotifications = [];
          if (data["operationResult"] == "OK") {
            final List<dynamic> responseBody = data["object"] as List<dynamic>;
            for (var element in responseBody) {
              final item = NotificationModel(
                id: element["id"] ?? 0,
                type: AppHelpers.getNotificationType(element["notificationType"]),
                lessonType: element["lessonType"] ?? "",
                iSread: element["isRead"],
                date: DateTime.parse(element["createDate"].toString().replaceAll("T", " ")),
                lessonStartDate: element["lessonTime"] != null
                    ? DateTime.parse(element["lessonTime"].toString().replaceAll("T", " "))
                    : DateTime.now(),
                title: element["message"],
                description: element["messageFull"],
                gymName: element["gymName"] ?? "",
                gymId: element["gymId"] ?? 0,
                grade: element["grade"] ?? 0,
                rateId: element["lessonId"] ?? 0,
                lessonDescription: element["description"] ?? "",
                commentContent: element["commentMessage"] ?? "",
                updates: element["updateLesson"] ?? {},
                visitedCount: element["visitedCount"] ?? 0,
                visitPerMonth: element["visitPerMonth"] ?? 0,
                reason: element["reason"] ?? "",
              );
              listToCollecAlltNotifications.add(item);
            }
            List<NotificationModel> listToCollectNewNotifications =
                listToCollecAlltNotifications.where((element) => !element.iSread).toList();
            if (listToCollectNewNotifications.isNotEmpty) {
              setHasUnreadNotification(true);
            }
            state = state.copyWith(
              allNotifications: listToCollecAlltNotifications,
              onlyNewNotifications: listToCollectNewNotifications,
              isLoading: false,
            );
          }
        },
        failure: (error, statusCode, operationInfo) {
          debugPrint("getAllNotifications Error: ${NetworkExceptions.getErrorMessage(error)}");
          //AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
        },
      );
    } else {
      //AppHelpers.showCheckTopSnackBar(context);
    }
  }

  /* void onPopNotificationRoute() {
    //if (state.onlyNewNotifications.isNotEmpty) {
      getAllNotifications();
    //}
  } */

  void toggleShowNewOnly(bool value){
    state = state.copyWith(showNewOnly: value);
  }

  Future<void> markNotificationAsRead({required BuildContext context, required bool all, required int id}) async {
    final response = await _notificationRepositoryInterface.markNotificationAsRead(all: all, id: id);
    response.when(
      success: (data) {
        if (data["operationResult"] == "OK") {
          debugPrint("Notification marked as read");
        }
      },
      failure: (error, statusCode, operationInfo) {
        AppHelpers.showErrorSnack(context, NetworkExceptions.getErrorMessage(error));
      },
    );
  }

  void handleReadAll({required BuildContext context})async{
    if (state.onlyNewNotifications.isNotEmpty) {
      final NotificationModel lastNotification = state.onlyNewNotifications.first;
      await markNotificationAsRead(context: context, all: true, id: lastNotification.id);
      setHasUnreadNotification(false);
    }
  }

  void setHasUnreadNotification(bool value){
    state = state.copyWith(hasUnreadNotification: value);
  }
}