import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Verification function
bool isValidValue(dynamic value) {
  if(value != null) {
    return value.toString().trim().isNotEmpty;
  }
  return false;
}

bool isValidEmail(dynamic value) {
  if(isValidValue(value)) {
    value = value.toString().trim();
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(value);
  }
  return false;
}

bool isValidPassword(dynamic value) {
  if(isValidValue(value)) {
    value = value.toString().trim();
    final pwdRegExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$');
    return pwdRegExp.hasMatch(value);
  }
  return false;
}

bool isValidNumber(dynamic number, {bool digitalMode = false}) {
  final reg = digitalMode 
      ? RegExp(r'^[0-9]+$') 
      : RegExp(r'(^((-)?[1-9]{1}\d{0,2}|0\.|0$))(((\d)+)?)(((\.)(\d+))?)$');
  if (isValidValue(number)) {
    number = number.toString().trim();
    return reg.hasMatch(number);
  }
  return false;
}

bool isValueMatch(String value1, String value2, {bool sensitive = false}) {
  if (isValidValue(value1) && isValidValue(value2)) {
    final trimmedValue1 = value1.trim();
    final trimmedValue2 = value2.trim();
    return sensitive
        ? trimmedValue1 == trimmedValue2
        : trimmedValue1.toLowerCase() == trimmedValue2.toLowerCase();
  }
  return false;
}

/* 
LocalData:

await setLocalData('user', {'name': 'John', 'age': 30});
await setLocalData('token', 'abc123');
*/
Future<void> setLocalData(String name, dynamic userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (userData == null) {
    await prefs.remove(name);
  } else if (userData is Map<String, dynamic>) {
    String userJson = jsonEncode(userData);
    await prefs.setString(name, userJson);
  } else {
    await prefs.setString(name, userData);
  }
}

Future<dynamic> getLocalData(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var value = prefs.get(name);
  if(value != null) {
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } 
      catch (e) {
        return value;
      }
    } 
  }
  return null;
}

/* 
API Request: 

Format: function_name () async { .... }

1. Normal post:
final response = await requestAPI(
  'https://yourapi.com/login',
  body: {
    'username': 'testuser',
    'password': '123456',
  },
);


2. Submit form:
final response = await requestAPI(
  'https://yourapi.com/login',
  body: {
    'username': 'testuser',
    'password': '123456',
  },
  headers: {
    'Content-Type': 'application/x-www-form-urlencoded',
  },
);

3. Upload files:
File imageFile = File('/path/to/your/image.jpg');
final response = await requestAPI(
  'https://yourapi.com/upload',
  body: {
    'userId': '12345',
    'description': 'My photo',
  },
  files: {
    'photo': imageFile,
  },
);

4. Others:
final response = await requestAPI(
  'https://yourapi.com/raw-text',
  body: 'Hello World!',
  headers: {
    'Content-Type': 'text/plain',
  },
);
*/
Future<dynamic> requestAPI(
  String url, {
  dynamic body,
  Map<String, File>? files,
  Map<String, String>? headers,
}) async {
  try {
    headers = headers ?? {'Content-Type': 'application/json'};
    http.Response result;

    if (files != null && files.isNotEmpty) {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(headers);

      if (body is Map && body.isNotEmpty) {
        body.forEach((key, value) {
          request.fields[key] = value.toString();
        });
      }

      // only works in native (mobile/desktop) environments
      try {
        for (var entry in files.entries) {
          final fieldName = '${entry.key.replaceAll(RegExp(r'_\d+$'), '')}[]';
          final file = await http.MultipartFile.fromPath(fieldName, entry.value.path);
          request.files.add(file);
        }
      }
      catch(e) {
        throw Exception('Add files failed: $e');
      }

      var streamedResponse = await request.send();
      result = await http.Response.fromStream(streamedResponse);
    } else {
      dynamic requestBody;
      String contentType = headers['Content-Type'] ?? 'application/json';

      if (contentType.contains('application/json')) {
        requestBody = jsonEncode(body ?? {});
      } else if (contentType.contains('application/x-www-form-urlencoded')) {
        if (body is Map && body.isNotEmpty) {
          requestBody = body.entries
              .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent('${e.value}')}')
              .join('&');
        } else {
          requestBody = '';
        }
      } else {
        requestBody = body;
      }

      result = await http.post(Uri.parse(url), headers: headers, body: requestBody);
    }

    if (result.statusCode >= 200 && result.statusCode < 300) {
      try {
        return jsonDecode(result.body);
      } catch (e) {
        return result.body;
      }
    } else {
      throw Exception('HTTP ${result.statusCode}: ${result.body}');
    }
  } catch (e) {
    throw Exception('POST request failed: $e');
  }
}