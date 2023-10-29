import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/request/get_gym_photos_request.dart';
import 'package:activity/infrastructure/models/response/get_gym_activities_response.dart';
import 'package:activity/infrastructure/models/response/get_gym_photos_response.dart';
import 'package:activity/infrastructure/models/response/gym_response.dart';

abstract class ActivityRepositoryInterface {
  Future<ApiResult<GymResponse>> getInfoAboutGym();
  Future<ApiResult<GetGymActivitiesResponse>> getActivities();
  Future<ApiResult<GetGymPhotosResponse>> getGymPhotos(
      {required GetGymPhotosRequest request});
  Future<ApiResult<Map<String,dynamic>>> getSchedules(
      {required int id});
}
