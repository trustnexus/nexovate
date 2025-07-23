import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants.dart';

class GenerateDocResult {
  final bool success;
  final String? fileName;
  final String? downloadUrl;

  GenerateDocResult({
    required this.success,
    this.fileName,
    this.downloadUrl,
  });

  factory GenerateDocResult.fromJson(Map<String, dynamic> json) {
    return GenerateDocResult(
      success: json['success'] == true,
      fileName: json['fileName'] as String?,
      downloadUrl: json['downloadUrl'] as String?,
    );
  }
}

Future<GenerateDocResult> generateFinalDocument(String token) async {
  final url = Uri.parse('$base_url/documents/generate');
  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return GenerateDocResult.fromJson(data);
  } else {
    throw Exception('HTTP error: ${response.statusCode} - ${response.body}');
  }
}