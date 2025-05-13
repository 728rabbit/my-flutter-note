import 'dart:io';
import 'package:devapp/core/base.dart';
import 'package:devapp/core/helper.dart';
import 'package:devapp/pages/home.dart';
import 'package:devapp/pages/login.dart';
import 'package:devapp/routes.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  authedUser = await getLocalData('authedUser');

  initPushNotifincation();
  runApp(MyApp()); 
}

void initPushNotifincation() {
  try {
    if (Platform.isAndroid || Platform.isIOS) {
      /*
      // Enable verbose logging for debugging (remove in production)
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
      // Initialize with your OneSignal App ID
      OneSignal.initialize("4f85b70a-7c35-4937-b8ce-68526d0f4944");
      // Use this method to prompt for push notifications.
      // We recommend removing this method after testing and instead use In-App Messages to prompt for notification permission.
      OneSignal.Notifications.requestPermission(false);*/
    }
  }
  catch(e) {
    print(e);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    //print(authedUser);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //initialRoute: ((authedUser?.isNotEmpty == true) ?AppRoute.home:AppRoute.login),
      home: ((authedUser?.isNotEmpty == true) ?HomePage():LoginScreen()),
      routes: AppRoute.staticRoutes,
      onGenerateRoute: AppRoute.dynamicRoutes,
    );
  }
}