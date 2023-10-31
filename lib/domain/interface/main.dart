import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/response/get_advantages_response.dart';
import 'package:activity/infrastructure/models/response/get_comments_response.dart';
import 'package:activity/infrastructure/models/response/get_subscribtions_response.dart';

abstract class MainRepositoryInterface{
  Future<ApiResult<GetAdvantagesResponse>>getAdvantages();
  Future<ApiResult<GetSubscribtionsResponse>>getSubscribtions();
  Future<ApiResult<GetCommentsResponse>>getComments();
}