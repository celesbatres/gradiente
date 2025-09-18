import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserApiService {
  static const String baseUrl =
      'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';

  /// Get user id
  static Future<List<User>> getUser(String firebaseUid) async {
    try {
      final url = Uri.parse('$baseUrl/uid_user.php');

      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'firebase_uid': firebaseUid}),
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          print(responseData['data']);
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => User.fromJson(json)).toList();
        } else {
          print("Probablemente no existe el usuario 1");
          throw Exception(
            'API Error: ${responseData['error'] ?? 'Unknown error'}',
          );
        }
      } else {
         print("Probablemente no existe el usuario 2");
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
}
