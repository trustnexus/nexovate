import 'dart:convert';

import 'package:http/http.dart' as http;

// contains api base url
import '../constants.dart';

import '../../models/templates/templates_dto.dart';

class TemplatesService {
  final String baseUrl = base_url;

  Future<List<TemplateDTO>> fetchTemplates(String token) async {
    final url = Uri.parse('$baseUrl/templates');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => TemplateDTO.fromJson(item)).toList();
    } else {
      throw Exception(
        'Failed to load templates: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
