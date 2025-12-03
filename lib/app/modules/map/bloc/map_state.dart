import 'package:latlong2/latlong.dart';

class MapState {
  final List<LatLng> markers;

  MapState({required this.markers});

  MapState copyWith({List<LatLng>? markers}) {
    return MapState(markers: markers ?? this.markers);
  }
}
