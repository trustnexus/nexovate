import 'package:flutter/material.dart';
import 'package:nexovate/src/screens/utils/toast.dart';
import 'package:lottie/lottie.dart';
import 'package:nexovate/src/services/questions/save-question.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:nexovate/src/providers/user.dart';
import 'package:nexovate/src/providers/questionnaire.dart';
import 'package:nexovate/src/services/questions/get-questions.dart';
import 'package:nexovate/src/models/questions/question_dto.dart';
import 'package:nexovate/src/screens/utils/sidebar_navigation.dart';
import 'package:nexovate/src/screens/Project/saved_project.dart';

import 'package:nexovate/src/screens/Project/ui_screen.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _controller = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isQuizCompleted = false;
  bool isLoading = false;
  bool _isNextButtonEnabled = true;
  bool _isSaving = false; // New state variable for saving
  String error = '';
  late Box<String> _questionnaireBox;

  @override
  void initState() {
    super.initState();
    _initHive();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user?.token;

    if (token == null) {
      setState(() {
        error = 'User not logged in.';
        isLoading = false;
      });
      return;
    }

    try {
      final service = QuestionnaireService();
      final questions = await service.fetchQuestions(token);

      Provider.of<QuestionnaireProvider>(
        context,
        listen: false,
      ).initialize(questions);
      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _initHive() async {
    _questionnaireBox = await Hive.openBox<String>('questionnaireAnswers');
    _loadSavedAnswers();
  }

  void _onRestartQuiz() {
    Provider.of<QuestionnaireProvider>(context, listen: false).reset();
    setState(() => isQuizCompleted = false);
    _controller.jumpToPage(0);
  }

  Future<void> _saveAnswer({
    required String token,
    required int questionIndex,
    required QuestionnaireProvider provider,
  }) async {
    final question = provider.questions[questionIndex];
    final questionId = question.id;
    final SaveQuestionResponseService saveService =
        SaveQuestionResponseService();

    dynamic answer;

    if (question.type.toLowerCase() == 'multiple_choice') {
      final selectedIndex = provider.selectedOptions[questionIndex];
      if (selectedIndex != null) {
        final selectedOption = question.options[selectedIndex];
        answer =
            selectedOption.isCustom
                ? provider.customInputs[questionIndex]?.text ?? ''
                : selectedOption.id;
      }
    } else {
      answer =
          questionIndex == 0
              ? provider.projectNameController.text
              : provider.customInputs[questionIndex]?.text ?? '';
    }

    if (answer != null && answer.toString().trim().isNotEmpty) {
      try {
        await saveService.saveResponse(
          token: token,
          questionId: questionId,
          answer: answer,
        );
        _questionnaireBox.put(questionId.toString(), answer.toString());
      } catch (e) {
        showToast(context, 'Failed to save answer: $e');
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _questionnaireBox.close();
    super.dispose();
  }

  void _loadSavedAnswers() {
    final provider = Provider.of<QuestionnaireProvider>(context, listen: false);
    for (int i = 0; i < provider.questions.length; i++) {
      final question = provider.questions[i];
      final savedAnswer = _questionnaireBox.get(question.id.toString());
      if (savedAnswer != null) {
        if (i == 0) {
          provider.projectNameController.text = savedAnswer;
        } else if (question.type.toLowerCase() == 'text_input') {
          provider
              .customInputs
              .putIfAbsent(i, () => TextEditingController())
              .text = savedAnswer;
        }
        // For multiple choice, we'd need to map the saved string back to an option index
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuestionnaireProvider>(context);

    if (isLoading || provider.questions.isEmpty) {
      // Showing Lottie animation while loading or if questions are not yet loaded
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Color(0xFFFF9900),
              BlendMode.modulate,
            ),
            child: Lottie.asset('assets/anims/loading.json'),
          ),
        ),
      );
    }

    if (error.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(error, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final questions = provider.questions;

    return Scaffold(
      key: _scaffoldKey,
      drawer: const SidebarNavigation(),
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => _scaffoldKey.currentState!.openDrawer(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset('assets/images/N_log.png', height: 35),
          ),
        ],
      ),
      body:
          isQuizCompleted
              ? UIProjectScreen()
              : PageView.builder(
                controller: _controller,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder:
                    (context, index) => buildQuestionPage(index, provider),
              ),
    );
  }

  Widget buildQuestionPage(int index, QuestionnaireProvider provider) {
    final question = provider.questions[index];
    final selectedOption = provider.selectedOptions[index];
    final isValid = provider.isInputValid(index);

    final isTextInput = question.type.toLowerCase() != "multiple_choice";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          _buildStepIndicator(index),
          const SizedBox(height: 16),
          _buildQuestionText(question.text),
          const SizedBox(height: 30),
          Expanded(
            child:
                isTextInput
                    ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        controller:
                            index == 0
                                ? provider.projectNameController
                                : provider.customInputs.putIfAbsent(
                                  index,
                                  () => TextEditingController(),
                                ),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Type your answer here...",
                          hintStyle: const TextStyle(color: Colors.white54),
                          filled: true,
                          fillColor: Colors.black12,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.orangeAccent,
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    )
                    : ListView.builder(
                      itemCount: question.options.length + 1,
                      itemBuilder: (context, optionIndex) {
                        if (optionIndex == question.options.length) {
                          final selectedIdx = provider.selectedOptions[index];
                          final showCustomField =
                              selectedIdx != null &&
                              question.options[selectedIdx].isCustom;

                          provider.customInputs.putIfAbsent(
                            index,
                            () => TextEditingController(),
                          );

                          return AnimatedSize(
                            duration: const Duration(milliseconds: 400),
                            child:
                                showCustomField
                                    ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: TextField(
                                        controller:
                                            provider.customInputs[index],
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                        decoration: InputDecoration(
                                          hintText:
                                              "Enter your custom input...",
                                          hintStyle: const TextStyle(
                                            color: Colors.white54,
                                          ),
                                          filled: true,
                                          fillColor: Colors.black12,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.orangeAccent,
                                            ),
                                          ),
                                        ),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          );
                        }

                        final isSelected = selectedOption == optionIndex;
                        return GestureDetector(
                          onTap: () {
                            provider.selectOption(index, optionIndex);
                            setState(() {});
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.all(2.5),
                            decoration:
                                isSelected
                                    ? BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFFF9900),
                                          Color(0xFFFF3D5A),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pinkAccent.withOpacity(
                                            0.6,
                                          ),
                                          blurRadius: 12,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    )
                                    : BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Center(
                                child: Text(
                                  question.options[optionIndex].text,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
          ),
          const SizedBox(height: 16),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: isValid ? 1 : 0.5,
            child: GestureDetector(
              onTap: () async {
                if (!isValid || !_isNextButtonEnabled || _isSaving) return;

                final userProvider = Provider.of<UserProvider>(
                  context,
                  listen: false,
                );
                final token = userProvider.user?.token;
                setState(() {
                  _isSaving = true;
                  _isNextButtonEnabled = false; // Disable button immediately
                });

                if (token != null) {
                  await _saveAnswer(
                    token: token,
                    questionIndex: index,
                    provider: provider,
                  );
                }
                await Future.delayed(const Duration(milliseconds: 200));

                setState(() {
                  _isSaving = false;
                  _isNextButtonEnabled = true; // Re-enable button after delay
                });

                if (index < provider.questions.length - 1) {
                  _controller.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  // If it's the last question, set quiz as completed
                  setState(() => isQuizCompleted = true);
                }
              },
              child: AbsorbPointer(
                absorbing:
                    !_isNextButtonEnabled ||
                    _isSaving ||
                    !isValid ||
                    isQuizCompleted,
                child: Container(
                  width: double.infinity,
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    gradient:
                        isValid
                            ? const LinearGradient(
                              colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
                            )
                            : null,
                    color: !isValid ? Colors.grey[800] : null,
                  ),
                  child: Center(
                    child:
                        _isSaving
                            ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              index == provider.questions.length - 1
                                  ? "Submit"
                                  : "Next",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.6),
                  blurRadius: 15,
                  spreadRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "${index + 1}".padLeft(2, '0'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuestionText(String text) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 500),
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: value,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.pinkAccent],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.pinkAccent.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
