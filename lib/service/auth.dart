import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<String?> authenticate(String username, String password) async {
    final response = await http.post(
      Uri.parse('https://sirehatcerdas.online/api/login'),
      body: {
        'username': username,
        'password': password,
      },
    );

    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final accessToken = jsonData['access_token'];
      final userProfile = jsonData['user_profile'];

      await saveAccessToken(accessToken);
      await saveUserProfile(userProfile);

      return accessToken;
    } else {
      throw Exception('Failed to authenticate');
    }
  }

  static Future<void> saveUserProfile(Map<String, dynamic> userProfile) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_profile', json.encode(userProfile));
    } catch (e) {
      print('Failed to save user profile: $e');
      throw Exception('Failed to save user profile');
    }
  }

  // static Future<String> getUserId(String accessToken) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final userId = prefs.getString('userId');
  //   if (userId == null) {
  //     throw Exception('User ID not found');
  //   }
  //   return userId;
  // }

  // static Future<void> saveUserId(String token) async {
  //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('user_id', token);
  // }

  static Future<void> saveAccessToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getAccessToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  static void clearToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
  }
}
