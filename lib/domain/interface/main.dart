import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/infrastructure/models/request/get_yandex_map_image_request.dart';
import 'package:myfit/infrastructure/models/response/get_advantages_response.dart';
import 'package:myfit/infrastructure/models/response/get_comments_response.dart';
import 'package:myfit/infrastructure/models/response/get_subscribtions_response.dart';

abstract class MainRepositoryInterface {
  Future<ApiResult<GetAdvantagesResponse>> getAdvantages();
  Future<ApiResult<GetSubscribtionsResponse>> getSubscribtions();
  Future<ApiResult<GetCommentsResponse>> getComments();
  Future<ApiResult<Map<String, dynamic>>> getGymsList();
  Future<ApiResult<Map<String, dynamic>>> searchGym({required String text});
  Future<ApiResult<dynamic>> getYandexMapImage(
      {required GetYandexMapImageRequest request});
    Future<ApiResult<Map<String, dynamic>>> searchForGymAndLesson({required String searchString});
    Future<ApiResult<Map<String, dynamic>>> getRecommendationForVisiting();
}
