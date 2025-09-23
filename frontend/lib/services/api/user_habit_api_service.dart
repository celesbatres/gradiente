import 'dart:convert';
import 'package:http/http.dart' as http;

class UserHabitApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Create a new user habit
  static Future<int?> createUserHabit({
    required int userId,
    required int habitId,
    required int registerTypeId,
    int? quantityRegister,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/insert_habit_u.php');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': userId.toString(),
          'habit_id': habitId.toString(),
          'register_type_id': registerTypeId.toString(),
          'quantity_register': quantityRegister?.toString() ?? '',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['user_habit_id'];
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to create user habit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating user habit: $e');
    }
  }
}
