import 'dart:convert';
import 'package:gradiente/services/models/user.dart';
import 'package:http/http.dart' as http;

class UserApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
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

  /// Create a new user
  static Future<String?> createUser({
    required String firebaseUid,
    required String name,
    int? age,
    String? gender,
    String? wakeUp,
    String? goToBed,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/insert_user.php');
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'firebase_uid': firebaseUid,
          'name': name,
          'age': age?.toString() ?? '',
          'gender': gender ?? '',
          'wake_up': wakeUp ?? '',
          'go_to_bed': goToBed ?? '',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['user'].toString();
        }
      } else {
        throw Exception('Failed to create user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }

    return null;
  }

  /// Update user information
  static Future<bool> updateUser({
    required int userId,
    String? name,
    int? age,
    String? gender,
    String? wakeUp,
    String? goToBed,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/update_user.php');
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': userId.toString(),
          'name': name ?? '',
          'age': age?.toString() ?? '',
          'gender': gender ?? '',
          'wake_up': wakeUp ?? '',
          'go_to_bed': goToBed ?? '',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] == true;
      } else {
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  /// Get all users (for admin purposes)
  static Future<List<User>> getAllUsers() async {
    try {
      final url = Uri.parse('$baseUrl/get_users.php');
      
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => User.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }
}
