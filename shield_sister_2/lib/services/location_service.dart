import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LocationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate a random tracking ID (6-character string)
  String generateTrackingId() {
    const chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }

  // Request location permissions
  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw 'Location services are disabled';

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) throw 'Location permissions denied';
    }

    return await Geolocator.getCurrentPosition();
  }

  // Start sharing location (creates a Firestore entry)
  Future<String> startSharing() async {
    String trackingId = generateTrackingId();
    Position position = await _determinePosition();

    await _firestore.collection('live_locations').doc(trackingId).set({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return trackingId;
  }

  // Update live location periodically
  Future<void> updateLiveLocation(String trackingId) async {
    Position position = await _determinePosition();
    await _firestore.collection('live_locations').doc(trackingId).update({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Stop sharing (deletes Firestore entry)
  Future<void> stopSharing(String trackingId) async {
    await _firestore.collection('live_locations').doc(trackingId).delete();
  }
}
