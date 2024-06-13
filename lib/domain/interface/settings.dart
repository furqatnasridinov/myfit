import 'dart:io';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/infrastructure/models/request/send_confirmation_code_request.dart';
import 'package:myfit/infrastructure/models/request/send_phone_number_request.dart';

abstract class SetttingsRepositoryInterface {
  Future<ApiResult<Map<String, dynamic>>> patchUser(
      {required Map<String, dynamic> request});
  Future<ApiResult<Map<String, dynamic>>> getUser();
  Future<ApiResult<Map<String, dynamic>>> getListOfCities();
  Future<ApiResult<Map<String, dynamic>>> changePhoneSendPhoneNumber(
      {required SendPhoneNumberRequest request});
  Future<ApiResult<Map<String, dynamic>>> changePhoneSendConfirmationCode(
      {required SendConfirmationCodeRequest request});
  Future<ApiResult<Map<String, dynamic>>> addPicture({required File image});

  // запросы котрорые возвращают какие уроки посещал юзер
  Future<ApiResult<Map<String, dynamic>>> getCompletedLessonTypes();
  Future<ApiResult<Map<String, dynamic>>> getWaitingLessonTypes();

  // subscribtions
  Future<ApiResult<Map<String, dynamic>>> getUserSubscribtions();
  Future<ApiResult<Map<String, dynamic>>> getAllAvailableSubscribtions();
  Future<ApiResult<Map<String, dynamic>>> purchaseSubscription({required int id, required bool autoRenewal});
  Future<ApiResult<Map<String, dynamic>>> changeNextSubscription({required int id});
  Future<ApiResult<Map<String, dynamic>>> toggleAutoRenewal({required bool val});


  // promocodes
  Future<ApiResult<Map<String, dynamic>>> applyPromocode({required String code});
  Future<ApiResult<Map<String, dynamic>>> getPromocodes();

  // referal 
  Future<ApiResult<Map<String, dynamic>>> getReferalInfo();
  Future<ApiResult<Map<String, dynamic>>> getReferalBonus();
}
