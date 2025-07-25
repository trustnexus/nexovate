import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:nexovate/src/screens/prompt/prompt.dart';
import 'package:nexovate/src/screens/utils/toast.dart';
import 'package:nexovate/src/services/templates/finalize-templates.dart';
import 'package:provider/provider.dart';
import '../../providers/template.dart';
import '../../providers/user.dart';
import '../../models/templates/templates_dto.dart';

class UIProjectScreen extends StatefulWidget {
  const UIProjectScreen({super.key});

  @override
  State<UIProjectScreen> createState() => _UIProjectScreenState();
}

class _UIProjectScreenState extends State<UIProjectScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int mobileIndex = 0;
  int desktopIndex = 0;
  bool _isNext = true;

  // Multi-select: store selected templates
  final List<TemplateDTO> _selectedTemplates = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TemplateProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user?.token ?? '';
      provider.fetchTemplates(token);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Toggle selection
  void _toggleTemplate(TemplateDTO template) {
    setState(() {
      if (_selectedTemplates.any((t) => t.templateId == template.templateId)) {
        _selectedTemplates.removeWhere(
          (t) => t.templateId == template.templateId,
        );
      } else {
        _selectedTemplates.add(template);
      }
    });
  }

  void _changeScreen(bool isNext, int max) {
    setState(() {
      _isNext = isNext;
      if (_tabController.index == 0) {
        mobileIndex = (mobileIndex + (isNext ? 1 : -1)) % max;
        if (mobileIndex < 0) mobileIndex += max;
      } else {
        desktopIndex = (desktopIndex + (isNext ? 1 : -1)) % max;
        if (desktopIndex < 0) desktopIndex += max;
      }
    });
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

  Widget _buildPreview(TemplateDTO template, bool isSelected) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        final offsetTween = Tween<Offset>(
          begin: Offset(_isNext ? 1.0 : -1.0, 0),
          end: Offset.zero,
        );
        final fade = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );
        final slide = offsetTween.animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOut),
        );
        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: InteractiveViewer( // Added InteractiveViewer here
              child: child,
            ),
          ),
        );
      },
      child: GestureDetector(
        key: ValueKey(template.templateId),
        onTap: () => _toggleTemplate(template), // Toggle selection
        child: Stack(
          children: [
            ClipRRect( // Added ClipRRect for rounded corners
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 280,
                height: 500,
                decoration: BoxDecoration(
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                    color: isSelected ? Colors.orange.withOpacity(0.5) : Colors.orange.withOpacity(0.0),
                    blurRadius: 20,
                  ),
                ],
                border: Border.all(
                  color: isSelected ? Colors.orange : Colors.transparent,
                  width: 3,
                ),
                ),
                child: template.imageUrl.isNotEmpty
                    ? Image.network(
                        template.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.broken_image, color: Colors.red, size: 80),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.image, color: Colors.white, size: 80),
                      ),
              ),
            ),
            if (isSelected)
              Positioned(
                top: 12,
                right: 12,
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 18,
                  child: const Icon(Icons.check, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSelectedTemplatesDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Selected UIs',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedTemplates.isEmpty)
                const Text(
                  'No UI selected.',
                  style: TextStyle(color: Colors.white70),
                ),
              if (_selectedTemplates.isNotEmpty)
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _selectedTemplates.length,
                    itemBuilder: (context, index) {
                      final template = _selectedTemplates[index];
                      return Card(
                        color: Colors.grey[850],
                        child: ListTile(
                          leading:
                              template.imageUrl.isNotEmpty
                                  ? Image.network(
                                    template.imageUrl,
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  )
                                  : const Icon(
                                    Icons.image,
                                    color: Colors.white,
                                  ),
                          title: Text(
                            template.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            template.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                _selectedTemplates.removeAt(index);
                              });
                              Navigator.pop(context);
                              _showSelectedTemplatesDrawer();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.cancel, color: Colors.black),
                    label: Text(
                      'CANCEL',
                      style: GoogleFonts.plusJakartaSans(color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.send, color: Colors.black),
                    label: Text(
                      'SEND',
                      style: GoogleFonts.plusJakartaSans(color: Colors.black),
                    ),
                    onPressed: () async {
                      final userProvider = Provider.of<UserProvider>(
                        context,
                        listen: false,
                      );
                      final token = userProvider.user?.token ?? '';

                      showToast(
                        context,
                        'Sending templates! Please wait, this may take a while...',
                      );

                      final success =
                          await FinalizeTemplatesService.finalizeTemplates(
                            token: token,
                            templates: List<TemplateDTO>.from(
                              _selectedTemplates,
                            ),
                          );

                      Navigator.pop(context);

                      if (success) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Material(
                                  color: Colors.transparent,
                                  child: PromptScreen(),
                                ),
                          ),
                        );
                      } else {
                        showToast(
                          context,
                          'Failed to send templates. Please try again.',
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.orange,
        icon: const Icon(Icons.list),
        label: Text('Selected (${_selectedTemplates.length})'),
        onPressed: _showSelectedTemplatesDrawer,
      ),
      body: SafeArea(
        child: Consumer<TemplateProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return Center(
                child: ColorFiltered(
                  colorFilter: const ColorFilter.mode(
                    Color(0xFFFF9900),
                    BlendMode.modulate,
                  ),
                  child: Lottie.asset('assets/anims/loading.json'),
                ),
              );
            }
            if (provider.error != null) {
              return Center(
                child: Text(
                  provider.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final mobileTemplates =
                provider.templates
                    .where((t) => t.templateType.toLowerCase() == 'mobile')
                    .toList();
            final desktopTemplates =
                provider.templates
                    .where((t) => t.templateType.toLowerCase() == 'desktop')
                    .toList();

            final isMobileTab = _tabController.index == 0;
            final templates = isMobileTab ? mobileTemplates : desktopTemplates;
            final currentIndex = isMobileTab ? mobileIndex : desktopIndex;

            return Center(
              child: FadeIn(
                duration: const Duration(milliseconds: 700),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 320,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        labelColor: const Color.fromARGB(255, 255, 30, 30),
                        unselectedLabelColor: Colors.white54,
                        indicator: GradientUnderlineTabIndicator(
                          gradient: const LinearGradient(
                            colors: [Colors.orange, Colors.pinkAccent],
                          ),
                        ),
                        onTap: (_) => setState(() {}),
                        tabs: const [
                          Tab(text: "Mobile App"),
                          Tab(text: "Desktop"),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (templates.isEmpty)
                      const Text(
                        'No templates found',
                        style: TextStyle(color: Colors.white),
                      ),
                    // ... inside your build method, replace the Row with this:
                    if (templates.isNotEmpty)
                      SizedBox(
                        width: 320,
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Preview card in the center
                                _buildPreview(
                                  templates[currentIndex],
                                  _selectedTemplates.any(
                                    (t) =>
                                        t.templateId ==
                                        templates[currentIndex].templateId,
                                  ),
                                ),
                                // Left arrow
                                Positioned(
                                  left: 0,
                                  child: GestureDetector(
                                    onTap:
                                        () => _changeScreen(
                                          false,
                                          templates.length,
                                        ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/images/arrow_left.png',
                                        height: 32,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.chevron_left,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Right arrow
                                Positioned(
                                  right: 0,
                                  child: GestureDetector(
                                    onTap:
                                        () => _changeScreen(
                                          true,
                                          templates.length,
                                        ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.7),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Image.asset(
                                        'assets/images/arrow_right.png',
                                        height: 32,
                                        errorBuilder:
                                            (_, __, ___) => const Icon(
                                              Icons.chevron_right,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            Text(
                              templates[currentIndex].name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: 260,
                              child: Text(
                                templates[currentIndex].description,
                                style: const TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    _selectedTemplates.any(
                                          (t) =>
                                              t.templateId ==
                                              templates[currentIndex]
                                                  .templateId,
                                        )
                                        ? Colors.orange
                                        : Colors.grey[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(120, 44),
                              ),
                              onPressed:
                                  () =>
                                      _toggleTemplate(templates[currentIndex]),
                              child: Text(
                                _selectedTemplates.any(
                                      (t) =>
                                          t.templateId ==
                                          templates[currentIndex].templateId,
                                    )
                                    ? 'Selected'
                                    : 'Select',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class GradientUnderlineTabIndicator extends Decoration {
  final LinearGradient gradient;
  final double strokeWidth;

  const GradientUnderlineTabIndicator({
    required this.gradient,
    this.strokeWidth = 3.0,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _GradientUnderlinePainter(gradient, strokeWidth);
  }
}

class _GradientUnderlinePainter extends BoxPainter {
  final LinearGradient gradient;
  final double strokeWidth;

  _GradientUnderlinePainter(this.gradient, this.strokeWidth);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration config) {
    final paint =
        Paint()
          ..shader = gradient.createShader(
            Rect.fromLTWH(
              offset.dx,
              offset.dy,
              config.size!.width,
              strokeWidth,
            ),
          )
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke;

    final y = offset.dy + config.size!.height - strokeWidth / 2;
    canvas.drawLine(
      Offset(offset.dx, y),
      Offset(offset.dx + config.size!.width, y),
      paint,
    );
  }
}
