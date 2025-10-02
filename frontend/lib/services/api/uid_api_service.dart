import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UidApiService {
  static const String baseUrl =
      'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';

  /// Get user by firebase uid (POST request) - returns null if not found
  static Future<User?> getUserByFirebaseUid(String firebaseUid) async {
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
        print('API Response (getUserByFirebaseUid): $responseData');
        if (responseData['success'] == true) {
          final List<dynamic> jsonData = responseData['data'] ?? [];
          if (jsonData.isNotEmpty) {
            final user = jsonData.map((json) => User.fromJson(json)).first;
            print('User parsed from API: $user');
            return user;
          }
          return null; // Usuario no encontrado
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

  static Future<String?> createUser(String firebaseUid, String name) async {
  try {
    final url = Uri.parse('$baseUrl/insert_user.php');
    final response = await http.post(
      url,
      headers: {
        'ngrok-skip-browser-warning': 'true',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'firebase_uid=$firebaseUid&name=$name',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('API Response (createUser): $responseData');
      if (responseData['success'] == true) {
        final userId = responseData['user'].toString();
        print('Created user ID: $userId');
        return userId; // 👈 Devuelve el user
      }
    } else {
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error creating user: $e');
  }

  return null; // 👈 Devuelve null si no hubo éxito
}

  /// Get or create user - busca usuario por firebase_uid, si no existe lo crea
  static Future<User> getOrCreateUser(String firebaseUid, String name) async {
    try {
      // Primero intentar buscar el usuario existente
      final existingUser = await getUserByFirebaseUid(firebaseUid);
      
      if (existingUser != null) {
        // Usuario existe, devolverlo
        print('Usuario encontrado: $existingUser');
        return existingUser;
      }
      
      // Usuario no existe, crear uno nuevo
      final userId = await createUser(firebaseUid, name);
      if (userId != null) {
        // Crear objeto User con los datos del nuevo usuario
        return User(
          user: int.parse(userId),
          name: name,
          firebaseUid: firebaseUid,
        );
      } else {
        throw Exception('Error al crear usuario en la base de datos');
      }
    } catch (e) {
      throw Exception('Error al obtener o crear usuario: $e');
    }
  }

}
