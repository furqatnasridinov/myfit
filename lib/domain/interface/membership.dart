import 'package:myfit/domain/handlers/api_result.dart';
import 'package:myfit/infrastructure/models/data/membership.dart';

abstract class MembershipRepositoryInterface{
  Future<ApiResult<List<MemberShip>>> getMemberShipByGymId({required int gymId});
  Future<ApiResult<Map<String, dynamic>>> buyMembership({required int userId, required int membershipId});
  Future<ApiResult<List<MemberShip>>> getMemberShipByUserId({required int userId});
}