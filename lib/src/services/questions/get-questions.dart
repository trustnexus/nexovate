import 'dart:convert';
import 'package:http/http.dart' as http;

//contains api base url
import '../constants.dart';

import '../../models/questions/question_dto.dart';

class QuestionnaireService {
  final String baseUrl = base_url;

  Future<List<QuestionnaireDTO>> fetchQuestions(String token) async {
    final url = Uri.parse('$baseUrl/questions');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => QuestionnaireDTO.fromJson(e)).toList();
    } else {
      throw Exception(
        'Failed to load questions: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
