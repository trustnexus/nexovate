import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import '../constants.dart';

const String questionnaireBoxName = 'questionnaireAnswers';

Future<String> generateDraftDocument(String token) async {
  final box = await Hive.openBox<String>(questionnaireBoxName);

  // Get the answer for questionId 1001
  final String? extraNotes = box.get('10');
  if (extraNotes == null || extraNotes.trim().isEmpty) {
    throw Exception('Answer for question ID 1001 not found');
  }

  final response = await http.post(
    Uri.parse('$base_url/documents/draft'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({'extraNotes': extraNotes}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['success'] == true && data['rawText'] != null) {
      return data['rawText'] as String;
    }
    throw Exception('Draft generation failed: ${response.body}');
  } else {
    throw Exception('HTTP error: ${response.statusCode}');
  }
}
