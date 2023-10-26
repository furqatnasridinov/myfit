import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/gym.dart';
import 'package:activity/infrastructure/models/request/get_gym_photos_request.dart';
import 'package:activity/infrastructure/models/response/get_gym_activities_response.dart';
import 'package:activity/infrastructure/models/response/get_gym_photos_response.dart';
import 'package:activity/infrastructure/models/response/gym_response.dart';
import 'package:activity/infrastructure/services/app_constants.dart';

class GymRepository implements GymRepositoryInterface {
  @override
  Future<ApiResult<GymResponse>> getInfoAboutGym() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.gym);
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
  Future<ApiResult<GetGymActivitiesResponse>> getActivities() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.activities);
      //print("respotitory response data ${response.data}");
      return ApiResult.success(
          data: GetGymActivitiesResponse.fromJson(response.data));
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<GetGymPhotosResponse>> getGymPhotos(
      {required GetGymPhotosRequest request}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.photos,
        queryParameters: request.toJson(),
      );
      //print("request.toJson ${request.toJson()}");
      //print("repository response ${response.data["object"]}");
      return ApiResult.success(
        data: GetGymPhotosResponse.fromJson(response.data),
      );
    } catch (e) {
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
      //print("schedules respository data >>> ${response.data['object']}");
      return ApiResult.success(
        data: response.data["object"],
        //data: GetGymSchedulesResponse.fromJson(response.data),
      );
    } catch (e) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
