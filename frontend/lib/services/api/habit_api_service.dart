import 'dart:convert';
import 'package:gradiente/services/models/habit.dart';
import 'package:http/http.dart' as http;
import '../models/habit_user.dart';

class HabitApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Get user habits (no parameters required)
  static Future<List<HabitUser>> getUserHabits() async {
    try {
      final url = Uri.parse('$baseUrl/get_user_habits.php');
      
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => HabitUser.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load habits: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      throw Exception('Error fetching habits: $e');
    }
  }

  static Future<List<Habit>> getHabits() async {
    try {
      final url = Uri.parse('$baseUrl/get_habits.php');
      
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          return jsonData.map((json) => Habit.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load habits: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      throw Exception('Error fetching habits: $e');
    }
  }

  /// Get a single habit by ID
  static Future<HabitUser?> getHabitById(int habitId) async {
    try {
      final url = Uri.parse('$baseUrl/get_habits.php');
      
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final habitData = jsonData.firstWhere(
          (habit) => habit['id'] == habitId,
          orElse: () => null,
        );
        
        return habitData != null ? HabitUser.fromJson(habitData) : null;
      } else {
        throw Exception('Failed to load habit: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching habit: $e');
    }
  }
}
