import 'dart:io';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/infrastructure/models/request/send_confirmation_code_request.dart';
import 'package:myfit/infrastructure/models/request/send_phone_number_request.dart';

abstract class SetttingsRepositoryInterface {
  Future<ApiResult<Map<String, dynamic>>> patchUser(
      {required Map<String, dynamic> request});
  Future<ApiResult<Map<String, dynamic>>> getUser() ;
  Future<ApiResult<Map<String, dynamic>>> getListOfCities();
  Future<ApiResult<Map<String, dynamic>>> changePhoneSendPhoneNumber(
      {required SendPhoneNumberRequest request});
  Future<ApiResult<Map<String, dynamic>>> changePhoneSendConfirmationCode(
      {required SendConfirmationCodeRequest request});
  Future<ApiResult<Map<String, dynamic>>> addPicture({required File image});

  // запросы котрорые возвращают какие уроки посещал юзер
  Future<ApiResult<Map<String, dynamic>>> getCompletedLessonTypes();
  Future<ApiResult<Map<String, dynamic>>> getWaitingLessonTypes();
}
