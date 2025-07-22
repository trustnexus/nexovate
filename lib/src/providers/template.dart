// filepath: D:/nexovate-app/lib/src/providers/template.dart
import 'package:flutter/material.dart';
import '../models/templates/templates_dto.dart';
import '../services/templates/get-templates.dart';

class TemplateProvider extends ChangeNotifier {
  final TemplatesService _service = TemplatesService();

  List<TemplateDTO> _templates = [];
  bool _isLoading = false;
  String? _error;

  List<TemplateDTO> get templates => _templates;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchTemplates(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fetchedTemplates = await _service.fetchTemplates(token);
      _templates = fetchedTemplates;
    } catch (e) {
      _error = e.toString();
      _templates = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clear() {
    _templates = [];
    _error = null;
    notifyListeners();
  }
}