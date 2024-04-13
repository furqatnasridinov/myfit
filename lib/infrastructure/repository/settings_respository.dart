import 'dart:io';

import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/settings.dart';
import 'package:activity/infrastructure/models/request/send_confirmation_code_request.dart';
import 'package:activity/infrastructure/models/request/send_phone_number_request.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
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
  Future<ApiResult<Map<String, dynamic>>> getCompletedLessonTypes() async{
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
  Future<ApiResult<Map<String, dynamic>>> getWaitingLessonTypes() async{
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
}
