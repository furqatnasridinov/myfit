import 'package:activity/domain/handlers/api_result.dart';

abstract class SetttingsRepositoryInterface {
  Future<ApiResult<Map<String, dynamic>>> patchUser(
      {required Map<String, dynamic> request});
  //Future<ApiResult<User>> getUser(/* by token */) ;
  Future<ApiResult<Map<String, dynamic>>> getListOfCities();
}
