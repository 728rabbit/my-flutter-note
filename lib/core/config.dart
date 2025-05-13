import 'package:flutter/material.dart';

class AppConfig {
  static const String apiBaseUrl = 'http://192.168.0.221:8000/myprojects/mylib';
  
  static const Map<String, Color> listColors = {
    'background': Color(0xFFFFF8F2),
    'primary': Color(0xFF8E4585),
    'darkgreen': Color(0xFF2489A2),
    'green': Color(0xFF9DD864),
    'darkred': Color(0xFFB3261E),
    'red': Color(0xFFF93A37),
    'darkyellow': Color(0xFFFDA525),
    'yellow': Color(0xFFFFD700),
    'darkblue': Color(0xFF325096),
    'blue': Color(0xFF2175C3),
    'darkgray': Color(0xFF6A6A6A),
    'gray': Color(0xFFDDDDDD),
    'white': Colors.white,
    'black': Color(0xFF222222),
    'lightgreen': Color(0xFFE1F7D2),
    'lightred': Color(0xFFFFB6C1),
    'lightyellow': Color(0xFFFFFEC5),
    'lightblue': Color(0xFF90D5FF),
    'lightgray': Color(0xFFF6F6F6),
    'lightpink': Color(0xFFFFECEC)
  };

  static Color hexCode(String name) {
    return listColors[name] ?? Colors.black; // 找不到就給黑色
  }
}