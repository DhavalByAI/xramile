import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xramile/models/notification_data_model.dart';
import 'modules/bottom bar/bottom_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_messeging_service.dart';
import 'package:flutter_foreground_service/flutter_foreground_service.dart';

List<NotificationData> listOfNotifications =
    []; //as of now i have created global variable, but we can create it private as per neccesory or we can store in local database like hive
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAYUka0UUlEjzXWv6ui4IAqm8WdPwSlSB0",
          appId: "1:1050638386380:android:db94bd5b0acc4a8d216e69",
          messagingSenderId: "1050638386380", 
          projectId: "xramile-task"));
  FirebaseMessagingService firebaseMessagingService =
      FirebaseMessagingService();
  await firebaseMessagingService.init();
  ForegroundService().start();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    ForegroundService().stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xramile task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomBar(),
    );
  }
}
