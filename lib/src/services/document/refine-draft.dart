import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class RefineDraftService {
  final String baseUrl = base_url;

  Future<String> refineDraft({
    required String token,
    required String existingText,
    required String modifications,
  }) async {
    final url = Uri.parse('$baseUrl/documents/refine');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'existingText': existingText,
        'modifications': modifications,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true && data['refinedText'] != null) {
        return data['refinedText'] as String;
      }
      throw Exception('Refine draft failed: ${response.body}');
    } else {
      throw Exception('HTTP error: ${response.statusCode} - ${response.body}');
    }
  }
}
