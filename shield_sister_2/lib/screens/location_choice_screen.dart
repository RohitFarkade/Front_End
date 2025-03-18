import 'package:flutter/material.dart';
import '../services/share_location_screen.dart';
import '../services/view_location_screen.dart';

class LocationChoiceScreen extends StatefulWidget {
  @override
  _LocationChoiceScreenState createState() => _LocationChoiceScreenState();
}

class _LocationChoiceScreenState extends State<LocationChoiceScreen> {
  final TextEditingController _trackingIdController = TextEditingController();

  void openViewScreen() {
    if (_trackingIdController.text.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ViewLocationScreen(trackingId: _trackingIdController.text),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Live Location Options")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShareLocationScreen()),
                  );
                },
                child: Text("Share My Location"),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _trackingIdController,
                decoration: InputDecoration(
                  labelText: "Enter Tracking ID",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: openViewScreen,
                child: Text("Track Location"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
