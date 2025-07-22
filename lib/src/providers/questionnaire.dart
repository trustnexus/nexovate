import 'package:flutter/material.dart';
import 'package:nexovate/src/models/questions/question_dto.dart';

class QuestionnaireProvider extends ChangeNotifier {
  final List<QuestionnaireDTO> _questions;

  QuestionnaireProvider(this._questions) {
    selectedOptions = List.filled(_questions.length, null);
  }

  List<QuestionnaireDTO> get questions => _questions;

  late List<int?> selectedOptions;
  final Map<int, TextEditingController> customInputs = {};
  final TextEditingController projectNameController = TextEditingController();

  void selectOption(int questionIndex, int optionIndex) {
    selectedOptions[questionIndex] = optionIndex;
    notifyListeners();
  }

bool isInputValid(int index) {
  final question = questions[index];
  final isTextQuestion = question.type.toLowerCase() == 'text_input';

  if (isTextQuestion || index == questions.length - 1) {
    final controller = customInputs[index];
    return controller != null && controller.text.trim().isNotEmpty;
  }

  final selectedIndex = selectedOptions[index];
  if (selectedIndex == null) return false;

  final selectedOption = question.options[selectedIndex];
  if (selectedOption.isCustom) {
    final controller = customInputs[index];
    return controller != null && controller.text.trim().isNotEmpty;
  }

  return true;
}



  String getAnswer(int i) {
    if (i == 0) return projectNameController.text.trim();
    final selectedIndex = selectedOptions[i] ?? 0;
    final selectedOption = _questions[i].options[selectedIndex];
    if (selectedOption.isCustom &&
        customInputs[i]?.text.trim().isNotEmpty == true) {
      return customInputs[i]!.text.trim();
    }
    return selectedOption.text;
  }

  void reset() {
    selectedOptions = List.filled(_questions.length, null);
    customInputs.clear();
    projectNameController.clear();
    notifyListeners();
  }
}

extension QuestionnaireProviderInit on QuestionnaireProvider {
  void initialize(List<QuestionnaireDTO> questions) {
    _questions.clear();
    _questions.addAll(questions);
    selectedOptions = List.filled(_questions.length, null);
    customInputs.clear();
    projectNameController.clear();
    notifyListeners();
  }
}
