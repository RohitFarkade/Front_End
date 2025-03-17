import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:shield_sister_2/new_pages/newhelplinepage.dart';
import 'package:shield_sister_2/pages/BottomNavigation.dart';
import 'package:shield_sister_2/pages/User_Login_Page.dart';
import 'package:shield_sister_2/pages/User_Registration_Page.dart';
import 'package:shield_sister_2/pages/SOS_Homescreen.dart';
import 'new_pages/MyMap.dart';
import 'firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeLocalNotifications() async {
  var initializationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('User granted permission for notifications');
  } else {
    debugPrint('User declined or has not accepted notifications');
  }

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize local notifications
  await initializeLocalNotifications();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690), // Base size for scaling
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.amber),
          home: const UserLoginPage(),
          routes: {
            "/bot": (context) => const BottomNavigationPage(),
            "/reg": (context) => const UserRegistrationPage(),
            "/log": (context) => const UserLoginPage(),
            "/home": (context) => const SOSHomescreen(),
            "/redirect": (context) => RedirectPage(),
            "/helpline": (context) => const newHelplinePage(),
          },
        );
      },
    );
  }
}

