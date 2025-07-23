import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:nexovate/src/services/constants.dart';

Future<String> downloadDocument(
  String downloadUrl,
  String fileName,
  String token,
) async {
  try {
    final response = await http.get(
      Uri.parse('$base_url$downloadUrl'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      Directory downloadsDirectory;
      if (Platform.isAndroid) {
        // Save to internal storage Downloads folder
        downloadsDirectory = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      } else {
        downloadsDirectory = await getApplicationDocumentsDirectory();
      }
      if (!await downloadsDirectory.exists()) {
        await downloadsDirectory.create(recursive: true);
      }
      final filePath = '${downloadsDirectory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to download document: ${response.statusCode}');
    }
  } catch (e) {
    print('Downloading document from: $base_url/$downloadUrl');
    throw Exception('Error downloading document: $e');
  }
}
