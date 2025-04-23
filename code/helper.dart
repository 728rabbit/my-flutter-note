import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

// Verification function
bool isValidValue(String txt) {
  return txt.trim().isEmpty;
}

bool isValidPassword(String password) {
  if(isValidValue(password)) {
    password = password.trim();
    final pwdRegExp = RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$');
    return pwdRegExp.hasMatch(password);
  }
  return false;
}

bool isValidEmail(String email) {
  if(isValidValue(email)) {
    email = email.trim();
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }
  return false;
}


// Session
Future<void> setSession(String name, Map<String, dynamic>? userData) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (userData == null) {
    await prefs.remove(name);
  }
  else {
    String userJson = jsonEncode(userData);
    await prefs.setString(name, userJson);
  }
}

Future<Map<String, dynamic>?> getSession(String name) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var value = prefs.get(name);

  if (value is String) {
    try {
      return jsonDecode(value) as Map<String, dynamic>;
    } 
    catch (e) {
      print('JSON decoding failed: $e');
      return null;
    }
  } 
  else {
    return null;
  }
}

// Request, format: function_name () async { .... }
/* 
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

      for (var entry in files.entries) {
        var file = await http.MultipartFile.fromPath(entry.key, entry.value.path);
        request.files.add(file);
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