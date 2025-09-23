import 'dart:convert';
import 'package:gradiente/services/models/habit_register.dart';
import 'package:http/http.dart' as http;

class HabitRegisterApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Get habit registers by user habit ID
  static Future<List<HabitRegister>> getHabitRegistersByUserHabit(int userHabitId) async {
    try {
      final url = Uri.parse('$baseUrl/get_habit_registers.php');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'user_habit_id=$userHabitId',
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => HabitRegister.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load habit registers: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      throw Exception('Error fetching habit registers: $e');
    }
  }

  /// Create a new habit register
  static Future<bool> createHabitRegister({
    required int userHabitId,
    required int amount,
    String? addDate,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/insert_habit_register.php');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_habit_id': userHabitId.toString(),
          'amount': amount.toString(),
          'add_date': addDate ?? DateTime.now().toIso8601String().split('T')[0],
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] == true;
      } else {
        throw Exception('Failed to create habit register: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating habit register: $e');
    }
  }

  /// Get habit registers by date range
  static Future<List<HabitRegister>> getHabitRegistersByDateRange({
    required int userHabitId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/get_habit_registers_by_date.php');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_habit_id': userHabitId.toString(),
          'start_date': startDate,
          'end_date': endDate,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => HabitRegister.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load habit registers: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching habit registers by date: $e');
    }
  }
}
