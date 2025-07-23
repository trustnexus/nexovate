import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:nexovate/src/screens/utils/toast.dart';

import 'package:nexovate/src/services/document/generate-draft.dart';
import 'package:nexovate/src/services/document/refine-draft.dart';
import 'package:nexovate/src/services/document/generate-doc.dart';

import 'package:lottie/lottie.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:provider/provider.dart';
import 'package:nexovate/src/providers/user.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexovate/src/screens/Project/saved_project.dart';

class PromptScreen extends StatefulWidget {
  const PromptScreen({super.key});

  @override
  State<PromptScreen> createState() => _PromptScreenState();
}

class _PromptScreenState extends State<PromptScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final RefineDraftService _refineDraftService = RefineDraftService();
  String _markdownResponse = "";
  bool _isLoading = true;

  late AnimationController _titleController;
  late AnimationController _logoController;
  late AnimationController _markdownController;
  late AnimationController _acceptBtnController;
  late AnimationController _inputController;
  late AnimationController _sendBtnController;

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _markdownController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _acceptBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _inputController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _sendBtnController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fetchInitialDraft();
    _runEntranceAnimations();
  }

  Future<void> _runEntranceAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _titleController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _markdownController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _inputController.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _sendBtnController.forward();
    // Accept button animates in only after markdown loaded
  }

  Future<void> _fetchInitialDraft() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user?.token ?? '';
      final rawText = await generateDraftDocument(token);
      setState(() {
        _markdownResponse = rawText;
        _isLoading = false;
      });
      _acceptBtnController.forward();
    } catch (e) {
      setState(() {
        _markdownResponse = "Error loading draft: $e";
        _isLoading = false;
      });
      _acceptBtnController.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleController.dispose();
    _logoController.dispose();
    _markdownController.dispose();
    _acceptBtnController.dispose();
    _inputController.dispose();
    _sendBtnController.dispose();
    super.dispose();
  }

  Future<void> fetchRefinedMarkdown(String modification) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user?.token ?? '';
      final refinedText = await _refineDraftService.refineDraft(
        token: token,
        existingText: _markdownResponse,
        modifications: modification,
      );
      setState(() {
        _markdownResponse = refinedText;
        _isLoading = false;
      });
      _acceptBtnController.forward();
    } catch (e) {
      setState(() {
        _markdownResponse = "Error refining draft: $e";
        _isLoading = false;
      });
      _acceptBtnController.forward();
    }
  }

  void _onAccept() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SaveProjectScreen(markdownDraft: _markdownResponse),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.pinkAccent,
                              size: 18,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      AnimatedBuilder(
                        animation: _titleController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _titleController.value,
                            child: Transform.translate(
                              offset: Offset(
                                0,
                                30 * (1 - _titleController.value),
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: _gradientTitle("Refine Scope Document"),
                      ),
                      Positioned(
                        right: 0,
                        child: AnimatedBuilder(
                          animation: _logoController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _logoController.value,
                              child: Transform.scale(
                                scale: 0.8 + 0.2 * _logoController.value,
                                child: child,
                              ),
                            );
                          },
                          child: Image.asset(
                            'assets/images/N_log.png',
                            height: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: AnimatedBuilder(
                    animation: _markdownController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _markdownController.value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            40 * (1 - _markdownController.value),
                          ),
                          child: child,
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.13),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 16,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                _isLoading
                                    ? Center(
                                      child: ColorFiltered(
                                        colorFilter: const ColorFilter.mode(
                                          Color(0xFFFF9900),
                                          BlendMode.modulate,
                                        ),
                                        child: Lottie.asset(
                                          'assets/anims/loading.json',
                                        ),
                                      ),
                                    )
                                    : Markdown(
                                      data:
                                          _markdownResponse.isEmpty
                                              ? """### There may be no draft available due to internal server problem"""
                                              : _markdownResponse,
                                    ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: _acceptBtnController,
                  builder: (context, child) {
                    return (_markdownResponse.isNotEmpty && !_isLoading)
                        ? Opacity(
                          opacity: _acceptBtnController.value,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              30 * (1 - _acceptBtnController.value),
                            ),
                            child: child,
                          ),
                        )
                        : const SizedBox.shrink();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 8),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onAccept,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 6,
                          backgroundColor: null,
                          foregroundColor: Colors.white,
                        ).copyWith(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                                (states) => null,
                              ),
                          shadowColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                        ),
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFF04C00),
                                  Color(0xFFFF9900),
                                  Color(0xFFB721FF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds),
                          child: const Text(
                            "Accept & Continue",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _inputController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _inputController.value,
                      child: Transform.translate(
                        offset: Offset(0, 40 * (1 - _inputController.value)),
                        child: child,
                      ),
                    );
                  },
                  child: Expanded(
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(right: 56),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(
                              255,
                              48,
                              44,
                              47,
                            ).withOpacity(0.85),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(
                                  255,
                                  46,
                                  1,
                                  16,
                                ).withOpacity(0.07),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: _controller,
                            maxLines: 4,
                            minLines: 2,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Refine Scope Document...',
                              hintStyle: TextStyle(color: Color(0x34F5F5DC)),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: AnimatedBuilder(
                            animation: _sendBtnController,
                            builder: (context, child) {
                              return Opacity(
                                opacity: _sendBtnController.value,
                                child: Transform.scale(
                                  scale: 0.7 + 0.3 * _sendBtnController.value,
                                  child: child,
                                ),
                              );
                            },
                            child: GestureDetector(
                              onTap: () async {
                                showToast(
                                  context,
                                  'Processing refinement request...',
                                );
                                if (_controller.text.trim().isNotEmpty) {
                                  await fetchRefinedMarkdown(
                                    _controller.text.trim(),
                                  );
                                  _controller.clear();
                                  _sendBtnController.forward();
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color.fromARGB(255, 240, 76, 0),
                                      Color.fromARGB(255, 150, 25, 3),
                                      Color.fromARGB(255, 255, 225, 52),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.pinkAccent.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(12),
                                child: const Icon(
                                  Icons.send_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gradientTitle(String text) {
    return ShaderMask(
      shaderCallback:
          (bounds) => const LinearGradient(
            colors: [Colors.orange, Colors.pinkAccent],
          ).createShader(bounds),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
          color: Colors.white,
        ),
      ),
    );
  }
}

class SaveProjectScreen extends StatefulWidget {
  final String markdownDraft;
  const SaveProjectScreen({super.key, required this.markdownDraft});

  @override
  State<SaveProjectScreen> createState() => _SaveProjectScreenState();
}

class _SaveProjectScreenState extends State<SaveProjectScreen> {
  bool _saving = false;
  bool _saved = false;
  String? _projectName;
  Map<String, dynamic>? _answers;

  @override
  void initState() {
    super.initState();
    _loadAnswers();
  }

  Future<void> _loadAnswers() async {
    final box = await Hive.openBox<String>('questionnaireAnswers');
    final answers = <String, dynamic>{};
    for (var key in box.keys) {
      answers[key.toString()] = box.get(key);
    }
    final projectName = answers['1001'] ?? 'Untitled Project';
    setState(() {
      _answers = answers;
      _projectName = projectName;
    });
  }

  Future<void> _saveProject() async {
    setState(() {
      _saving = true;
    });

    if (mounted) {
      showToast(context, 'Saving project, This may take a while...');
    }

    final projectsBox = await Hive.openBox('Projects');
    final project = {
      'name': _projectName ?? 'Untitled Project',
      'answers': _answers ?? {},
      'draft': widget.markdownDraft,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await projectsBox.add(project);

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = userProvider.user?.token ?? '';

    try {
      final result = await generateFinalDocument(token);
      if (result.success) {
        final lastKey = projectsBox.keys.last;
        final savedProject = projectsBox.get(lastKey) as Map;
        savedProject['fileName'] = result.fileName;
        savedProject['downloadUrl'] = result.downloadUrl;
        await projectsBox.put(lastKey, savedProject);
      }
    } catch (e) {
      if (mounted) {
        showToast(context, 'Error generating final document: $e');
      }
    }

    if (!mounted) return;

    setState(() {
      _saving = false;
      _saved = true;
    });

    showToast(context, 'Project saved successfully!');

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SavedProjectsScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(32),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        width: double.infinity,
                        constraints: const BoxConstraints(maxWidth: 600),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.13),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.22),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ShaderMask(
                                shaderCallback:
                                    (bounds) => const LinearGradient(
                                      colors: [
                                        Color(0xFFFF9900),
                                        Color(0xFFFF3D5A),
                                      ],
                                    ).createShader(bounds),
                                child: Text(
                                  _projectName ?? "Loading...",
                                  style: const TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Container(
                                constraints: const BoxConstraints(
                                  maxHeight: 600,
                                ),
                                child:
                                    widget.markdownDraft.isEmpty
                                        ? Center(
                                          child: Lottie.asset(
                                            'assets/anims/loading.json',
                                            width: 80,
                                          ),
                                        )
                                        : Markdown(
                                          data: widget.markdownDraft,
                                          styleSheet: MarkdownStyleSheet(
                                            p: const TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                            ),
                                            h1: const TextStyle(
                                              color: Colors.orange,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                            ),
                                            h2: const TextStyle(
                                              color: Colors.pinkAccent,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                              ),
                              const SizedBox(height: 28),
                              _saved
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.greenAccent,
                                    size: 40,
                                  )
                                  : SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed:
                                          _answers == null || _saving
                                              ? null
                                              : _saveProject,
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        elevation: 8,
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                      ).copyWith(
                                        backgroundColor:
                                            MaterialStateProperty.resolveWith<
                                              Color?
                                            >((states) => null),
                                        shadowColor: MaterialStateProperty.all(
                                          Colors.transparent,
                                        ),
                                      ),
                                      child: ShaderMask(
                                        shaderCallback:
                                            (bounds) => const LinearGradient(
                                              colors: [
                                                Color(0xFFF04C00),
                                                Color(0xFFFF9900),
                                                Color(0xFFB721FF),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ).createShader(bounds),
                                        child: const Text(
                                          "Save Project",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_saving)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF9900)),
              ),
            ),
          ),
      ],
    );
  }
}
