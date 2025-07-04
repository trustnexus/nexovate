import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:admin_demo/viewmodel/notifiers/thememode.dart';
import 'package:admin_demo/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({super.key});

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with TickerProviderStateMixin {
  // SVG asset paths
  static const String ellipseAsset = 'assets/images/ellipse_bg.svg';
  static const String lineAsset = 'assets/images/line_svg.svg';

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

  void _editQuestion(int index) {}
  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _editOption(int questionIndex, int optionIndex) {}
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
        final colors = isDark ? AppColors.dark : AppColors.light;

        final borderColor = colors['borderColor'] as Color;
        final textColor = colors['textColor'] as Color;
        final subTextColor = colors['subTextColor'] as Color;
        final iconColor = colors['iconColor'] as Color;
        final editIconColor = colors['editIconColor'] as Color;
        final deleteIconColor = colors['deleteIconColor'] as Color;
        final expandedColor = colors['expandedColor'] as Color;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              // Top left ellipse
              Positioned(
                top: -80,
                left: -120,
                child: SvgPicture.asset(
                  ellipseAsset,
                  height: 220,
                  width: 220,
                ),
              ),
              // Bottom right ellipse
              Positioned(
                bottom: -100,
                right: -140,
                child: SvgPicture.asset(
                  ellipseAsset,
                  height: 300,
                  width: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    // Line SVG as a separator
                    SvgPicture.asset(
                      lineAsset,
                      height: 5,
                      width: 400,
                    ),
                    const SizedBox(height: 24),
                    // The questions list
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: _questions.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) newIndex--;
                            final item = _questions.removeAt(oldIndex);
                            _questions.insert(newIndex, item);
                          });
                        },
                        buildDefaultDragHandles: false,
                        itemBuilder: (context, index) {
                          final question = _questions[index];
                          final isExpanded = question['isExpanded'] as bool;

                          return ZoomIn(
                            key: ValueKey(index),
                            duration: Duration(milliseconds: 400 + index * 100),
                            child: AnimatedSize(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    question['isExpanded'] = !isExpanded;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(vertical: 12),
                                  padding: const EdgeInsets.all(20),
                                  width: isExpanded ? double.infinity : 400,
                                  decoration: BoxDecoration(
                                    color: isExpanded ? expandedColor : Colors.transparent,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(color: borderColor, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: TweenAnimationBuilder<double>(
                                              tween: Tween<double>(
                                                begin: isExpanded ? 28 : 22,
                                                end: isExpanded ? 22 : 28,
                                              ),
                                              duration: const Duration(milliseconds: 400),
                                              curve: Curves.easeInOut,
                                              builder: (context, fontSize, child) {
                                                return Text(
                                                  'Q${index + 1}: ${question['question']}',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    color: textColor,
                                                    fontSize: fontSize,
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                                  softWrap: true,
                                                );
                                              },
                                            ),
                                          ),
                                          ReorderableDragStartListener(
                                            index: index,
                                            child: Icon(
                                              Icons.drag_handle,
                                              color: iconColor,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(Icons.edit, color: editIconColor),
                                            tooltip: 'Edit Question',
                                            onPressed: () => _editQuestion(index),
                                          ),
                                          SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: deleteIconColor,
                                            ),
                                            tooltip: 'Delete Question',
                                            onPressed: () => _deleteQuestion(index),
                                          ),
                                        ],
                                      ),
                                      if (isExpanded) ...[
                                        const SizedBox(height: 16),
                                        FadeIn(
                                          child: Text(
                                            'Options:',
                                            style: GoogleFonts.plusJakartaSans(
                                              color: subTextColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        ...question['options'].asMap().entries.map((
                                          entry,
                                        ) {
                                          final optionIndex = entry.key;
                                          final option = entry.value;
                                          return FadeIn(
                                            duration: Duration(
                                              milliseconds:
                                                  300 + (optionIndex as int) * 100,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                vertical: 4.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      '${String.fromCharCode(65 + optionIndex)}. $option',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        color: subTextColor,
                                                        fontSize: 14,
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
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          floatingActionButton: ElasticIn(
            duration: const Duration(milliseconds: 600),
            child: FloatingActionButton.extended(
              onPressed: _toggleExpandAll,
              label: Text(
                _allExpanded ? 'Collapse All' : 'Expand All',
                style: TextStyle(color: isDark ? Colors.black : Colors.white),
              ),
              icon: Icon(
                _allExpanded ? Icons.unfold_less : Icons.unfold_more,
                color: isDark ? Colors.black : Colors.white,
              ),
              backgroundColor: isDark ? Colors.amber : const Color(0xFFFF2553),
            ),
          ),
        );
      },
    );
  }
}
