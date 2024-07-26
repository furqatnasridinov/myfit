import 'package:myfit/domain/di/injection.dart';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/domain/handlers/http_service.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/register.dart';
import 'package:myfit/infrastructure/models/response/auth_response.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';

class RegisterRepository implements RegisterRepositoryInterface {
  @override
  Future<ApiResult<Map<String,dynamic>>> sendPhoneNumber(String phoneNumber) async {
    try {
      final client = inject<HttpService>().clientDio();
      final dataToSend = {"login": phoneNumber};
      final response = await client.post(
        AppConstants.sendPhoneNumber,
        data: dataToSend,
      );
      return ApiResult.success(data: response.data);
    } catch (error) {
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(error),
        statusCode: NetworkExceptions.getDioStatus(error),
      );
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
        "app" : true,
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
  
  @override
  Future<ApiResult<Map<String,dynamic>>> updateFcmToken({required String token}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final dataToSend = {"fcmToken": token};
      final response = await client.post(
        AppConstants.updateFcmToken,
        data: dataToSend,
      );
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
}
