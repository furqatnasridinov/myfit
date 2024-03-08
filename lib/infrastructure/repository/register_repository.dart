import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/register.dart';
import 'package:activity/infrastructure/models/response/auth_response.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';

class RegisterRepository implements RegisterRepositoryInterface {
  @override
  Future<Map<String, dynamic>> sendPhoneNumber(String phoneNumber) async {
    try {
      final client = inject<HttpService>().clientDio();
      final dataToSend = {"login": phoneNumber};
      final response = await client.post(
        AppConstants.sendPhoneNumber,
        data: dataToSend,
      );
      return response.data;
    } catch (error) {
      final DioException e = error as DioException;
      return e.response?.data;
    }
  }

  @override
  Future<ApiResult<AuthResponse>> codeConfirmation(
      String phoneNumber, String code) async {
    try {
      final client = inject<HttpService>().clientDio();
      final dataToSend = {
        "login": phoneNumber,
        "confirmToken": code,
      };
      final response = await client.post(
        AppConstants.sendCodeConfirmation,
        data: dataToSend,
      );
      return ApiResult.success(
        data: AuthResponse.fromJson(response.data["object"]),
      );
    } catch (e) {      
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
