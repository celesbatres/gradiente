import 'dart:convert';
import 'package:gradiente/services/models/register_type.dart';
import 'package:http/http.dart' as http;

class RegisterTypeApiService {
  static const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  /// Get all register types
  static Future<List<RegisterType>> getRegisterTypes() async {
    // TEMPORAL: Usar datos mock mientras se soluciona el problema de conexión
    // print('🔄 Usando datos mock para RegisterType');
    return [
      RegisterType(register_type: 1, name: 'Botón de adición'),
      RegisterType(register_type: 2, name: 'Teclado numérico'),
    ];
    
    /* CÓDIGO ORIGINAL COMENTADO TEMPORALMENTE
    try {
      final url = Uri.parse('$baseUrl/get_register_types.php');
      print('🔍 Intentando conectar a: $url');
      
      final response = await http.get(
        url,
        headers: {
          'ngrok-skip-browser-warning': 'true',
        }
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La petición tardó demasiado tiempo');
        },
      );
      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');
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
      print('❌ Error en getRegisterTypes: $e');
      print('❌ Tipo de error: ${e.runtimeType}');
      
      if (e.toString().contains('FormatException') || e.toString().contains('SyntaxError')) {
        throw Exception('Server returned invalid response. Please check if the API endpoint is working correctly. Error: $e');
      }
      if (e.toString().contains('CORS') || e.toString().contains('cross-origin')) {
        throw Exception('CORS error: The server needs to allow cross-origin requests. Error: $e');
      }
      if (e.toString().contains('SocketException') || e.toString().contains('Connection refused')) {
        throw Exception('No se puede conectar al servidor. Verifica que el servidor esté funcionando. Error: $e');
      }
      if (e.toString().contains('ClientException') || e.toString().contains('Failed to fetch')) {
        throw Exception('Error de conexión. Verifica tu conexión a internet y que la URL del servidor sea correcta. Error: $e');
      }
      throw Exception('Error fetching register types: $e');
    }
    */
  }

  /// Get a single register type by ID
  static Future<RegisterType?> getRegisterTypeById(int register_type) async {
    try {
      final registerTypes = await getRegisterTypes();
      return registerTypes.firstWhere(
        (registerType) => registerType.register_type == register_type,
        orElse: () => throw StateError('RegisterType not found'),
      );
    } catch (e) {
      if (e is StateError) return null;
      throw Exception('Error fetching register type: $e');
    }
  }
}
