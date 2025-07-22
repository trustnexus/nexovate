// -----------------------------
// api/auth_service.dart
// -----------------------------
import 'dart:convert';
import 'package:http/http.dart' as http;

//contains api base url
import '../constants.dart';

class AuthService {
  final String baseUrl = base_url;

  Future<Map<String, dynamic>> changePassword({
    required String token,
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final uri = Uri.parse("$baseUrl/auth/change-password");
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "currentPassword": currentPassword,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      }),
    );

    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> changeEmail({
    required String token,
    required String newEmail,
    required String confirmEmail,
  }) async {
    final uri = Uri.parse("$baseUrl/auth/change-email");
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"newEmail": newEmail, "confirmEmail": confirmEmail}),
    );

    return jsonDecode(response.body);
  }
}
