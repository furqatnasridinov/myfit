import 'package:myfit/domain/di/injection.dart';
import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/domain/handlers/http_service.dart';
import 'package:myfit/domain/handlers/network_exceptions.dart';
import 'package:myfit/domain/interface/membership.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';

class MembershipRepository implements MembershipRepositoryInterface{
  @override
   Future<ApiResult<List<MemberShip>>> getMemberShipByGymId({required int gymId}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        AppConstants.searchMembership,
        queryParameters: {
          'gymId': gymId,
        },
      );
      final List list = response.data["object"] as List;
      final List<MemberShip> returnVal = list.isEmpty ? [] : list.map((e) => MemberShip.fromJson(e)).toList();
      return ApiResult.success(
        data: returnVal,
      );
    } catch (e) {
      // throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  
  @override
  Future<ApiResult<Map<String, dynamic>>> buyMembership({required int membershipId}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.post(
        "api/crm/client/$membershipId"
      );
      return ApiResult.success(
        data: response.data,
      );
    } catch (e) {
      // throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  
  @override
  Future<ApiResult<List<MemberShip>>> getMemberShipByUserId({required int userId}) async{
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        "api/crm/client/$userId/membership"
      );
      final List list = response.data["object"] as List;
      final List<MemberShip> returnVal = list.isEmpty ? [] : list.map((e) => MemberShip.fromJson(e)).toList();
      return ApiResult.success(
        data: returnVal,
      );
    } catch (e) {
      // throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  
  @override
  Future<ApiResult<List<MemberShip>>> getAllMemberships() async{
    try {
      final client = inject<HttpService>().clientDio();
      final response = await client.get(
        "api/crm/membership"
      );
      final List list = response.data["object"] as List;
      final List<MemberShip> returnVal = list.isEmpty ? [] : list.map((e) => MemberShip.fromJson(e)).toList();
      return ApiResult.success(
        data: returnVal,
      );
    } catch (e) {
      // throw e;
      return ApiResult.failure(
        error: NetworkExceptions.getDioException(e),
        statusCode: NetworkExceptions.getDioStatus(e),
      );
    }
  }
  
}