import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UidApiService {
  static const String baseUrl =
      'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';

  /// Get user by firebase uid (POST request)
  static Future<User> getUserByFirebaseUid(String firebaseUid) async {
    try {
      final url = Uri.parse('$baseUrl/uid_user.php');

      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'firebase_uid=$firebaseUid',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => User.fromJson(json)).first;
        } else {
          throw Exception(
            'API Error: ${responseData['error'] ?? 'Unknown error'}',
          );
        }
      } else {
        throw Exception('Failed to load user: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') ||
          e.toString().contains('SyntaxError')) {
        throw Exception(
          'Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e',
        );
      }
      if (e.toString().contains('CORS') ||
          e.toString().contains('cross-origin')) {
        throw Exception(
          'CORS error: The server needs to allow cross-origin requests. Error: $e',
        );
      }
      throw Exception('Error fetching user: $e');
    }
  }

  static Future<String?> createUser(String firebaseUid, String name) async {
  try {
    final url = Uri.parse('$baseUrl/insert_user.php');
    final response = await http.post(
      url,
      headers: {
        'ngrok-skip-browser-warning': 'true',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'firebase_uid=$firebaseUid&name=$name',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData['success'] == true) {
        return responseData['user'].toString(); // 👈 Devuelve el user
      }
    } else {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error creating user: $e');
  }

  return null; // 👈 Devuelve null si no hubo éxito
}

}
