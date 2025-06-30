import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:admin_demo/viewmodel/notifiers/thememode.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'What is Flutter?',
      'options': [
        'A UI toolkit',
        'A programming language',
        'A database',
        'An operating system',
      ],
      'isExpanded': false,
    },
    {
      'question': 'Which language is used for Flutter development?',
      'options': ['Java', 'Kotlin', 'Dart', 'Swift'],
      'isExpanded': false,
    },
    {
      'question': 'What is a Widget in Flutter?',
      'options': [
        'A temporary variable',
        'A building block of UI',
        'A type of database',
        'A network protocol',
      ],
      'isExpanded': false,
    },
  ];

  bool _allExpanded = false;

  void _toggleExpandAll() {
    setState(() {
      _allExpanded = !_allExpanded;
      for (var question in _questions) {
        question['isExpanded'] = _allExpanded;
      }
    });
  }

  void _editQuestion(int index) {
    //TODO: Implement edit logic here
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _editOption(int questionIndex, int optionIndex) {
    //TODO: Implement edit logic here
  }

  void _deleteOption(int questionIndex, int optionIndex) {
    setState(() {
      _questions[questionIndex]['options'].removeAt(optionIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(
      builder: (context, provider, child) {
        final isDark = provider.isDarkMode;

        final cardGradient = LinearGradient(
          colors:
              isDark
                  ? [
                    Colors.white.withAlpha(102),
                    Colors.white.withAlpha(78),
                    Colors.white.withAlpha(52),
                    Colors.white.withAlpha(25),
                  ]
                  : [
                    Colors.black.withAlpha(102),
                    Colors.black.withAlpha(78),
                    Colors.black.withAlpha(52),
                    Colors.black.withAlpha(25),
                  ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        );
        final borderColor = isDark ? Colors.white30 : Colors.black38;
        final textColor = isDark ? Colors.white : Colors.black;
        final subTextColor = isDark ? Colors.white70 : Colors.black87;
        final iconColor = isDark ? Colors.amber : Colors.black;
        final editIconColor = isDark ? Colors.amber : Colors.black;
        final deleteIconColor = isDark ? Colors.redAccent : Colors.red;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: GridView.builder(
            padding: const EdgeInsets.all(30.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20.0,
              mainAxisSpacing: 20.0,
              childAspectRatio: 1.1,
            ),
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              final questionData = _questions[index];
              final isExpanded = questionData['isExpanded'] as bool;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: borderColor, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: cardGradient,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ExpansionTile(
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    iconColor: iconColor,
                    collapsedIconColor: iconColor,
                    initiallyExpanded: isExpanded,
                    onExpansionChanged: (expanded) {
                      setState(() {
                        questionData['isExpanded'] = expanded;
                      });
                    },
                    title: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Question ${index + 1}: ${questionData['question']}',
                              style: GoogleFonts.plusJakartaSans(
                                color: textColor,
                                fontSize:
                                    isExpanded
                                        ? 18
                                        : 24, // Bigger when not expanded
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: editIconColor),
                          tooltip: 'Edit Question',
                          onPressed: () => _editQuestion(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: deleteIconColor),
                          tooltip: 'Delete Question',
                          onPressed: () => _deleteQuestion(index),
                        ),
                      ],
                    ),
                    children:
                        isExpanded
                            ? [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Options:',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: subTextColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...questionData['options'].asMap().entries.map<
                                      Widget
                                    >((entry) {
                                      int optionIndex = entry.key;
                                      String option = entry.value;
                                      return Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 8.0,
                                                bottom: 4.0,
                                              ),
                                              child: Text(
                                                '${String.fromCharCode(65 + optionIndex)}. $option',
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                      color: subTextColor,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              size: 18,
                                              color: editIconColor,
                                            ),
                                            tooltip: 'Edit Option',
                                            onPressed:
                                                () => _editOption(
                                                  index,
                                                  optionIndex,
                                                ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              size: 18,
                                              color: deleteIconColor,
                                            ),
                                            tooltip: 'Delete Option',
                                            onPressed:
                                                () => _deleteOption(
                                                  index,
                                                  optionIndex,
                                                ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                            ]
                            : [],
                  ),
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _toggleExpandAll,
            label: Text(
              _allExpanded ? 'Collapse All' : 'Expand All',
              style: TextStyle(color: isDark ? Colors.black : Colors.white),
            ),
            icon: Icon(
              _allExpanded ? Icons.unfold_less : Icons.unfold_more,
              color: isDark ? Colors.black : Colors.white,
            ),
            backgroundColor: isDark ? Colors.amber : Color(0xFFFF2553),
          ),
        );
      },
    );
  }
}
