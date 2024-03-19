import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/infrastructure/models/response/auth_response.dart';

abstract class RegisterRepositoryInterface{
  Future<ApiResult<Map<String,dynamic>>>sendPhoneNumber(String phoneNumber);
  Future<ApiResult<AuthResponse>>codeConfirmation(String phoneNumber, String code);
}