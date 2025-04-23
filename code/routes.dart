import 'package:demo_app/pages/home.dart';
import 'package:demo_app/pages/login.dart';
import 'package:demo_app/pages/profile.dart';
import 'package:flutter/material.dart';

class AppRoute {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> staticRoutes = {
    login: (context) => LoginScreen(),
    home: (context) => MyHomePage(title: 'Home'),
  };

  static Route<dynamic>? dynamicRoutes(RouteSettings settings) {
    switch (settings.name) {
      case profile:
        final args = settings.arguments as Map<String, dynamic>?;
        final username = args?['username'] ?? 'Guest';
        return MaterialPageRoute(
          builder: (context) => ProfilePage(title: username),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'Home'),
        );
    }
  }
}