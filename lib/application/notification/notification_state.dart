import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfit/infrastructure/models/data/notification.dart';
part 'notification_state.freezed.dart';


@freezed
class NotificationState with _$NotificationState{
  const factory NotificationState({
    @Default(false) bool isLoading,
    @Default([]) List<NotificationModel> allNotifications,
    @Default([]) List<NotificationModel> onlyNewNotifications,
    @Default(false) bool showNewOnly,
    @Default(false) bool hasUnreadNotification,
  }) = _NotificationState;

  const NotificationState._();

}