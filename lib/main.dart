// main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/map/ view/map_view.dart';
import 'app/map/bloc/map_bloc.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => MapBloc(), // Provide MapBloc to entire app if needed
          child: MapPage(),
        ),

      ],
      child: MaterialApp(

        title: 'Flutter OSM BLoC',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.teal),
        home: Home(),
      ),
    );
  }
}



//
// const String BARIKOI_API_KEY = 'bkoi_d7a69b824f19702b0cde9da7857ca50772b987382d9e7d7ba8f4b8b38de6e196';
//
// // --- Placeholder for Barikoi Tile URL ---
// // You will get the exact tile URL format from Barikoi's documentation after signing up.
// // It typically looks like: `https://map.barikoi.com/tiles/{z}/{x}/{y}.png?key=YOUR_BARIKOI_API_KEY`
// // For this example, I'll use a generic placeholder. Replace this!
// const String BARIKOI_TILE_URL = 'https://api.maptiler.com/maps/streets-v2-dark/{z}/{x}/{y}.png?key=Ww3yske7vq3DqRmswF8Z';
// const String BARIKOI_GEOCODE_URL = 'https://barikoi.com/v1/api/search/geocode/json/?q=';
// const String BARIKOI_ROUTE_URL = 'https://barikoi.com/v1/api/directions/json?waypoints=';
//
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Barikoi Delivery App',
//       theme: ThemeData(
//         primarySwatch: Colors.teal,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: const MapScreen(),
//     );
//   }
// }
//
// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//
//   @override
//   State<MapScreen> createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   final MapController mapController = MapController();
//   LatLng? _currentLocation;
//   List<Marker> _markers = [];
//   List<Polyline> _polylines = [];
//   String _message = 'Tap on the map to add markers or get location details.';
//
//   @override
//   void initState() {
//     super.initState();
//     _requestLocationPermission();
//   }
//
//   // Request location permission from the user
//   Future<void> _requestLocationPermission() async {
//     final status = await Permission.locationWhenInUse.request();
//     if (status.isGranted) {
//       _getCurrentLocation();
//     } else if (status.isDenied) {
//       setState(() {
//         _message = 'Location permission denied. Please grant permission to see your location.';
//       });
//     } else if (status.isPermanentlyDenied) {
//       setState(() {
//         _message = 'Location permission permanently denied. Open app settings.';
//       });
//       openAppSettings();
//     }
//   }
//
//   // Get current device location
//   Future<void> _getCurrentLocation() async {
//     try {
//       // In a real app, you would use a geolocator package here.
//       // For simplicity, let's simulate a location for Dhaka, Bangladesh.
//       // Replace with actual device location retrieval.
//       final LatLng dhakaLocation = LatLng(23.777176, 90.399452); // Example: Dhaka, Bangladesh center
//       setState(() {
//         _currentLocation = dhakaLocation;
//         mapController.move(dhakaLocation, 14.0); // Move map to current location
//         _addMarker(_currentLocation!, 'My Location', Colors.blueAccent);
//         _message = 'Current location loaded. Tap on the map!';
//       });
//     } catch (e) {
//       setState(() {
//         _message = 'Failed to get current location: $e';
//       });
//     }
//   }
//
//   // Add a marker to the map
//   void _addMarker(LatLng point, String title, Color color) {
//     setState(() {
//       _markers.add(
//         Marker(
//           width: 80.0,
//           height: 80.0,
//           point: point,
//           child: Column(
//             children: [
//               Icon(Icons.location_pin, color: color, size: 40),
//               Text(title, style: TextStyle(fontSize: 10, color: Colors.black)),
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   // Perform geocoding using Barikoi API
//   Future<void> _reverseGeocode(LatLng point) async {
//     setState(() { _message = 'Getting address for ${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}...'; });
//     final url = Uri.parse('${BARIKOI_GEOCODE_URL}${point.latitude},${point.longitude}&key=$BARIKOI_API_KEY');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 200 && data['place'] != null) {
//           final address = data['place']['address'];
//           setState(() {
//             _message = 'Address: $address';
//             _addMarker(point, address, Colors.green);
//           });
//         } else {
//           setState(() { _message = 'No address found for this location.'; });
//         }
//       } else {
//         setState(() { _message = 'Failed to fetch address: ${response.statusCode}'; });
//       }
//     } catch (e) {
//       setState(() { _message = 'Error during geocoding: $e'; });
//     }
//   }
//
//   // Draw a route between two points using Barikoi API
//   Future<void> _drawRoute(LatLng start, LatLng end) async {
//     setState(() { _message = 'Calculating route...'; });
//     final waypoints = '${start.latitude},${start.longitude};${end.latitude},${end.longitude}';
//     final url = Uri.parse('${BARIKOI_ROUTE_URL}$waypoints&key=$BARIKOI_API_KEY');
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data['status'] == 200 && data['routes'] != null && data['routes'].isNotEmpty) {
//           final routeCoordinates = data['routes'][0]['geometry']['coordinates'];
//           final List<LatLng> routePoints = [];
//           for (var coord in routeCoordinates) {
//             routePoints.add(LatLng(coord[1], coord[0])); // Barikoi uses [lon, lat]
//           }
//
//           setState(() {
//             _polylines.clear();
//             _polylines.add(
//               Polyline(
//                 points: routePoints,
//                 color: Colors.purple,
//                 strokeWidth: 5.0,
//               ),
//             );
//             _message = 'Route drawn successfully!';
//           });
//         } else {
//           setState(() { _message = 'No route found.'; });
//         }
//       } else {
//         setState(() { _message = 'Failed to fetch route: ${response.statusCode}'; });
//       }
//     } catch (e) {
//       setState(() { _message = 'Error during routing: $e'; });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Barikoi Maps (Flutter)'),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: Stack(
//         children: [
//           FlutterMap(
//             mapController: mapController,
//             options: MapOptions(
//               initialCenter: _currentLocation ?? LatLng(23.777176, 90.399452), // Default to Dhaka
//               initialZoom: 12.0,
//               minZoom: 4.0,
//               maxZoom: 19.0,
//               // Handle tap events to add markers or trigger geocoding
//               onTap: (tapPosition, point) {
//                 // Clear previous markers and polylines if re-tapping
//                 setState(() {
//                   _markers.clear();
//                   _polylines.clear();
//                 });
//                 _reverseGeocode(point); // Get address for tapped location
//               },
//             ),
//             children: [
//               // Barikoi Tile Layer
//               TileLayer(
//                 urlTemplate: BARIKOI_TILE_URL,
//                 // You might need to set a custom user agent or other options
//                 // based on Barikoi's documentation for commercial use.
//                 userAgentPackageName: 'com.example.my_delivery_app', // Replace with your package name
//               ),
//               // Display markers
//               MarkerLayer(markers: _markers),
//               // Display polylines (routes)
//               PolylineLayer(polylines: _polylines),
//             ],
//           ),
//           // Floating action buttons for interaction
//           Positioned(
//             bottom: 16,
//             right: 16,
//             child: Column(
//               children: [
//                 FloatingActionButton(
//                   heroTag: 'currentLocationBtn',
//                   onPressed: _getCurrentLocation,
//                   mini: true,
//                   backgroundColor: Colors.white,
//                   child: const Icon(Icons.my_location, color: Colors.teal),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: 'routeBtn',
//                   onPressed: () {
//                     // Example: Draw a route between two hardcoded points (Dhaka to another point)
//                     // In a real app, these would come from user input or delivery data
//                     if (_currentLocation != null) {
//                       _drawRoute(_currentLocation!, LatLng(23.7947, 90.3540)); // Example: Mirpur, Dhaka
//                     } else {
//                       setState(() {
//                         _message = 'Cannot draw route, current location not available.';
//                       });
//                     }
//                   },
//                   mini: true,
//                   backgroundColor: Colors.white,
//                   child: const Icon(Icons.alt_route, color: Colors.teal),
//                 ),
//                 const SizedBox(height: 10),
//                 FloatingActionButton(
//                   heroTag: 'clearBtn',
//                   onPressed: () {
//                     setState(() {
//                       _markers.clear();
//                       _polylines.clear();
//                       _message = 'Map cleared. Tap to add markers!';
//                     });
//                   },
//                   mini: true,
//                   backgroundColor: Colors.white,
//                   child: const Icon(Icons.clear_all, color: Colors.teal),
//                 ),
//               ],
//             ),
//           ),
//           // Message overlay
//           Positioned(
//             top: 10,
//             left: 10,
//             right: 10,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.black54,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 _message,
//                 style: const TextStyle(color: Colors.white, fontSize: 14),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }