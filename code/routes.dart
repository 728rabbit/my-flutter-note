import 'package:flutter/material.dart';
import 'package:devapp/pages/home.dart';
import 'package:devapp/pages/login.dart';
import 'package:devapp/pages/profile.dart';

class AppRoute {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';

  static final Map<String, WidgetBuilder> staticRoutes = {
    login: (context) => LoginScreen(),
    home: (context) => HomePage(),
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
          builder: (context) => HomePage(),
        );
    }
  }
}