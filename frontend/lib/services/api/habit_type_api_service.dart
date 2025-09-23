import 'dart:convert';
import 'package:gradiente/services/models/habit_type.dart';
import 'package:http/http.dart' as http;

class HabitTypeApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Get all habit types
  static Future<List<HabitType>> getHabitTypes() async {
    try {
      final url = Uri.parse('$baseUrl/get_habit_types.php');
      
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
          return jsonData.map((json) => HabitType.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load habit types: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      throw Exception('Error fetching habit types: $e');
    }
  }

  /// Get a single habit type by ID
  static Future<HabitType?> getHabitTypeById(int habitTypeId) async {
    try {
      final habitTypes = await getHabitTypes();
      return habitTypes.firstWhere(
        (habitType) => habitType.habitTypeId == habitTypeId,
        orElse: () => throw StateError('HabitType not found'),
      );
    } catch (e) {
      if (e is StateError) return null;
      throw Exception('Error fetching habit type: $e');
    }
  }
}
