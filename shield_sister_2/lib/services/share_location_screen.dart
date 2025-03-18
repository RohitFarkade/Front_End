import 'package:flutter/material.dart';
import '../services/location_service.dart';
// import '../services/share_service.dart';
// import 'package:share_plus/share_plus.dart';

class ShareLocationScreen extends StatefulWidget {
  @override
  _ShareLocationScreenState createState() => _ShareLocationScreenState();
}

class _ShareLocationScreenState extends State<ShareLocationScreen> {
  final LocationService _locationService = LocationService();
  // final ShareService _shareService = ShareService();
  String? trackingId;

  void startSharing() async {
    String id = await _locationService.startSharing();
    setState(() {
      trackingId = id;
    });
  }

  void stopSharing() async {
    if (trackingId != null) {
      await _locationService.stopSharing(trackingId!);
      setState(() {
        trackingId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Share Live Location")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (trackingId != null) ...[
              Text("Your Tracking ID: $trackingId", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () => {},//_shareService.shareTrackingId(trackingId!),
                // onPressed: () => Share.share(trackingId!),
                child: Text("Share Tracking Link"),
              ),
              ElevatedButton(
                onPressed: stopSharing,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Stop Sharing"),
              ),
            ] else
              ElevatedButton(
                onPressed: startSharing,
                child: Text("Start Sharing Location"),
              ),
          ],
        ),
      ),
    );
  }
}
