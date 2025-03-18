import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewLocationScreen extends StatefulWidget {
  final String trackingId;
  ViewLocationScreen({required this.trackingId});

  @override
  _ViewLocationScreenState createState() => _ViewLocationScreenState();
}

class _ViewLocationScreenState extends State<ViewLocationScreen> {
  late GoogleMapController mapController;
  LatLng? currentLocation;

  Stream<DocumentSnapshot> getLiveLocationStream() {
    return FirebaseFirestore.instance.collection('live_locations').doc(widget.trackingId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: getLiveLocationStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text("No location data available"));
          }

          var data = snapshot.data!;
          double latitude = data['latitude'];
          double longitude = data['longitude'];
          currentLocation = LatLng(latitude, longitude);

          return GoogleMap(
            initialCameraPosition: CameraPosition(target: currentLocation!, zoom: 14),
            markers: {
              Marker(markerId: MarkerId("trackedUser"), position: currentLocation!),
            },
          );
        },
      ),
    );
  }
}
