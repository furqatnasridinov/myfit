import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/response/get_gym_activities_response.dart';
import 'package:activity/infrastructure/models/response/gym_response.dart';

abstract class ActivityRepositoryInterface {
  Future<ApiResult<GymResponse>> getInfoAboutGym({required int id});
  Future<ApiResult<GetGymActivitiesResponse>> getActivities(
      {required int gymId});
  Future<ApiResult<Map<String, dynamic>>> getGymPhotos(
      { required int gymId});
  Future<ApiResult<Map<String, dynamic>>> getSchedules({required int id});
  Future<ApiResult<Map<String, dynamic>>> enrollToGym(
      {required int id});
  Future<ApiResult<Map<String,dynamic>>>getInfoForType({required int id});
}
