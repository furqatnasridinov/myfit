import 'package:activity/domain/di/injection.dart';
import 'package:activity/domain/handlers/api_result.dart';
import 'package:activity/domain/handlers/http_service.dart';
import 'package:activity/domain/handlers/network_exceptions.dart';
import 'package:activity/domain/interface/schedule.dart';
import 'package:activity/infrastructure/models/request/add_note_request.dart';
import 'package:activity/infrastructure/models/response/add_note_response.dart';
import 'package:activity/infrastructure/models/response/cancel_response.dart';
import 'package:activity/infrastructure/models/response/get_nearest_lesson_response.dart';
import 'package:activity/infrastructure/models/response/get_user_stats_month_response.dart';
import 'package:activity/infrastructure/services/app_constants.dart';

class ScheduleRepository implements ScheduleRepositoryInterface {
  @override
  Future<ApiResult<Map<String, dynamic>>> getUsersSchedules() async {
    try {
      final client = inject<HttpService>().clientDio();
      final resposne = await client.get(
        AppConstants.getUserSchedules,
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
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
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
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }

  @override
  Future<ApiResult<AddNoteResponse>> addNotes(
      AddNoteRequest addNoteRequest) async {
    try {
      final sendingData = addNoteRequest.toJson();

      final client = inject<HttpService>().clientDio();
      final response = await client.post(
        AppConstants.addNote,
        data: sendingData,
      );
      return ApiResult.success(
        data: AddNoteResponse.fromJson(response.data),
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
  Future<ApiResult<Map<String, dynamic>>> getNotes() async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.getUserSchedules,
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

  @override
  Future<ApiResult<CancelellationResponse>> cancelActivity(int id) async {
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.delete("api/schedule/$id/cancellation");
      return ApiResult.success(
        data: CancelellationResponse.fromJson(
          response.data,
        ),
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
  Future<ApiResult<Map<String, dynamic>>> searchingForSchedules(
      {required String schedule}) async {
    try {
      final client = inject<HttpService>().clientDio();
      final sendingData = {"searchString": schedule};
      final response = await client.get(AppConstants.getSchedulesSearch,
          //data: sendingData,
          queryParameters: sendingData);
      return ApiResult.success(
        data: response.data,
      );
    } catch (e) {
      //throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
}
