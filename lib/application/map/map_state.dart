import 'package:activity/infrastructure/models/data/each_markers_models.dart';
import 'package:activity/infrastructure/models/data/gym_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

part 'map_state.freezed.dart';

@freezed
class MapState with _$MapState {
  const factory MapState({
    @Default(false) bool isloading,
    @Default(null) Position? userPosition,
    @Default([]) List<EachMarkersModel> listOfMarkers,
    @Default([]) List<GymData> listOfActivities,
    @Default(null) EachMarkersModel? activeMarker,
  }) = _MapState;
  const MapState._();
}