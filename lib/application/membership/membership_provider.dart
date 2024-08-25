
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfit/application/membership/membership_notifier.dart';
import 'package:myfit/application/membership/membership_state.dart';
import 'package:myfit/domain/di/dependency_manager.dart';

final membershipProvider =
    StateNotifierProvider<MembershipNotifier, MembershipState>(
  (ref) => MembershipNotifier(membershipRepo),
);
