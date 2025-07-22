/* 


POST /api/questions/finalize Headers: Authorization: Bearer <token>
{
"selectedTemplateIds": [1, 3]
}

*/

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nexovate/src/models/templates/templates_dto.dart';
import 'package:nexovate/src/services/constants.dart';

class FinalizeTemplatesService {
  static Future<bool> finalizeTemplates({
    required String token,
    required List<TemplateDTO> templates,
  }) async {
    final url = Uri.parse('$base_url/questions/finalize');
    final ids = templates.map((t) => t.templateId).toList();

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'selectedTemplateIds': ids}),
    );

    return response.statusCode == 200;
  }
}
