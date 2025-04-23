/*
How to use:

final LangService langService = LangService();

class _PageState extends State<Page> {
  @override
  void initState() {
    super.initState();
    langService.addListener(_refresh);
      
  }

  @override
  void dispose() {
    langService.removeListener(_refresh);
    super.dispose();
    
  }

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
  
  }
}

langService.setVal('zh')

langService.getVal('welcome')
*/

import 'package:flutter/material.dart';

class AppLanguages {
  static const Map<String, Map<String, String>> translations = {
    'en': {
      'hello': 'Hello',
      'welcome': 'Welcome',
    },
    'zh': {
      'hello': '你好',
      'welcome': '欢迎',
    },
    'yue': {
      'hello': '你好呀',
      'welcome': '歡迎你',
    }
  };
}

class LangService with ChangeNotifier {

  // Singleton instance
  static final LangService _instance = LangService._internal();
  factory LangService() => _instance;
  LangService._internal();

  String _currentLang = 'en';
  String get currentLang => _currentLang;

  void setVal(String lang) {
    _currentLang = lang;
    notifyListeners(); // Notify all listeners to refresh
  }

  String getVal(String key) {
    return AppLanguages.translations[_currentLang]?[key] ?? key;
  }
}
