import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/main.dart';
import 'package:activity/infrastructure/models/response/get_advantages_response.dart';
import 'package:activity/infrastructure/models/response/get_comments_response.dart';
import 'package:activity/infrastructure/models/response/get_subscribtions_response.dart';
import 'package:activity/infrastructure/models/response/gym_active_list.dart';
import 'package:activity/infrastructure/services/app_constants.dart';

class MainRepository implements MainRepositoryInterface {
  @override
  Future<ApiResult<GetAdvantagesResponse>> getAdvantages() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getAdvantages);
      return ApiResult.success(
        data: GetAdvantagesResponse.fromJson(response.data),
      );
    } catch (e) {
      throw e;
      /* return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      ); */
    }
  }

  @override
  Future<ApiResult<GetSubscribtionsResponse>> getSubscribtions() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getSubscribtions);
      return ApiResult.success(
        data: GetSubscribtionsResponse.fromJson(response.data),
      );
    } catch (e) {
      throw e;
      /* return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      ); */
    }
  }

  @override
  Future<ApiResult<GetCommentsResponse>> getComments() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getComments);
      return ApiResult.success(
        data: GetCommentsResponse.fromJson(response.data),
      );
    } catch (e) {
      throw e;
      /*  return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      ); */
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getGymsList() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getGymsList);
      return ApiResult.success(data: response.data);
    } catch (e) {
      throw e;
      /* return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      ); */
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> searchGym(
      {required String text}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final sendingData = {"searchString": text};
      final response = await client.get(AppConstants.searchGym,
          queryParameters: sendingData);
      return ApiResult.success(
        data: response.data,
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
