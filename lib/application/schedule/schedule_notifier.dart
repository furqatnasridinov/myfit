import 'package:activity/application/schedule/schedule_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScheduleNotifier extends StateNotifier<ScheduleState>{
  ScheduleNotifier() : super(const ScheduleState());

  void openSearchBox(){
    state = state.copyWith(isSearchbarOpened: true);
  }

  void closeSearchBox(){
    state = state.copyWith(isSearchbarOpened: false);
  }

}