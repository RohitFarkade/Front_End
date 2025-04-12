import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:flutter/material.dart";
import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:shield_sister_2/new_pages/newhelplinepage.dart";
import "package:shield_sister_2/pages/BottomNavigation.dart";
import "package:shield_sister_2/pages/UserForgotPage.dart";
import "package:shield_sister_2/pages/User_Login_Page.dart";
import "package:shield_sister_2/pages/User_Registration_Page.dart";
import "package:shield_sister_2/setting_pages/HelpAndSupport.dart";
import "package:shield_sister_2/setting_pages/PrivacySetting.dart";
import "package:shield_sister_2/setting_pages/SOS_Setting.dart";
import 'firebase_options.dart';
import 'package:shield_sister_2/pages/SOS_Homescreen.dart';
import 'package:permission_handler/permission_handler.dart';




FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void initializeLocalNotifications() {
  var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

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
//
//   runApp(MaterialApp(
//     debugShowMaterialGrid: false,
//     home: UserLoginPage(),
//     color: Colors.amber,
//     debugShowCheckedModeBanner: false,
//     routes: {
//       "/bot": (context) => const BottomNavigationPage(),
//       "/reg": (context) => const UserRegistrationPage(),
//       "/log": (context) => const UserLoginPage(),
//       "/home": (context) => const SOSHomescreen(),
//       "/helpline": (context) => const newHelplinePage(),
//       "/sosSettings": (context) => const SOSSettingsPage(),
//       "/privacySettings": (context) => const PrivacySettingsPage(),
//       "/help": (context) => const HelpSupportPage(),
//       "/forget": (context) => ForgotPasswordPage(),
//
//
//     },
//   ));
// }
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔔 Request SMS permission before app runs
  await _requestSmsPermission();

  // Initialize Firebase Cloud Messaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else {
    print('User declined or has not accepted permission');
  }

  runApp(MaterialApp(
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
      "/sosSettings": (context) => const SOSSettingsPage(),
      "/privacySettings": (context) => const PrivacySettingsPage(),
      "/help": (context) => const HelpSupportPage(),
      "/forget": (context) => ForgotPasswordPage(),
    },
  ));
}

Future<void> _requestSmsPermission() async {
  var status = await Permission.sms.status;
  if (!status.isGranted) {
    await Permission.sms.request();
  }
}

