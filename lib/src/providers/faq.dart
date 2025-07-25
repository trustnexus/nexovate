import 'package:flutter/material.dart';
import 'package:nexovate/src/models/questions/faq_dto.dart';
import 'package:nexovate/src/services/faqs/get-faqs.dart';

class FaqProvider extends ChangeNotifier {
  final FaqService _faqService = FaqService();
  List<FaqDTO> _faqs = [];
  bool _isLoading = false;
  String? _error;

  List<FaqDTO> get faqs => _faqs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchFaqs(String token) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _faqs = await _faqService.fetchFaqs(token);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
