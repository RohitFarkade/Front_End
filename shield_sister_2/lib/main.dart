// import "package:firebase_core/firebase_core.dart";
// import "package:firebase_messaging/firebase_messaging.dart";
// import "package:flutter/material.dart";
// import "package:flutter_local_notifications/flutter_local_notifications.dart";
// import "package:shield_sister_2/new_pages/newhelplinepage.dart";
// import "package:shield_sister_2/pages/BottomNavigation.dart";
// import "package:shield_sister_2/pages/User_Login_Page.dart";
// import "package:shield_sister_2/pages/User_Registration_Page.dart";
// import 'firebase_options.dart';
// import 'package:shield_sister_2/pages/SOS_Homescreen.dart';
// // import 'new_pages/UselessMyMap.dart';
//
//
// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
// void initializeLocalNotifications() {
//   var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   var initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );
//
//   flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   // await dotenv.load(fileName: "email.env");
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//
//   // Initialize Firebase Cloud Messaging
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//   // Request notification permissions (for iOS)
//   NotificationSettings settings = await messaging.requestPermission(
//     alert: true,
//     announcement: false,
//     badge: true,
//     carPlay: false,
//     criticalAlert: false,
//     provisional: false,
//     sound: true,
//   );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     print('User granted permission');
//   } else {
//     print('User declined or has not accepted permission');
//   }
//
//   // initializeLocalNotifications();
//
//   runApp(MaterialApp(
//     debugShowMaterialGrid: false,
//     home: UserLoginPage(),
//     color: Colors.amber,
//     debugShowCheckedModeBanner: false,
//     routes: {
//       "/bot": (context) => const BottomNavigationPage(),
//       // "/int": (context) =>  OnboardingScreen(),
//       "/reg": (context) => const UserRegistrationPage(),
//       "/log": (context) => const UserLoginPage(),
//       "/home": (context) => const SOSHomescreen(),
//       // "/redirect": (context) => RedirectPage(),
//       "/helpline": (context) => const newHelplinePage(),
//
//     },
//   ));
// }
//
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:shield_sister_2/new_pages/newhelplinepage.dart";
import "package:shield_sister_2/pages/BottomNavigation.dart";
import "package:shield_sister_2/pages/User_Login_Page.dart";
import "package:shield_sister_2/pages/User_Registration_Page.dart";
import 'firebase_options.dart';
import 'package:shield_sister_2/pages/SOS_Homescreen.dart';
import 'services/audio_player.dart';
import 'package:flutter/foundation.dart'; // For debugPrint

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (if still needed)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(SOSApp());
}

class SOSApp extends StatelessWidget {
  static const platform = MethodChannel('com.shield_sister.shield_sister_2/sms');

  SOSApp() {
    _setupMethodChannel();
  }

  void _setupMethodChannel() {
    platform.setMethodCallHandler((call) async {
      debugPrint("MethodChannel call received: ${call.method}");
      if (call.method == "triggerBuzzer") {
        debugPrint("Triggering buzzer");
        await AudioPlayerUtil.playBuzzer();
        debugPrint("Buzzer played");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      home: UserLoginPage(),
      color: Colors.amber,
      debugShowCheckedModeBanner: false,
      routes: {
        "/bot": (context) => const BottomNavigationPage(),
        "/reg": (context) => const UserRegistrationPage(),
        "/log": (context) => const UserLoginPage(),
        "/home": (context) => const SOSHomescreen(),
        "/helpline": (context) => const newHelplinePage(),
      },
    );
  }
}
