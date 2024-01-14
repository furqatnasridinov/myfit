import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/settings.dart';
import 'package:activity/infrastructure/services/app_constants.dart';

class SettingsRepository implements SetttingsRepositoryInterface {
  @override
  Future<ApiResult<Map<String, dynamic>>> getListOfCities() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getCities,
      );
      return ApiResult.success(data: response.data);
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> patchUser(
      {required Map<String, dynamic> request}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final sendingData = request;
      final response = await client.patch(
        AppConstants.patchUser,
        data: sendingData,
      );
      return ApiResult.success(
        data: response.data,
      );
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
