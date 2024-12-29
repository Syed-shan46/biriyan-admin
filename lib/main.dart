import 'package:biriyan/firebase_options.dart';
import 'package:biriyan/navigation_menu.dart';
import 'package:biriyan/utils/themes/main_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

@pragma('vm:entry-point')
Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);
  await dotenv.load(fileName: ".env");
  print(dotenv.env); // To check the loaded values
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // void initState() {
  //   AwesomeNotifications().setListeners(
  //       onActionReceivedMethod: NotificationController.onActionReceivedMethod,
  //       onNotificationCreatedMethod:
  //           NotificationController.onNotificationCreatedMethod,
  //       onNotificationDisplayedMethod:
  //           NotificationController.onNotificationDisplayedMethod,
  //       onDismissActionReceivedMethod:
  //           NotificationController.onDismissActionReceivedMethod);
  //   super.initState();
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: mainTheme,
      home: NavigationMenu(),
    );
  }
}
