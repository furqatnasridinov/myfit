import 'package:myfit/domain/di/injection.dart';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/domain/handlers/http_service.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/notification.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';

class NotificationRepository implements NotificationRepositoryInterface{
  @override
  Future<ApiResult<Map<String, dynamic>>> getListOfNotifications(
      {required bool showNew, required int page, required int limit}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getNotifications, 
        queryParameters: {
        "new": showNew,
        "pageNumber": page,
        "pageSize": limit,
      });
      return ApiResult.success(
        data: response.data as Map<String, dynamic>
      );
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> markNotificationAsRead(
      {required bool all, required int id}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.post(AppConstants.markNotificationAsRead, 
      queryParameters: {
        "all": all,
        "notificationId": id,
      });
      return ApiResult.success(data: response.data as Map<String, dynamic>);
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}