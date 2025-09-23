import 'dart:convert';
import 'package:gradiente/services/models/register_type.dart';
import 'package:http/http.dart' as http;

class RegisterTypeApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Get all register types
  static Future<List<RegisterType>> getRegisterTypes() async {
    try {
      final url = Uri.parse('$baseUrl/get_register_types.php');
      
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
          return jsonData.map((json) => RegisterType.fromJson(json)).toList();
        } else {
          throw Exception('API Error: ${responseData['error'] ?? 'Unknown error'}');
        }
      } else {
        throw Exception('Failed to load register types: ${response.statusCode}');
      }
    } catch (e) {
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      throw Exception('Error fetching register types: $e');
    }
  }

  /// Get a single register type by ID
  static Future<RegisterType?> getRegisterTypeById(int registerTypeId) async {
    try {
      final registerTypes = await getRegisterTypes();
      return registerTypes.firstWhere(
        (registerType) => registerType.registerTypeId == registerTypeId,
        orElse: () => throw StateError('RegisterType not found'),
      );
    } catch (e) {
      if (e is StateError) return null;
      throw Exception('Error fetching register type: $e');
    }
  }
}
