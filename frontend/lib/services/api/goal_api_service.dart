import 'dart:convert';
import 'package:gradiente/services/models/goal.dart';
import 'package:http/http.dart' as http;

class GoalApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Get goals by user habit ID
  static Future<List<Goal>> getGoalsByUserHabit(int userHabitId) async {
    try {
      final url = Uri.parse('$baseUrl/get_goals.php');
      
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
          return jsonData.map((json) => Goal.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load goals: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      throw Exception('Error fetching goals: $e');
    }
  }

  /// Get current active goal for a user habit
  static Future<Goal?> getCurrentGoal(int userHabitId) async {
    try {
      final goals = await getGoalsByUserHabit(userHabitId);
      return goals.firstWhere(
        (goal) => goal.actual == true,
        orElse: () => throw StateError('No current goal found'),
      );
    } catch (e) {
      if (e is StateError) return null;
      throw Exception('Error fetching current goal: $e');
    }
  }

  /// Create a new goal
  static Future<bool> createGoal({
    required int userHabitId,
    int? quantity,
    int? days,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/insert_goal.php');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_habit': userHabitId.toString(),
          'quantity': quantity?.toString() ?? '',
          'days': days?.toString() ?? '',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] == true;
      } else {
        throw Exception('Failed to create goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating goal: $e');
    }
  }

  /// Update an existing goal
  static Future<bool> updateGoal({
    required int goalId,
    int? quantity,
    int? days,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/update_goal.php');
      
      final response = await http.post(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'goal_id': goalId.toString(),
          'quantity': quantity?.toString() ?? '',
          'days': days?.toString() ?? '',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['success'] == true;
      } else {
        throw Exception('Failed to update goal: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating goal: $e');
    }
  }

  /// Mark a goal as completed (set actual to false)
  static Future<bool> completeGoal(int goalId) async {
    return await updateGoal(goalId: goalId);
  }
}
