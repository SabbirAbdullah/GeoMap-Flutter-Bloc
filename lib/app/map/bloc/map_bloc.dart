import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapState(markers: [])) {
    on<MapInitialized>((event, emit) {
      emit(MapState(markers: []));
    });

    on<MarkerAdded>((event, emit) {
      final updatedMarkers = List<LatLng>.from(state.markers)
        ..add(LatLng(event.lat, event.lng));
      emit(state.copyWith(markers: updatedMarkers));
    });
  }
}
