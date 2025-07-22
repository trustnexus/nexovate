import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/auth/signup_dto.dart';

//contains api base url
import '../constants.dart';

class AuthenticationService {
  final String _baseUrl = base_url;

  Future<Map<String, dynamic>> registerUser(SignupDTO signupDTO) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signupDTO.toJson()),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['message'] ?? 'Failed to register');
    }
    
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
  final url = Uri.parse('$_baseUrl/auth/login');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body) as Map<String, dynamic>;
  } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Failed to login');
  }
}

}