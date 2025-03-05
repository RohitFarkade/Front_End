import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:mailer/mailer.dart";
import "package:mailer/smtp_server/hotmail.dart";
import 'package:location/location.dart' as loc;
import 'package:mailer/src/entities/message.dart' as msg;
import 'dart:math';

var random_uniqueID = Random();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  LatLng user_location = const LatLng(20.59, 78.96);
  late loc.Location location = loc.Location();


  FirebaseMessaging messaging = FirebaseMessaging.instance;

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
    } catch (e) {
      print(e);
    }
  }

  Future<void> setupFCM() async {
    NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    }
  }


  void _showMessage(BuildContext context) {
    final snackBar = const SnackBar(
      content: Text('The S.O.S Alert is sent'),
      duration: Duration(seconds: 2), // Message will disappear after 3 seconds
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> sendSOSAlert() async {

    CollectionReference sosAlerts = FirebaseFirestore.instance.collection('soscoll1');
    // final loc.LocationData _locationResult = await location.getLocation();
    DateTime t1 = DateTime.now();
    await sosAlerts.add({
      'user_ID': '$random_uniqueID',
      'timestamp': FieldValue.serverTimestamp(),
      // 'latitude': _locationResult.latitude,
      // 'longitude': _locationResult.longitude,
      'status': 'active',
    });
    _showMessage(context);

  }

  @override
  Widget build(BuildContext context) {

    Widget iconButtonsForList(Icon icon1) => IconButton(
        onPressed: (){},
        color: Colors.black54,
        iconSize: 32,
        icon: icon1
    );

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                'Need Help? ',
                style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement SOS functionality
              },
              style: ElevatedButton.styleFrom(
                iconColor: Colors.red,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(0),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: ElevatedButton(onPressed: () => sendSOSAlert(),
                          style: ElevatedButton.styleFrom(
                            shape: CircleBorder(
                              side: BorderSide(color: Color(0xFFADDDC7), width: 8), // Add border color and width
                            ),
                            padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                            // backgroundColor: Colors.white,
                          ),
                          child: const Text(
                            "S.O.S",
                            style: TextStyle(fontSize: 50.0, color: Colors.red),
                          ),
                        )
                      ),],
                  ),

                ],),
            ),

            const SizedBox(
              height: 20,
            ),

            SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  iconButtonsForList(Icon(CupertinoIcons.person)),
                   iconButtonsForList(Icon(CupertinoIcons.helm)),
                  iconButtonsForList(Icon(CupertinoIcons.power)),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }


  Widget _buildActionCard(BuildContext context, String title, String subtitle) {
    return Card(elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (subtitle.isNotEmpty)
            Text(subtitle, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement action for this button
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }
}