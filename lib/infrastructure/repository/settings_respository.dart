import 'dart:io';

import 'package:myfit/domain/di/injection.dart';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/domain/handlers/http_service.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/settings.dart';
import 'package:myfit/infrastructure/models/request/send_confirmation_code_request.dart';
import 'package:myfit/infrastructure/models/request/send_phone_number_request.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:dio/dio.dart';

class SettingsRepository implements SetttingsRepositoryInterface {
  @override
  Future<ApiResult<Map<String, dynamic>>> getListOfCities() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getCities,
      );
      return ApiResult.success(data: response.data);
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> patchUser(
      {required Map<String, dynamic> request}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.patch(
        AppConstants.patchUser,
        data: request,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> changePhoneSendConfirmationCode(
      {required SendConfirmationCodeRequest request}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final sendingData = request.toJson();
      final response = await client.post(
        AppConstants.changePhoneSendConfirmationCode,
        data: sendingData,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> changePhoneSendPhoneNumber(
      {required SendPhoneNumberRequest request}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final sendingData = request.toJson();
      final response = await client.post(
        AppConstants.changePhoneSendPhoneNumber,
        data: sendingData,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> addPicture(
      {required File image}) async {
    try {
      final client = inject<HttpService>().clientDio();
      // Convert the File into a MultipartFile
      var multipartFile = await MultipartFile.fromFile(image.path);
      // Create a FormData object
      var formData = FormData.fromMap({
        "file": multipartFile,
        "appPicture": true,
      });
      final response = await client.post(
        AppConstants.addPicture,
        data: formData,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> getUser() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getUser,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> getCompletedLessonTypes() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getCompletedLessonTypes,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> getWaitingLessonTypes() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getWaitingLessonTypes,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> getUserSubscribtions() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getUserSubscribtion,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> getAllAvailableSubscribtions() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getAllAvailableSubscribtions,
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

  
  @override
  Future<ApiResult<Map<String, dynamic>>> changeNextSubscription(
      {required int id}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.post(
        "api/subscription/user/changeTariff/$id"
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
  
  @override
  Future<ApiResult<Map<String, dynamic>>> toggleAutoRenewal({required bool val}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final Map<String, bool> sendingData = {"autoRenewal": val};
      final response = await client.patch(
        AppConstants.toggleAutoRenewal,
        queryParameters: sendingData,
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

  @override
  Future<ApiResult<Map<String, dynamic>>> purchaseSubscription({required int id,required bool autoRenewal}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final Map<String, bool> sendingData = {"autoRenewal": autoRenewal};
      final response = await client.post(
        "api/subscription/user/add/$id",
        queryParameters: sendingData,
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
  
  @override
  Future<ApiResult<Map<String, dynamic>>> applyPromocode({required String code}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final Map<String, String> sendingData = {"code": code};
      final response = await client.post(
        "api/promotional/apply",
        queryParameters: sendingData,
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
  
  @override
  Future<ApiResult<Map<String, dynamic>>> getPromocodes() async{
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        "api/promotional/history",
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