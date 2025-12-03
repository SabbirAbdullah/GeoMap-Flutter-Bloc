abstract class MapEvent {}

class MapInitialized extends MapEvent {}

class MarkerAdded extends MapEvent {
  final double lat;
  final double lng;

  MarkerAdded({required this.lat, required this.lng});
}
