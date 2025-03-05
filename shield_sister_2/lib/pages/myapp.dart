import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import '/pages/BottomNavigation.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double help_text_size = 20;
  String font_name = "Nunito";
  int _currentIndex = 0;
  void _showMessage(BuildContext context) {
    const snackBar = SnackBar(
      content: Text('The S.O.S Alert is sent'),
      duration: Duration(seconds: 2), // Message will disappear after 3 seconds
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header Section
            Text(
              "Emergency Help Needed?",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),

            // Subheader
            Text(
              "Alert family members, close ones, and police\nwith live location tracking",
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 25),

            // S.O.S Button
            GestureDetector(
              onTap: () {
                // Add functionality for the SOS button here
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.redAccent,
                  child: Text(
                    "S.O.S",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildActionButton(Icons.shield, "Police"),
                buildActionButton(Icons.phone, "Home"),
                buildActionButton(Icons.support, "Helpline"),
                buildActionButton(Icons.notifications_active, "Alert"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget to Build Action Buttons
  Widget buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Icon(
            icon,
            size: 30,
            color: Color(0xFF55CF9F),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
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

            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }