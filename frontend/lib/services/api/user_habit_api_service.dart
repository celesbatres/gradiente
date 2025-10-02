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
      
      print('userId: '+userId.toString());
      print('habitId: '+habitId.toString());
      print('registerTypeId: '+registerTypeId.toString());
      print('quantityRegister: '+quantityRegister.toString());
      
      final body = {
        'user': userId.toString(),
        'habit': habitId.toString(),
        'register_type': registerTypeId.toString(),
        'quantity_register': quantityRegister?.toString() ?? '',
      };
      
      print('Sending body: $body');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
          'Accept': 'application/json',
        },
        body: body,
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return int.parse(responseData['user_habit'].toString());
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
