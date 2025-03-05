// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';

// class NewMapPage extends StatefulWidget {
//   const NewMapPage({super.key});

//   @override
//   State<NewMapPage> createState() => _NewMapPageState();
// }

// class _NewMapPageState extends State<NewMapPage> {

//   late GoogleMapController mapController;
//   LatLng _initialPosition = const LatLng(20.5937, 78.9629);
//   String mapTheme = "";

//   @override
//   void initState() {
//     super.initState();
//     _getUserLocation();
//     mapTheme = '''
//       [
//   {
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#212121"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.icon",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "elementType": "labels.text.stroke",
//     "stylers": [
//       {
//         "color": "#212121"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative.country",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#9e9e9e"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative.land_parcel",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "featureType": "administrative.locality",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#bdbdbd"
//       }
//     ]
//   },
//   {
//     "featureType": "poi",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.business",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#181818"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "labels.text",
//     "stylers": [
//       {
//         "visibility": "off"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "featureType": "poi.park",
//     "elementType": "labels.text.stroke",
//     "stylers": [
//       {
//         "color": "#1b1b1b"
//       }
//     ]
//   },
//   {
//     "featureType": "road",
//     "elementType": "geometry.fill",
//     "stylers": [
//       {
//         "color": "#2c2c2c"
//       }
//     ]
//   },
//   {
//     "featureType": "road",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#8a8a8a"
//       }
//     ]
//   },
//   {
//     "featureType": "road.arterial",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#373737"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#3c3c3c"
//       }
//     ]
//   },
//   {
//     "featureType": "road.highway.controlled_access",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#4e4e4e"
//       }
//     ]
//   },
//   {
//     "featureType": "road.local",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#616161"
//       }
//     ]
//   },
//   {
//     "featureType": "transit",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#757575"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "geometry",
//     "stylers": [
//       {
//         "color": "#000000"
//       }
//     ]
//   },
//   {
//     "featureType": "water",
//     "elementType": "labels.text.fill",
//     "stylers": [
//       {
//         "color": "#3d3d3d"
//       }
//     ]
//   }
// ]
//     ''';
//   }

//   Future<void> _getUserLocation() async {
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _initialPosition = LatLng(position.latitude, position.longitude);
//       });
//     }
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     mapController = controller;
//     controller.setMapStyle(mapTheme);
//   }


//   List<dynamic> listSafeZones = [
//     ["SafeZone 1", "1 km"],
//     ["SafeZone 2", "0.8 km"],
//     ["SafeZone 3", "1.5 km"],
//     ["SafeZone 4", "0.9 km"],
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(top: 30),
//           child: Column(
//             children: [
//               // Search Bar
//               const SizedBox(height: 10),
//               Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextField(
//                   decoration: InputDecoration(
//                     border: InputBorder.none,
//                     prefixIcon: Icon(
//                       Icons.search,
//                       color: Colors.black87,
//                     ),
//                     hintText: "Search location",
//                     hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
//                   ),
//                 ),
//               ),

//               // Map Container
//               Container(
//                 width: double.maxFinite,
//                 height: 400,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: Colors.greenAccent,
//                 ),
//                 child: GoogleMap(
//                   onMapCreated: _onMapCreated,
//                   initialCameraPosition: CameraPosition(
//                     target: _initialPosition,
//                     zoom: 14.0,
//                   ),
//                   myLocationEnabled: true,
//                   myLocationButtonEnabled: true,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               // Icon Buttons Row
//               SizedBox(
//                 height: 70,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     _iconButtons(Icon(Icons.home_work_outlined), "Home"),
//                     _iconButtons(Icon(Icons.edit), "Edit"),
//                     _iconButtons(Icon(Icons.track_changes), "SafeZone"),
//                     _iconButtons(Icon(Icons.report), "Report"),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Safe Zones Section
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                       color: Colors.black87, // Border color
//                       width: 3, // Border width
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Center(
//                         child: Text(
//                           "Nearest SafeZones",
//                           style: TextStyle(color: Colors.black, fontSize: 24),
//                         ),
//                       ),
//                       Divider(
//                         color: Colors.black,
//                         thickness: 2,
//                       ),
//                       // Safe Zones List
//                       SizedBox(
//                         height: 150, // Set fixed height to avoid unbounded error
//                         child: ListView.builder(
//                           padding: EdgeInsets.zero,
//                           itemCount: listSafeZones.length,
//                           itemBuilder: (context, index) {
//                             return GestureDetector(
//                               onTap: () => showDialog(
//                                 context: context,
//                                 builder: (context) => AlertDialog(
//                                   title: Text(
//                                     listSafeZones[index][0],
//                                     style: TextStyle(fontSize: 28),
//                                   ),
//                                   actions: [
//                                     TextButton(
//                                       onPressed: () => Navigator.pop(context),
//                                       child: Text("Close"),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               child: Card(
//                                 margin: const EdgeInsets.symmetric(
//                                   horizontal: 20,
//                                   vertical: 6,
//                                 ),
//                                 elevation: 4,
//                                 child: Padding(
//                                   padding:
//                                   const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         listSafeZones[index][0],
//                                         style: TextStyle(
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(listSafeZones[index][1], style: TextStyle(fontSize: 20),)
//                                     ],
//                                   )
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget _iconButtons(Icon icon1, String iconText) => Material(
//   elevation: 4,
//   borderRadius: BorderRadius.circular(12),
//   shadowColor: Colors.grey.withOpacity(0.5),
//   child: Container(
//     width: 80,
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(12),
//       color: Colors.white,
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           onPressed: () {},
//           icon: icon1,
//           iconSize: 24,
//         ),
//         Text(iconText),
//       ],
//     ),
//   ),
// );


import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Landmark {
  String name;
  String description;
  LatLng location;

  Landmark({
    required this.name,
    required this.description,
    required this.location,
  });
}

Future<List<Landmark>> fetchLandmarks(LatLng location, String type) async {
  const apiKey = "AIzaSyBOQVoXhw3B9sGlfpiOJNzqYng59AYRtUM"; // Replace with your API key

  final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
      'location=${location.latitude},${location.longitude}'
      '&radius=1000' // Set radius to 1 km
      '&type=$type' // Fetch specified type
      '&key=$apiKey');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List<dynamic>;

      return results.map<Landmark>((result) {
        final name = result['name'] as String? ?? 'Unknown';
        final description = result['vicinity'] as String? ?? 'No description available';
        final location = LatLng(
          result['geometry']['location']['lat'] as double? ?? 0.0,
          result['geometry']['location']['lng'] as double? ?? 0.0,
        );

        return Landmark(
          name: name,
          description: description,
          location: location,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch landmarks: ${response.reasonPhrase}');
    }
  } catch (error) {
    print('Error fetching landmarks: $error');
    return []; // Return an empty list in case of an error
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  LatLng _initialPosition = const LatLng(20.5937, 78.9629); // Default to India
  final Set<Circle> _circles = {};
  final List<Landmark> safeZones = []; // List of safe zones (hospitals and police stations)
  final List<LatLng> unsafeZoneCenters = []; // List of unsafe zone centers
  String _zoneStatus = ''; // To display the zone status
  Set<Polyline> _polylines = {}; // To show directions as polylines
  bool _showZoneStatus = false;  // To control the display of zone status
  Landmark? _selectedSafeZone;  // To store the selected safe zone

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _updateZones(position); // Update zones based on user location
      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _updateZones(Position position) async {
    LatLng userLocation = LatLng(position.latitude, position.longitude);
    try {
      // Fetch hospitals and police stations
      List<Landmark> hospitals = await fetchLandmarks(userLocation, 'hospital');
      List<Landmark> policeStations = await fetchLandmarks(userLocation, 'police');

      print('Fetched hospitals: ${hospitals.length}');
      print('Fetched police stations: ${policeStations.length}');

      _circles.clear(); // Clear previous circles
      safeZones.clear();
      unsafeZoneCenters.clear();

      // Add circles for hospitals and police stations (safe zones)
      for (var hospital in hospitals) {
        _circles.add(Circle(
          circleId: CircleId(hospital.name), // Unique ID for the circle
          center: hospital.location,
          radius: 10, // radius in meters
          fillColor: Colors.green.withOpacity(0.5),
          strokeColor: Colors.green,
          strokeWidth: 2,
        ));
        safeZones.add(hospital); // Add to safe zones
      }

      for (var policeStation in policeStations) {
        _circles.add(Circle(
          circleId: CircleId(policeStation.name), // Unique ID for the circle
          center: policeStation.location,
          radius: 10, // radius in meters
          fillColor: Colors.green.withOpacity(0.5),
          strokeColor: Colors.green,
          strokeWidth: 2,
        ));
        safeZones.add(policeStation); // Add to safe zones
      }

      // Fetch liquor stores and bars (unsafe zones)
      List<Landmark> liquorStores = await fetchLandmarks(userLocation, 'liquor_store');
      List<Landmark> bars = await fetchLandmarks(userLocation, 'bar');

      print('Fetched liquor stores: ${liquorStores.length}');
      print('Fetched bars: ${bars.length}');

      // Add circles for liquor stores and bars (unsafe zones)
      for (var liquorStore in liquorStores) {
        _circles.add(Circle(
          circleId: CircleId(liquorStore.name), // Unique ID for the circle
          center: liquorStore.location,
          radius: 10, // radius in meters
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ));
        unsafeZoneCenters.add(liquorStore.location); // Add to unsafe zones
      }

      for (var bar in bars) {
        _circles.add(Circle(
          circleId: CircleId(bar.name), // Unique ID for the circle
          center: bar.location,
          radius: 10, // radius in meters
          fillColor: Colors.red.withOpacity(0.5),
          strokeColor: Colors.red,
          strokeWidth: 2,
        ));
        unsafeZoneCenters.add(bar.location); // Add to unsafe zones
      }

      _checkUserZone(userLocation); // Check if user is in a safe or unsafe zone
      setState(() {}); // Update the UI
    } catch (e) {
      print('Error updating zones: $e');
    }
  }

  void _checkUserZone(LatLng userLocation) {
    bool inSafeZone = safeZones.any((zone) {
      return _calculateDistance(userLocation, zone.location) <= 10; // 50 meters
    });

    bool inUnsafeZone = unsafeZoneCenters.any((center) {
      return _calculateDistance(userLocation, center) <= 10; // 50 meters
    });

    setState(() {
      if (inSafeZone && inUnsafeZone) {
        // If the user is in both zones
        _zoneStatus = 'You are in both a safe zone and an unsafe zone (Yellow Zone)';
      } else if (inSafeZone) {
        // If the user is only in a safe zone
        _zoneStatus = 'You are in a safe zone (Green Zone)';
      } else if (inUnsafeZone) {
        // If the user is only in an unsafe zone
        _zoneStatus = 'You are in an unsafe zone (Red Zone)';
      } else {
        // If the user is in neither zone
        _zoneStatus = 'You are in a neutral zone';
      }
    });
  }

  double _calculateDistance(LatLng loc1, LatLng loc2) {
    const double earthRadius = 6371000; // meters
    double dLat = _degreesToRadians(loc2.latitude - loc1.latitude);
    double dLon = _degreesToRadians(loc2.longitude - loc1.longitude);
    double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(loc1.latitude)) *
            cos(_degreesToRadians(loc2.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c; // Distance in meters
  }

  double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=${origin.latitude},${origin.longitude}'
      '&destination=${destination.latitude},${destination.longitude}'
      '&key=AIzaSyBOQVoXhw3B9sGlfpiOJNzqYng59AYRtUM' // Replace with your API key
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final routes = data['routes'];
      if (routes.isNotEmpty) {
        final polyline = routes[0]['overview_polyline']['points'];
        return decodePolyline(polyline);
      } else {
        throw 'No route found';
      }
    } else {
      throw 'Failed to load directions';
    }
  }

  List<LatLng> decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0;
    int len = polyline.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int result = 0;
      int shift = 0;
      int byte;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dLat = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lat += dLat;

      result = 0;
      shift = 0;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int dLng = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lng += dLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return points;
  }

  void _navigateToNearestSafeZone() async {
    if (safeZones.isNotEmpty) {
      // Find the nearest safe zone
      Landmark nearestSafeZone = safeZones.reduce((a, b) {
        double distanceA = _calculateDistance(_initialPosition, a.location);
        double distanceB = _calculateDistance(_initialPosition, b.location);
        return distanceA < distanceB ? a : b;
      });

      // Show directions to the nearest safe zone
      List<LatLng> route = await getDirections(_initialPosition, nearestSafeZone.location);
      setState(() {
        _polylines.clear();
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: route,
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) {
              mapController = controller;
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 19.0,
            ),
            circles: _circles,
            polylines: _polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            padding: const EdgeInsets.only(bottom: 150), // Leave space for bottom buttons
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16, // Position above the bottom navigation bar
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _checkUserZone(_initialPosition); // Check if the user is in a safe or unsafe zone
                          setState(() {
                            _showZoneStatus = true; // Show the zone status
                          });
                          // Hide the zone status after 3 seconds
                          Future.delayed(Duration(seconds: 3), () {
                            setState(() {
                              _showZoneStatus = false;
                            });
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Icon(
                          Icons.security,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Show directions to the selected safe zone or nearest safe zone if not selected
                          if (_selectedSafeZone != null) {
                            List<LatLng> route = await getDirections(_initialPosition, _selectedSafeZone!.location);
                            setState(() {
                              _polylines.clear();
                              _polylines.add(Polyline(
                                polylineId: PolylineId('route'),
                                points: route,
                                color: Colors.blue,
                                width: 5,
                              ));
                            });
                          } else {
                            _navigateToNearestSafeZone();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        child: const Icon(
                          Icons.directions,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Landmark>(
                          isExpanded: true,
                          hint: const Text("Select Safe Zone"),
                          value: _selectedSafeZone,
                          onChanged: (Landmark? newValue) {
                            setState(() {
                              _selectedSafeZone = newValue;
                            });
                          },
                          items: safeZones.map((Landmark zone) {
                            return DropdownMenuItem<Landmark>(
                              value: zone,
                              child: Text(zone.name),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_showZoneStatus)
            Positioned(
              left: 16,
              right: 16,
              bottom: 150, // Move it up so it's not hidden by the rectangle
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _zoneStatus,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: MapScreen(),
  ));
}