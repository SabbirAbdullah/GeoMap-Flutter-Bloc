import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:latlong2/latlong.dart';

import 'package:dio/dio.dart';

import 'package:geolocator/geolocator.dart';

// class MapPage extends StatefulWidget {
//   @override
//   State<MapPage> createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   final LatLng initialLocation = LatLng(23.8103, 90.4125); // Dhaka
//   final MapController _mapController = MapController();
//   double _currentZoom = 15;
//   LatLng _currentCenter = LatLng(23.8103, 90.4125);
//   bool _showLoading = false;
//   LatLng? _userLocation;
//   LatLng? _startPoint;
//   LatLng? _endPoint;
//   LatLng? _mapCenter;
//   String? _startAddress = '';
//   String? _endAddress = '';
//   List<LatLng> _routePoints = [];
//   double? _routeDistance;
//   double? _routeDuration;
//
//   void _zoom(double delta) async {
//     setState(() => _showLoading = true);
//     final newZoom = (_currentZoom + delta).clamp(2.0, 18.0);
//     await _mapController.move(_currentCenter, newZoom);
//     setState(() {
//       _currentZoom = newZoom;
//       _showLoading = false;
//     });
//   }
//
//   Future<void> _goToCurrentLocation() async {
//     setState(() => _showLoading = true);
//
//     final hasPermission = await _handlePermission();
//     if (!hasPermission) {
//       setState(() => _showLoading = false);
//       return;
//     }
//
//     try {
//       final position = await Geolocator.getCurrentPosition();
//       final currentLatLng = LatLng(position.latitude, position.longitude);
//
//       await _mapController.move(currentLatLng, 17.0);
//
//       _startPoint = currentLatLng;
//       _startAddress = await fetchAddressFromCoordinates(
//         currentLatLng.latitude,
//         currentLatLng.longitude,
//       );
//
//       _mapCenter = currentLatLng;
//
//       setState(() {
//         _userLocation = currentLatLng;
//         _currentCenter = currentLatLng;
//         _currentZoom = 17.0;
//         _showLoading = false;
//       });
//
//       // Trigger route fetch
//       await _updateDestinationAndRoute();
//     } catch (e) {
//       print("Location fetch error: $e");
//       setState(() => _showLoading = false);
//     }
//   }
//   Future<void> _updateDestinationAndRoute() async {
//     if (_startPoint == null || _mapCenter == null) return;
//
//     _endPoint = _mapCenter;
//     _endAddress = await fetchAddressFromCoordinates(
//       _mapCenter!.latitude,
//       _mapCenter!.longitude,
//     );
//
//     await _getRoutePolyline();
//   }
//
//
//   Future<bool> _handlePermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) return false;
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
//   }
//
//   Future<String?> fetchAddressFromCoordinates(double latitude, double longitude) async {
//     const apiKey = 'bkoi_d7a69b824f19702b0cde9da7857ca50772b987382d9e7d7ba8f4b8b38de6e196';
//     final url =
//         'https://barikoi.xyz/v2/api/search/reverse/geocode?api_key=$apiKey'
//         '&longitude=$longitude&latitude=$latitude'
//         '&district=true&post_code=true&country=true&sub_district=true'
//         '&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true&bangla=true';
//
//     try {
//       final response = await Dio().get(url);
//       if (response.statusCode == 200) {
//         final data = response.data;
//         return data['place']['address'] ?? 'No address found';
//       } else {
//         return 'Failed to fetch address';
//       }
//     } catch (e) {
//       print("Reverse Geocoding Error: $e");
//       return 'Error fetching address';
//     }
//   }
//   //
//   // Future<void> _getRoutePolyline() async {
//   //   if (_startPoint == null || _endPoint == null) return;
//   //
//   //   // Simulated route: straight line
//   //   _routePoints = [
//   //     _startPoint!,
//   //     LatLng(
//   //       (_startPoint!.latitude + _endPoint!.latitude) / 2,
//   //       (_startPoint!.longitude + _endPoint!.longitude) / 2,
//   //     ),
//   //     _endPoint!
//   //   ];
//   // }
//
//
//   Future<void> _getRoutePolyline() async {
//     if (_startPoint == null || _endPoint == null) return;
//     const apiKey = 'bkoi_d7a69b824f19702b0cde9da7857ca50772b987382d9e7d7ba8f4b8b38de6e196';
//
//     final url =
//         'https://barikoi.xyz/v2/api/route/'
//         '${_startPoint!.longitude},${_startPoint!.latitude};'
//         '${_endPoint!.longitude},${_endPoint!.latitude}'
//         '?api_key=$apiKey&geometries=polyline';
//
//     try {
//       final response = await Dio().get(url);
//
//       if (response.statusCode == 200) {
//         final data = response.data;
//
//         final route = data['routes'][0];
//         final geometry = route['geometry'];
//         final distance = route['distance']; // meters
//         final duration = route['duration']; // seconds
//
//         // Decode the encoded polyline
//         final polylinePoints = PolylinePoints();
//         final List<PointLatLng> result = polylinePoints.decodePolyline(geometry);
//
//         _routePoints = result
//             .map((e) => LatLng(e.latitude, e.longitude))
//             .toList();
//         _routeDistance = distance;
//         _routeDuration = duration;
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("ETA: ${(duration / 60).toStringAsFixed(0)} min, Distance: ${(distance / 1000).toStringAsFixed(2)} km"),
//           ),
//         );
//       } else {
//         print("Route API error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("Failed to fetch route: $e");
//     }
//
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: _userLocation!,
//               initialZoom: _currentZoom,
//               maxZoom: 20,
//               minZoom: 1,
//               cameraConstraint: CameraConstraint.contain(
//                 bounds: LatLngBounds(
//                   LatLng(20.743, 88.007),
//                   LatLng(26.634, 92.674),
//                 ),
//               ),
//               // onMapEvent: (event) {
//               //   setState(() {
//               //     _currentZoom = _mapController.camera.zoom;
//               //     _currentCenter = _mapController.camera.center;
//               //   });
//               // },
//               onMapEvent: (event) async {
//                 _mapCenter = _mapController.camera.center;
//                 _currentCenter = _mapCenter!;
//                 await _updateDestinationAndRoute(); // recalculate route when user pans
//                 setState(() {});
//               },
//               onTap: (tapPosition, point) async {
//                 if (_startPoint == null) {
//                   _startPoint = point;
//                   _startAddress = await fetchAddressFromCoordinates(point.latitude, point.longitude);
//                 } else if (_endPoint == null) {
//                   _endPoint = point;
//                   _endAddress = await fetchAddressFromCoordinates(point.latitude, point.longitude);
//                   await _getRoutePolyline();
//                 } else {
//                   // Reset and set new start
//                   _startPoint = point;
//                   _endPoint = null;
//                   _routePoints = [];
//                   _startAddress = await fetchAddressFromCoordinates(point.latitude, point.longitude);
//                   _endAddress = '';
//                 }
//                 setState(() {});
//               },
//             ),
//
//
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://api.maptiler.com/maps/streets-v2-dark/{z}/{x}/{y}.png?key=Ww3yske7vq3DqRmswF8Z',
//                 userAgentPackageName: 'com.your.app',
//               ),
//               if (_startPoint != null)
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       width: 40,
//                       height: 40,
//                       point: _startPoint!,
//                       child: Icon(Icons.flag, color: Colors.green),
//                     )
//                   ],
//                 ),
//               if (_endPoint != null)
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       width: 40,
//                       height: 40,
//                       point: _endPoint!,
//                       child: Icon(Icons.place, color: Colors.red),
//                     )
//                   ],
//                 ),
//
//               if (_routePoints.isNotEmpty)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _routePoints,
//                       strokeWidth: 4.0,
//                       color: Colors.blue,
//                     )
//                   ],
//                 ),
//               if (_userLocation != null)
//                 CircleLayer(
//                   circles: [
//                     CircleMarker(
//                       point: _userLocation!,
//                       radius: 10,
//                       color: Colors.blue.withOpacity(0.7),
//                       borderStrokeWidth: 2,
//                       useRadiusInMeter: false,
//                       borderColor: Colors.white,
//                     ),
//                   ],
//                 ),
//
//               if (_startPoint != null)
//                 MarkerLayer(
//                   markers: [
//                     Marker(
//                       width: 40,
//                       height: 40,
//                       point: _startPoint!,
//                       child: Icon(Icons.flag, color: Colors.green),
//                     )
//                   ],
//                 ),
//
//               if (_routePoints.isNotEmpty)
//                 PolylineLayer(
//                   polylines: [
//                     Polyline(
//                       points: _routePoints,
//                       strokeWidth: 4.0,
//                       color: Colors.blue,
//                     )
//                   ],
//                 ),
//
//
//             ],
//           ),
//           Center(
//             child: IgnorePointer(
//               child: Icon(Icons.location_pin, size: 48, color: Colors.red),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     hintText: "Start Point",
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(Icons.flag, color: Colors.green),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   controller: TextEditingController(text: _startAddress ?? ''),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     hintText: "Destination",
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(Icons.location_pin, color: Colors.red),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   controller: TextEditingController(text: _endAddress ?? ''),
//                 ),
//               ],
//             ),
//           ),
//
//           // Spinner
//           if (_showLoading)
//             Center(child: CircularProgressIndicator()),
//
//           // Address Fields
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     hintText: "Start Point",
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(Icons.flag, color: Colors.green),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   controller: TextEditingController(text: _startAddress ?? ''),
//                 ),
//                 SizedBox(height: 10),
//                 TextFormField(
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     hintText: "End Point",
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(Icons.place, color: Colors.red),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   controller: TextEditingController(text: _endAddress ?? ''),
//                 ),
//               ],
//             ),
//           ),
//
//           // Zoom buttons
//           Positioned(
//             bottom: 100,
//             right: 16,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   backgroundColor: Colors.white,
//                   heroTag: "zoomIn",
//                   mini: true,
//                   child: Icon(Icons.add, color: Colors.teal),
//                   onPressed: () => _zoom(1),
//                 ),
//                 SizedBox(height: 8),
//                 FloatingActionButton(
//                   backgroundColor: Colors.white,
//                   heroTag: "zoomOut",
//                   mini: true,
//                   child: Icon(Icons.remove, color: Colors.teal),
//                   onPressed: () => _zoom(-1),
//                 ),
//               ],
//             ),
//           ),
//
//           // My location button
//           Positioned(
//             bottom: 30,
//             right: 16,
//             child: FloatingActionButton(
//               heroTag: "myLocation",
//               mini: false,
//               backgroundColor: Colors.white,
//               child: Icon(Icons.my_location, color: Colors.teal),
//               onPressed: _goToCurrentLocation,
//             ),
//           ),
//
//           if (_routeDistance != null && _routeDuration != null)
//             Positioned(
//               top: 160,
//               left: 16,
//               right: 16,
//               child: Card(
//                 elevation: 6,
//                 color: Colors.white.withOpacity(0.95),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.route, color: Colors.teal),
//                           SizedBox(width: 8),
//                           Text(
//                             "${(_routeDistance! / 1000).toStringAsFixed(2)} km",
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Icon(Icons.timer, color: Colors.orange),
//                           SizedBox(width: 8),
//                           Text(
//                             "${(_routeDuration! / 60).toStringAsFixed(0)} min",
//                             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  LatLng? _userLocation;
  LatLng? _startPoint;
  LatLng? _endPoint;
  LatLng? _mapCenter;
  List<LatLng> _routePoints = [];
  double? _routeDistance;
  double? _routeDuration;
  double _currentZoom = 15;
  bool _showLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() => _showLoading = true);

    final hasPermission = await _handlePermission();
    if (!hasPermission) {
      setState(() => _showLoading = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      final currentLatLng = LatLng(position.latitude, position.longitude);

      _startPoint = currentLatLng;
      _startController.text = await fetchAddress(currentLatLng) ?? '';

      setState(() {
        _userLocation = currentLatLng;
        _mapCenter = currentLatLng;
        _currentZoom = 17.0;
        _showLoading = false;
      });
    } catch (e) {
      print("Location fetch error: $e");
      setState(() => _showLoading = false);
    }
  }

  Future<bool> _handlePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) return false;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  Future<String?> fetchAddress(LatLng latLng) async {
    final url =
        'https://nominatim.openstreetmap.org/reverse?format=jsonv2&lat=${latLng.latitude}&lon=${latLng.longitude}';

    try {
      final response = await Dio()
          .get(url, options: Options(headers: {'User-Agent': 'FlutterMapApp'}));
      if (response.statusCode == 200) {
        return response.data['display_name'];
      }
    } catch (e) {
      print("Geocode error: $e");
    }
    return null;
  }

  Future<void> _updateDestinationAndRoute() async {
    if (_startPoint == null || _mapCenter == null) return;

    _endPoint = _mapCenter;
    _endController.text = await fetchAddress(_endPoint!) ?? '';
    await _getRoutePolyline();
  }

  Future<void> _getRoutePolyline() async {
    if (_startPoint == null || _endPoint == null) return;

    final url =
        'https://router.project-osrm.org/route/v1/driving/${_startPoint!.longitude},${_startPoint!.latitude};${_endPoint!.longitude},${_endPoint!.latitude}?overview=full&geometries=polyline';

    try {
      final response = await Dio().get(url);
      if (response.statusCode == 200) {
        final route = response.data['routes'][0];
        final points = PolylinePoints().decodePolyline(route['geometry']);

        setState(() {
          _routePoints =
              points.map((e) => LatLng(e.latitude, e.longitude)).toList();
          _routeDistance = route['distance'];
          _routeDuration = route['duration'];
        });
      }
    } catch (e) {
      print("Route error: $e");
    }
  }

  void _zoom(double delta) async {
    final newZoom = (_currentZoom + delta).clamp(2.0, 18.0);
    await _mapController.move(_mapCenter ?? _startPoint!, newZoom);
    setState(() => _currentZoom = newZoom);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userLocation == null
          ? Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _userLocation!,
                    initialZoom: _currentZoom,
                    onMapEvent: (event) {
                      _mapCenter = _mapController.camera.center;
                      _debounce?.cancel();
                      _debounce = Timer(Duration(milliseconds: 500), () {
                        _updateDestinationAndRoute();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.your.app',
                    ),
                    if (_startPoint != null)
                      MarkerLayer(markers: [
                        Marker(
                            point: _startPoint!,
                            width: 40,
                            height: 40,
                            child: Icon(Icons.circle, color: Colors.blue))
                      ]),
                    if (_routePoints.isNotEmpty)
                      PolylineLayer(polylines: [
                        Polyline(
                            points: _routePoints,
                            strokeWidth: 4,
                            color: Colors.blue)
                      ]),
                  ],
                ),
                Center(
                    child: IgnorePointer(
                        child: Icon(Icons.location_pin,
                            size: 48, color: Colors.red))),
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      TextField(
                        controller: _startController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'My Current Location',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.my_location, color: Colors.green),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _endController,
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'Destination',
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon:
                              Icon(Icons.location_pin, color: Colors.red),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_routeDistance != null && _routeDuration != null)
                  Positioned(
                    top: 160,
                    left: 16,
                    right: 16,
                    child: Card(
                      elevation: 6,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Icon(Icons.route, color: Colors.teal),
                              SizedBox(width: 8),
                              Text(
                                  "${(_routeDistance! / 1000).toStringAsFixed(2)} km")
                            ]),
                            Row(children: [
                              Icon(Icons.timer, color: Colors.orange),
                              SizedBox(width: 8),
                              Text(
                                  "${(_routeDuration! / 60).toStringAsFixed(0)} min")
                            ]),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

// class MapPage extends StatefulWidget {
//   @override
//   State<MapPage> createState() => _MapPageState();
// }
//
// class _MapPageState extends State<MapPage> {
//   final MapController _mapController = MapController();
//   final _startController = TextEditingController();
//   final _endController = TextEditingController();
//
//   LatLng? _userLocation;
//   LatLng? _startPoint;
//   LatLng? _endPoint;
//   LatLng? _mapCenter;
//   List<LatLng> _routePoints = [];
//   double? _routeDistance;
//   double? _routeDuration;
//   double _currentZoom = 15;
//   bool _showLoading = false;
//   Timer? _debounce;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeLocation();
//   }
//
//   Future<void> _initializeLocation() async {
//     setState(() => _showLoading = true);
//
//     final hasPermission = await _handlePermission();
//     if (!hasPermission) {
//       setState(() => _showLoading = false);
//       return;
//     }
//
//     try {
//       final position = await Geolocator.getCurrentPosition();
//       final currentLatLng = LatLng(position.latitude, position.longitude);
//
//       _startPoint = currentLatLng;
//       _startController.text = await fetchAddress(currentLatLng) ?? '';
//
//       setState(() {
//         _userLocation = currentLatLng;
//         _mapCenter = currentLatLng;
//         _currentZoom = 17.0;
//         _showLoading = false;
//       });
//     } catch (e) {
//       print("Location fetch error: $e");
//       setState(() => _showLoading = false);
//     }
//   }
//
//   Future<bool> _handlePermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.deniedForever) return false;
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//     return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
//   }
//
//   Future<String?> fetchAddress(LatLng latLng) async {
//     const apiKey = 'your_api_key_here';
//     final url = 'https://barikoi.xyz/v2/api/search/reverse/geocode?api_key=$apiKey&longitude=${latLng.longitude}&latitude=${latLng.latitude}&address=true';
//
//     try {
//       final response = await Dio().get(url);
//       if (response.statusCode == 200) {
//         return response.data['place']['address'];
//       }
//     } catch (e) {
//       print("Geocode error: $e");
//     }
//     return null;
//   }
//
//   Future<void> _updateDestinationAndRoute() async {
//     if (_startPoint == null || _mapCenter == null) return;
//
//     _endPoint = _mapCenter;
//     _endController.text = await fetchAddress(_endPoint!) ?? '';
//     await _getRoutePolyline();
//   }
//
//   Future<void> _getRoutePolyline() async {
//     if (_startPoint == null || _endPoint == null) return;
//     const apiKey = 'your_api_key_here';
//     final url =
//         'https://barikoi.xyz/v2/api/route/${_startPoint!.longitude},${_startPoint!.latitude};${_endPoint!.longitude},${_endPoint!.latitude}?api_key=$apiKey&geometries=polyline';
//
//     try {
//       final response = await Dio().get(url);
//       if (response.statusCode == 200) {
//         final route = response.data['routes'][0];
//         final points = PolylinePoints().decodePolyline(route['geometry']);
//
//         setState(() {
//           _routePoints = points.map((e) => LatLng(e.latitude, e.longitude)).toList();
//           _routeDistance = route['distance'];
//           _routeDuration = route['duration'];
//         });
//       }
//     } catch (e) {
//       print("Route error: $e");
//     }
//   }
//
//   void _zoom(double delta) async {
//     final newZoom = (_currentZoom + delta).clamp(2.0, 18.0);
//     await _mapController.move(_mapCenter ?? _startPoint!, newZoom);
//     setState(() => _currentZoom = newZoom);
//   }
//
//   @override
//   void dispose() {
//     _debounce?.cancel();
//     _startController.dispose();
//     _endController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _userLocation == null
//           ? Center(child: CircularProgressIndicator())
//           : Stack(
//         children: [
//           FlutterMap(
//             mapController: _mapController,
//             options: MapOptions(
//               initialCenter: _userLocation!,
//               initialZoom: _currentZoom,
//               onMapEvent: (event) {
//                 _mapCenter = _mapController.camera.center;
//                 _debounce?.cancel();
//                 _debounce = Timer(Duration(milliseconds: 500), () {
//                   _updateDestinationAndRoute();
//                 });
//               },
//             ),
//             children: [
//               TileLayer(
//                 urlTemplate: 'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=Ww3yske7vq3DqRmswF8Z',
//                 userAgentPackageName: 'com.your.app',
//               ),
//               if (_startPoint != null)
//                 MarkerLayer(markers: [
//                   Marker(
//                     point: _startPoint!,
//                     width: 40,
//                     height: 40,
//                     child: Icon(Icons.flag, color: Colors.green),
//                   )
//                 ]),
//               if (_routePoints.isNotEmpty)
//                 PolylineLayer(polylines: [
//                   Polyline(points: _routePoints, strokeWidth: 4, color: Colors.blue)
//                 ]),
//             ],
//           ),
//           Center(child: IgnorePointer(child: Icon(Icons.location_pin, size: 48, color: Colors.red))),
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _startController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     hintText: 'Start Point',
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(Icons.flag, color: Colors.green),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 TextField(
//                   controller: _endController,
//                   readOnly: true,
//                   decoration: InputDecoration(
//                     hintText: 'Destination',
//                     filled: true,
//                     fillColor: Colors.white,
//                     prefixIcon: Icon(Icons.location_pin, color: Colors.red),
//                     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (_routeDistance != null && _routeDuration != null)
//             Positioned(
//               top: 160,
//               left: 16,
//               right: 16,
//               child: Card(
//                 elevation: 6,
//                 color: Colors.white,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(children: [
//                         Icon(Icons.route, color: Colors.teal),
//                         SizedBox(width: 8),
//                         Text("${(_routeDistance! / 1000).toStringAsFixed(2)} km")
//                       ]),
//                       Row(children: [
//                         Icon(Icons.timer, color: Colors.orange),
//                         SizedBox(width: 8),
//                         Text("${(_routeDuration! / 60).toStringAsFixed(0)} min")
//                       ]),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
