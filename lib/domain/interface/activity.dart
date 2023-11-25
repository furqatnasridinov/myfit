import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/request/get_gym_photos_request.dart';
import 'package:activity/infrastructure/models/response/get_gym_activities_response.dart';
import 'package:activity/infrastructure/models/response/get_gym_photos_response.dart';
import 'package:activity/infrastructure/models/response/gym_response.dart';

abstract class ActivityRepositoryInterface {
  Future<ApiResult<GymResponse>> getInfoAboutGym({required int id});
  Future<ApiResult<GetGymActivitiesResponse>> getActivities(
      {required int gymId});
  Future<ApiResult<GetGymPhotosResponse>> getGymPhotos(
      {required GetGymPhotosRequest request, required int gymId});
  Future<ApiResult<Map<String, dynamic>>> getSchedules({required int id});
  Future<ApiResult<Map<String, dynamic>>> enrollToGym(
      {required int id});
}
