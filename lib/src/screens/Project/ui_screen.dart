import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:nexovate/src/screens/utils/questionnaire_storage.dart';

class UIProjectScreen extends StatefulWidget {
  final SavedProject project;
  const UIProjectScreen({super.key, required this.project});

  @override
  State<UIProjectScreen> createState() => _UIProjectScreenState();
}

class _UIProjectScreenState extends State<UIProjectScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int mobileIndex = 0;
  int desktopIndex = 0;

  final List<String> mobileScreens = [
    'assets/images/mobile_ui_1.png',
    'assets/images/mobile_ui_2.png',
    'assets/images/mobile_ui_3.png',
  ];

  final List<String> desktopScreens = [
    'assets/images/desktop_ui_1.png',
    'assets/images/desktop_ui_2.png',
    'assets/images/desktop_ui_3.png',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

bool _isNext = true;

void _changeScreen(bool isNext) {
  _isNext = isNext; // 🔁 Track direction
  if (_tabController.index == 0) {
    setState(() {
      mobileIndex = (mobileIndex + (isNext ? 1 : -1)) % mobileScreens.length;
      if (mobileIndex < 0) mobileIndex += mobileScreens.length;
    });
  } else {
    setState(() {
      desktopIndex = (desktopIndex + (isNext ? 1 : -1)) % desktopScreens.length;
      if (desktopIndex < 0) desktopIndex += desktopScreens.length;
    });
  }
}


Widget _buildPreview(String imagePath) {
  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 500),
    transitionBuilder: (child, animation) {
      final offsetTween = Tween<Offset>(
        begin: Offset(_isNext ? 1.0 : -1.0, 0),
        end: Offset.zero,
      );

      final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      final slide = offsetTween.animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut,
      ));

      return FadeTransition(
        opacity: fade,
        child: SlideTransition(position: slide, child: child),
      );
    },
    child: GestureDetector(
      key: ValueKey(imagePath),
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => FullscreenImage(imagePath: imagePath),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(anim),
              child: child,
            ),
          ),
        ),
      ),
      child: Hero(
        tag: imagePath,
        child: Container(
          width: 280,
          height: 500,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
            boxShadow: [
              BoxShadow(color: Colors.orange.withOpacity(0), blurRadius: 20),
            ],
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}
  Widget _gradientTitle(String text) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
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

  @override
  Widget build(BuildContext context) {
    final currentImage = _tabController.index == 0
        ? mobileScreens[mobileIndex]
        : desktopScreens[desktopIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: FadeIn(
            duration: const Duration(milliseconds: 700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  child: Stack(
    alignment: Alignment.center,
    children: [
      Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.pinkAccent, size: 18),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      _gradientTitle("Sample UI"),
      Positioned(
        right: 0,
        child: Image.asset('assets/images/N_log.png', height: 28),
      ),
    ],
  ),
),
                const SizedBox(height: 10),
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
                      gradient: const LinearGradient(colors: [Colors.orange, Colors.pinkAccent]),
                    ),
                    onTap: (_) => setState(() {}),
                    tabs: const [
                      Tab(text: "Mobile App"),
                      Tab(text: "Desktop"),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => _changeScreen(false),
                      child: Image.asset(
                        'assets/images/arrow_left.png',
                        height: 40,
                        errorBuilder: (_, __, ___) => const Icon(Icons.chevron_left, color: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 15),
                    _buildPreview(currentImage),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () => _changeScreen(true),
                      child: Image.asset(
                        'assets/images/arrow_right.png',
                        height: 40,
                        errorBuilder: (_, __, ___) => const Icon(Icons.chevron_right, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FullscreenImage extends StatelessWidget {
  final String imagePath;
  const FullscreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: imagePath,
              child: InteractiveViewer(
                child: Image.asset(imagePath),
              ),
            ),
          ),
          Positioned(
  top: 40,
  left: 16,
  child: GestureDetector(
    onTap: () => Navigator.pop(context),
    child: Container(
      padding: const EdgeInsets.all(12),
    
      child: const Icon(
        Icons.close,
        size: 24,
        color: Color.fromARGB(255, 247, 173, 13), // Contrast against yellow
      ),
    ),
  ),
),
        ],
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
    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(offset.dx, offset.dy, config.size!.width, strokeWidth),
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
