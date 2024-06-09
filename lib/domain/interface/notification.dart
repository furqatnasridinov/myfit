import 'package:myfit/domain/handlers/api_result.dart';

abstract class NotificationRepositoryInterface {
  Future<ApiResult<Map<String, dynamic>>> getListOfNotifications({
    required bool showNew,
    required int page,
    required int limit,
  });
  Future<ApiResult<Map<String, dynamic>>> markNotificationAsRead({
    required bool all,
    required int id,
  });
}