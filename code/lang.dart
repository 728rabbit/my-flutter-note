/*
How to use:

final AppLang defaultLang = AppLang();

@override
void initState() {
  super.initState();
  defaultLang.addListener(_onLangChanged);
}

@override
void dispose() {
  defaultLang.removeListener(_onLangChanged);
  super.dispose();
}

void _onLangChanged() {
  setState(() => {});
}

AppLang.setVal('zh')

AppLang.getVal('welcome')
*/

import 'package:flutter/material.dart';

class SupportLangs {
  static const Map<String, Map<String, String>> translations = {
    'en': {
      'hello': 'Hello',
      'welcome': 'Welcome',
      'btn_ok': 'OK',
      'btn_yes': 'Yes',
      'btn_no': 'No'

    },
    'zh-hant': {
      'hello': '你好呀',
      'welcome': '歡迎你',
      'btn_ok': '確定',
      'btn_yes': '是',
      'btn_no': '否'
    }
  };
}

class AppLang with ChangeNotifier {

  // Singleton instance
  static final AppLang _instance = AppLang._internal();
  factory AppLang() => _instance;
  AppLang._internal();

  String _currentLang = 'en';
  String get currentLang => _currentLang;

  String getCode() {
    return _currentLang;
  }

  void setVal(String lang) {
    if (lang == _currentLang) return;
    if (!SupportLangs.translations.containsKey(lang)) return;
    _currentLang = lang;
    // Notify all listeners to refresh
    notifyListeners();
  }

  String getVal(String key) {
    return SupportLangs.translations[_currentLang]?[key] ?? key;
  }
}
