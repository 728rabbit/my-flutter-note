/*
How to use:

final AppLang v = AppLang();

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

AppLang().setVal('zh')

AppLang().getVal('welcome')
*/

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportLangs {
  static const Map<String, Map<String, String>> translations = {
    'en': {
      'hello': 'Hello',
      'welcome': 'Welcome',

      'user_id': 'User ID',
      'password': 'Password',
      'gender': 'Gender',
      'gender_male': 'M',
      'gender_female': 'F',
      'birth_date': 'Birth Date',
      'birth_time': 'Birth Time',
      'email': 'Email',
      'telephone': 'Telephone',
      'fax': 'Fax',
      'district': 'District',
      'district_1': 'Hong Kong',
      'district_2': 'Kowloon',
      'district_3': 'New Territories',
      'address': 'Address',
      'remark': 'Remark',
      'attachment': 'Attachment',

      'btn_ok': 'OK',
      'btn_yes': 'Yes',
      'btn_no': 'No',
      'btn_login': 'Login',
      'btn_submit': 'Submit',

      'please_select': 'Please Select',
      'agree_tnc': 'I have read and agreed to the relevant terms and conditions.',

      'error_required_all': 'Please fill out all required fields correctly.',
      'error_required': 'Please fill out this field correctly.',
      'error_password_format': 'Password must contain at least 6 characters, including upper/lowercase and numbers (e.g. Abc123).',
      'error_email_format': 'Invalid email address format.',
      'error_number_format': 'Invalid number format.',
      'error_date_format': 'Invalid date format.',
      'error_time_format': 'Invalid time format.',
      'error_ge0_format': 'Value must be greater than or equal to 0.',
      'error_gt0_format': 'Value must be greater than 0.',

      'error_login_not_match': 'The user id and password do not match.',
      'error_select_option': 'Please select one of the options.',
    },
    'zh-hant': {
      'hello': '你好',
      'welcome': '歡迎',

      'user_id': '帳戶ID',
      'password': '密碼',
      'gender': '性別',
      'gender_male': '男',
      'gender_female': '女',
      'birth_date': '出生日期',
      'birth_time': '出生時間',
      'email': '電郵',
      'telephone': '電話',
      'fax': '傳真',
      'district': '地區',
      'district_1': '香港島',
      'district_2': '九龍',
      'district_3': '新界',
      'address': '地址',
      'remark': '備注',
      'attachment': '附件',

      'btn_ok': '確定',
      'btn_yes': '是',
      'btn_no': '否',
      'btn_login': '登入',
      'btn_submit': '提交',

      'please_select': '請選擇',
      'agree_tnc': '本人已閱讀及同意相關條款及細則。',

      'error_required_all': '請正確填寫所有必須欄位。',
      'error_required': '請正確填寫此欄位。',
      'error_password_format': '密碼必須至少包含6個字符，包括大寫/小寫和數字(例如Abc123)。',
      'error_email_format': '無效的郵件地址格式。',
      'error_number_format': '無效的數字格式。',
      'error_date_format': '無效的日期格式。',
      'error_time_format': '無效的時間格式。',
      'error_ge0_format': '數值必須大於或等於 0。',
      'error_gt0_format': '數值必須大於 0。',

      'error_login_not_match': '帳戶ID和密碼不符。',
      'error_select_option': '請從選項中選擇一個。',
    }
  };
}

class AppLang with ChangeNotifier {
  String _currentLang = 'en';
  String get currentLang => _currentLang;

  // Singleton instance
  static final AppLang _instance = AppLang._internal();
  factory AppLang() => _instance;
  AppLang._internal() {
    // Initialize language from local storage
    _initLang();
  }

  Future<void> _initLang() async {
    // Try to get saved language from local storage
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var savedLang = prefs.get('defaultAppLang');
    if (savedLang is String && SupportLangs.translations.containsKey(savedLang)) {
      // Change language
      _currentLang = savedLang;

      // Notify all listeners to refresh
      notifyListeners();
    }
  }

  String getCode() {
    return _currentLang;
  }

  Future<void> setVal(String lang) async {
    if (lang == _currentLang) return;
    if (!SupportLangs.translations.containsKey(lang)) return;

    // Save to local storage
    _currentLang = lang;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultAppLang', lang);

    // Notify all listeners to refresh
    notifyListeners();
  }

  String getVal(String key) {
    return SupportLangs.translations[_currentLang]?[key] ?? key;
  }
}
