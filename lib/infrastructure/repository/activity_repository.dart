import 'package:myfit/domain/di/injection.dart';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/domain/handlers/http_service.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/activity.dart';
import 'package:myfit/infrastructure/models/response/gym_response.dart';

class ActivityRepository implements ActivityRepositoryInterface {
  @override
  Future<ApiResult<GymResponse>> getInfoAboutGym({required int id}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get("api/gym/$id");
      //print("response data ${response.data["object"]}");
      return ApiResult.success(
        data: GymResponse.fromJson(response.data["object"]),
      );
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String,dynamic>>>getActivities(
      {required int gymId}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get("api/gym/$gymId/types");
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

   @override
  Future<ApiResult<Map<String, dynamic>>> getLessonTypesAndSubcategories({required int gymId}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get("api/admin/gyms/$gymId/lessonTypes");
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

  @override
  Future<ApiResult<Map<String, dynamic>>> getGymPhotos(
      {required int gymId}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        "api/gym/$gymId/photo",
      );
      return ApiResult.success(
        data: response.data,
      );
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getSchedules(
      {required int id}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get("api/gym/$id/schedule");
      return ApiResult.success(
        data: response.data["object"],
      );
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> enrollToGym({
    required int id,
  }) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.post(
        "api/schedule/$id/add",
      );
      return ApiResult.success(
        data: response.data,
      );
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getInfoForType(
      {required int id}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get("api/gym/$id/infoForType");
      return ApiResult.success(
        data: response.data,
      );
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  
 
}
