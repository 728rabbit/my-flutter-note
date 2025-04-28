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
      'btn_no': 'No',
      'required_all_error': 'Please fill out all required fields correctly.',
      'required_error': 'Please fill out this field correctly.',
      'password_error': 'Password must contain at least 6 characters, including upper/lowercase and numbers (e.g. Abc123).',
      'email_error': 'Invalid email address format.',
      'number_error': 'Invalid number format.',
      'date_error': 'Invalid date format.',
      'time_error': 'Invalid time format.',
      'ge0_error': 'Value must be greater than or equal to 0.',
      'gt0_error': 'Value must be greater than 0.'

    },
    'zh-hant': {
      'hello': '你好呀',
      'welcome': '歡迎你',
      'btn_ok': '確定',
      'btn_yes': '是',
      'btn_no': '否',
      'required_all_error': '請正確填寫所有必須欄位。',
      'required_error': '請正確填寫此欄位。',
      'password_error': '密碼必須至少包含6個字符，包括大寫/小寫和數字(例如Abc123)。',
      'email_error': '無效的郵件地址格式。',
      'number_error': '無效的數字格式。',
      'date_error': '無效的日期格式。',
      'time_error': '無效的時間格式。',
      'ge0_error': '數值必須大於或等於 0。',
      'gt0_error': '數值必須大於 0。'
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
