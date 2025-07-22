import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';

class SaveQuestionResponseService {
  final String baseUrl = base_url;

  Future<bool> saveResponse({
    required String token,
    required int questionId,
    required dynamic answer, // int (option id) or String (custom text)
  }) async {
    final url = Uri.parse('$baseUrl/questions/responses');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'questionId': questionId,
        'answer': answer,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        'Failed to save response: ${response.statusCode} - ${response.body}',
      );
    }
  }
}