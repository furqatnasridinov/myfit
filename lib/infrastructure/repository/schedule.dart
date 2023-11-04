import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/services/app_constants.dart';

class ScheduleRepository implements ScheduleRepositoryInterface {
  @override
  Future<ApiResult<Map<String,dynamic>>> getUsersSchedules() async {
    try {
      final client = inject<HttpService>().clientDio();
      final resposne = await client.get(AppConstants.getUsersSchedules);
      return ApiResult.success(
        data: resposne.data,
      );
    } catch (e) {
      throw e;
      /* return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      ); */
    }
  }
}
