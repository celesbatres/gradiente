import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  const String baseUrl = 'https://unpuritan-bryon-psittacistic.ngrok-free.app/api';
  
  try {
    print('Testing API endpoint...');
    final url = Uri.parse('$baseUrl/get_user_habits.php');
    
    final response = await http.get(url);
    
    print('Status Code: ${response.statusCode}');
    print('Headers: ${response.headers}');
    print('Response Body:');
    print(response.body);
    
    if (response.statusCode == 200) {
      try {
        final jsonData = json.decode(response.body);
        print('JSON parsed successfully: $jsonData');
      } catch (e) {
        print('JSON parsing error: $e');
      }
    }
    
  } catch (e) {
    print('Error: $e');
  }
}
