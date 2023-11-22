import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/models/request/add_note_request.dart';
import 'package:activity/infrastructure/models/response/add_note_response.dart';
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';
import 'package:activity/infrastructure/services/app_constants.dart';

class ScheduleRepository implements ScheduleRepositoryInterface {
  @override
  Future<ApiResult<Map<String, dynamic>>> getUsersSchedules() async {
    try {
      final client = inject<HttpService>().clientDio();
      final resposne = await client.get(
        AppConstants.getSchedulesSearch,
      );
      return ApiResult.success(
        data: resposne.data,
      );
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<GetNearestLesson>> getNearestLesson() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getNearestLesson);
      return ApiResult.success(
        data: GetNearestLesson.fromJson(response.data),
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
  Future<ApiResult<GetUserStatsMonthResponse>> getUserStatsMonth() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(AppConstants.getUserStatsMonth);
      return ApiResult.success(
        data: GetUserStatsMonthResponse.fromJson(response.data),
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
  Future<ApiResult<AddNoteResponse>> addNotes(
      AddNoteRequest addNoteRequest) async {
    try {
      final sendingData = addNoteRequest.toJson();
      print("sendingData $sendingData");
      final client = inject<HttpService>().clientDio();
      final response = await client.post(
        AppConstants.addNote,
        data: sendingData,
      );
      return ApiResult.success(
        data: AddNoteResponse.fromJson(response.data),
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
  Future<ApiResult<Map<String, dynamic>>> getNotes() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getSchedulesSearch,
        queryParameters: {"notes": true},
      );
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