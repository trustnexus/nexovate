import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexovate/src/models/questions/faq_dto.dart';
import 'package:nexovate/src/services/constants.dart';

class FaqService {
  final String _baseUrl = base_url;

  Future<List<FaqDTO>> fetchFaqs(String token) async {
    final url = Uri.parse('$_baseUrl/faqs');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => FaqDTO.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load FAQs: ${response.statusCode}');
    }
  }
}
