


import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

class Landmark {
  final String name;
  final String description;
  final LatLng location;

  const Landmark({
    required this.name,
    required this.description,
    required this.location,
  });
}

Future<List<Landmark>> fetchLandmarks(LatLng location, String type) async {
  const apiKey = "AIzaSyAnqy5abBsQQIXXzhj8VwiW5zXM3if2zaY"; // Replace with your actual Google Places API key
  final url = Uri.parse("https://places.googleapis.com/v1/places:searchNearby");

  final body = jsonEncode({
    "includedTypes": [type],
    "locationRestriction": {
      "circle": {"center": {"latitude": location.latitude, "longitude": location.longitude}, "radius": 1000}
    }
  });

  try {
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "X-Goog-Api-Key": apiKey,
        "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.location"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return (data['places'] as List<dynamic>? ?? []).map<Landmark>((result) {
        return Landmark(
          name: result['displayName']['text'] as String? ?? 'Unknown',
          description: result['formattedAddress'] as String? ?? 'No description available',
          location: LatLng(
            result['location']['latitude'] as double? ?? 0.0,
            result['location']['longitude'] as double? ?? 0.0,
          ),
        );
      }).toList();
    }
    throw Exception('Failed to fetch landmarks: ${response.reasonPhrase}');
  } catch (error) {
    debugPrint('Error fetching landmarks: $error');
    return const [];
  }
}

class MapDisplayPage extends StatefulWidget {
  const MapDisplayPage({super.key});

  @override
  State<MapDisplayPage> createState() => _MapDisplayPageState();
}

class _MapDisplayPageState extends State<MapDisplayPage> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(20.5937, 78.9629);
  LatLng _lastCheckedPosition = const LatLng(20.5937, 78.9629);
  final Set<Circle> _circles = {};
  final List<Landmark> _safeZones = [];
  final List<LatLng> _unsafeZoneCenters = [];
  String _zoneStatus = 'Neutral Zone';
  Color _zoneColor = Colors.grey;
  Set<Polyline> _polylines = {};
  Landmark? _selectedSafeZone;
  bool _isLoading = false;
  bool _showZoneStatus = false;
  Timer? _statusTimer;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _initializeMap() async {
    await _updateUserLocation();
  }

  Future<void> _updateUserLocation() async {
    if (await Permission.location.request().isGranted) {
      setState(() => _isLoading = true);
      try {
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        final newPosition = LatLng(position.latitude, position.longitude);
        if (_calculateDistance(_lastCheckedPosition, newPosition) > 500 || _circles.isEmpty) {
          _lastCheckedPosition = _currentPosition;
          _currentPosition = newPosition;
          await _updateZones(position);
          _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        }
      } catch (e) {
        _showError('Failed to get location: $e');
      } finally {
        setState(() => _isLoading = false);
      }
    } else {
      _showError('Location permission denied');
    }
  }

  Future<void> _updateZones(Position position) async {
    final userLocation = LatLng(position.latitude, position.longitude);
    try {
      final futures = [
        fetchLandmarks(userLocation, 'hospital'),
        fetchLandmarks(userLocation, 'police'),
        fetchLandmarks(userLocation, 'liquor_store'),
        fetchLandmarks(userLocation, 'bar'),
      ];
      final results = await Future.wait(futures);

      final hospitals = results[0];
      final policeStations = results[1];
      final liquorStores = results[2];
      final bars = results[3];

      setState(() {
        _circles.clear();
        _safeZones.clear();
        _unsafeZoneCenters.clear();

        _addCircles(hospitals, Colors.green, _safeZones);
        _addCircles(policeStations, Colors.green, _safeZones);
        _addCircles(liquorStores, Colors.red, null, _unsafeZoneCenters);
        _addCircles(bars, Colors.red, null, _unsafeZoneCenters);

        _checkUserZone(userLocation);
      });
    } catch (e) {
      _showError('Error updating zones: $e');
    }
  }

  void _addCircles(List<Landmark> landmarks, Color color, List<Landmark>? zones, [List<LatLng>? centers]) {
    for (var landmark in landmarks) {
      _circles.add(Circle(
        circleId: CircleId(landmark.name),
        center: landmark.location,
        radius: 50,
        fillColor: color.withOpacity(0.5),
        strokeColor: color,
        strokeWidth: 2,
      ));
      zones?.add(landmark);
      centers?.add(landmark.location);
    }
  }

  void _checkUserZone(LatLng userLocation) {
    final inSafeZone = _safeZones.any((zone) => _calculateDistance(userLocation, zone.location) <= 50);
    final inUnsafeZone = _unsafeZoneCenters.any((center) => _calculateDistance(userLocation, center) <= 50);

    setState(() {
      if (inSafeZone && inUnsafeZone) {
        _zoneStatus = 'Mixed Zone';
        _zoneColor = Colors.yellow;
      } else if (inSafeZone) {
        _zoneStatus = 'Safe Zone';
        _zoneColor = Colors.green;
      } else if (inUnsafeZone) {
        _zoneStatus = 'Unsafe Zone';
        _zoneColor = Colors.red;
      } else {
        _zoneStatus = 'Neutral Zone';
        _zoneColor = Colors.grey;
      }
    });
  }

  double _calculateDistance(LatLng loc1, LatLng loc2) {
    const double earthRadius = 6371000;
    final dLat = _degreesToRadians(loc2.latitude - loc1.latitude);
    final dLon = _degreesToRadians(loc2.longitude - loc1.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(loc1.latitude)) * cos(_degreesToRadians(loc2.latitude)) * sin(dLon / 2) * sin(dLon / 2);
    return earthRadius * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _degreesToRadians(double degrees) => degrees * (pi / 180);

  Future<List<LatLng>> _getDirections(LatLng origin, LatLng destination) async {
    const apiKey = "AIzaSyAnqy5abBsQQIXXzhj8VwiW5zXM3if2zaY"; // Replace with your actual Google Routes API key
    final url = Uri.parse("https://routes.googleapis.com/directions/v2:computeRoutes");

    final body = jsonEncode({
      "origin": {"location": {"latLng": {"latitude": origin.latitude, "longitude": origin.longitude}}},
      "destination": {"location": {"latLng": {"latitude": destination.latitude, "longitude": destination.longitude}}},
      "travelMode": "DRIVE",
      "routingPreference": "TRAFFIC_AWARE"
    });

    try {
      setState(() => _isLoading = true);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-Goog-Api-Key": apiKey,
          "X-Goog-FieldMask": "routes.polyline"
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final routes = data['routes'] as List<dynamic>? ?? [];
        if (routes.isNotEmpty) {
          return _decodePolyline(routes[0]['polyline']['encodedPolyline']);
        }
        throw 'No route found';
      }
      throw 'Failed to load directions: ${response.reasonPhrase}';
    } catch (error) {
      _showError('Error fetching directions: $error');
      return const [];
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    final points = <LatLng>[];
    int index = 0, lat = 0, lng = 0;

    while (index < polyline.length) {
      int byte, shift = 0, result = 0;

      // Decode latitude
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20 && index < polyline.length);
      lat += (result & 1) == 1 ? ~(result >> 1) : (result >> 1);

      shift = 0;
      result = 0;

      // Decode longitude
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20 && index < polyline.length);
      lng += (result & 1) == 1 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.poppins()),
        backgroundColor: Colors.black87,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.grey.shade100],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(target: _currentPosition, zoom: 14.0),
                  circles: _circles,
                  polylines: _polylines,
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                  onCameraIdle: _updateUserLocation,
                  padding: const EdgeInsets.only(bottom: 200),
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.arrow_back, color: Colors.black),
                      //   onPressed: () => Navigator.pop(context),
                      // ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Safety Map",
                          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildButton(
                            icon: Icons.security,
                            text: "Check Zone",
                            onPressed: () {
                              _showZoneStatus = true;
                              _checkUserZone(_currentPosition);
                              _statusTimer?.cancel();
                              _statusTimer = Timer(const Duration(seconds: 3), () => setState(() => _showZoneStatus = false));
                            },
                          ),
                          _buildButton(
                            icon: Icons.directions,
                            text: "Get Directions",
                            onPressed: _selectedSafeZone == null
                                ? null
                                : () async {
                              final route = await _getDirections(_currentPosition, _selectedSafeZone!.location);
                              setState(() {
                                _polylines = {
                                  Polyline(polylineId: const PolylineId('route'), points: route, color: Colors.black, width: 5)
                                };
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DropdownButton<Landmark>(
                        isExpanded: true,
                        hint: Text("Select Safe Zone", style: GoogleFonts.poppins(color: Colors.grey.shade700)),
                        value: _selectedSafeZone,
                        onChanged: _isLoading ? null : (value) => setState(() => _selectedSafeZone = value),
                        items: _safeZones.isEmpty
                            ? [
                          DropdownMenuItem<Landmark>(
                            enabled: false,
                            child: Text("No Safe Zones", style: GoogleFonts.poppins(color: Colors.grey)),
                          )
                        ]
                            : _safeZones.map((zone) {
                          return DropdownMenuItem<Landmark>(
                            value: zone,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    zone.name,
                                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  '${(_calculateDistance(zone.location, _currentPosition) / 1000).toStringAsFixed(2)} km',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      if (_showZoneStatus)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(color: _zoneColor, shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _zoneStatus,
                                style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required IconData icon, required String text, required VoidCallback? onPressed}) {
    return ElevatedButton(
      onPressed: _isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        elevation: 8,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: MapDisplayPage()));
}