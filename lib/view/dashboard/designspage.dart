import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:admin_demo/viewmodel/notifiers/thememode.dart';
import 'package:admin_demo/utils/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class DesignsPage extends StatefulWidget {
  const DesignsPage({super.key});

  @override
  State<DesignsPage> createState() => _DesignsPageState();
}

class _DesignsPageState extends State<DesignsPage> with TickerProviderStateMixin {
  static const String ellipseAsset = 'assets/images/ellipse_bg.svg';
  static const String lineAsset = 'assets/images/line_svg.svg';

  final List<String> _mobileDesignImages = [
    'https://i.postimg.cc/dtTZgZ0T/Mob1.webp',
    'https://i.postimg.cc/j262dPn8/Mob2.webp',
    'https://i.postimg.cc/vZ01Vrqk/Mob3.webp',
  ];

  final List<String> _desktopDesignImages = [
    'https://i.postimg.cc/FHHzNfrZ/Desktop1.webp',
    'https://i.postimg.cc/44vxcvnP/Desktop2.webp',
    'https://i.postimg.cc/VvFscw2p/desktop3.webp',
  ];

  final TextEditingController _imageUrlController = TextEditingController();

  bool _showMobileDesigns = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isLoading) {
      _preloadImages().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future<void> _preloadImages() async {
    await Future.wait(_mobileDesignImages.map((url) => precacheImage(NetworkImage(url), context)));
    await Future.wait(_desktopDesignImages.map((url) => precacheImage(NetworkImage(url), context)));
  }

  void _showImageDialog(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => Container(
              padding: const EdgeInsets.all(40),
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }

  void _deleteDesign(int index, bool isMobile) {
    setState(() {
      if (isMobile) {
        _mobileDesignImages.removeAt(index);
      } else {
        _desktopDesignImages.removeAt(index);
      }
    });
  }

  void _showAddDesignDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer<ThemeModeProvider>(
          builder: (context, provider, child) {
            final isDark = provider.isDarkMode;
            final colors = isDark ? AppColors.dark : AppColors.light;
            final borderColor = colors['borderColor'] as Color;
            final textColor = colors['textColor'] as Color;
            final dialogBg = isDark ? Colors.grey[900] : Colors.white;

            return SlideInUp(
              duration: const Duration(milliseconds: 500),
              child: AlertDialog(
                backgroundColor: dialogBg,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                title: Text(
                  'Add New Design',
                  style: GoogleFonts.plusJakartaSans(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _imageUrlController,
                      decoration: InputDecoration(
                        labelText: 'Image URL',
                        labelStyle: TextStyle(color: textColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: borderColor, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      style: TextStyle(color: textColor),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.amber : const Color(0xFFFF2553),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              final url = Uri.parse('https://postimages.org/');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              }
                            },
                            icon: const Icon(Icons.open_in_browser, color: Colors.white),
                            label: const Text('Post Images', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.teal : Colors.blue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              final url = _imageUrlController.text.trim();
                              if (url.isNotEmpty) {
                                setState(() {
                                  if (_showMobileDesigns) {
                                    _mobileDesignImages.add(url);
                                  } else {
                                    _desktopDesignImages.add(url);
                                  }
                                });
                                _imageUrlController.clear();
                                Navigator.of(context).pop();
                              }
                            },
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(
      builder: (context, provider, child) {
        final isDark = provider.isDarkMode;
        final colors = isDark ? AppColors.dark : AppColors.light;
        final borderColor = colors['borderColor'] as Color;
        final textColor = colors['textColor'] as Color;
        final deleteIconColor = colors['deleteIconColor'] as Color;

        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned(
                top: -80,
                left: -120,
                child: SvgPicture.asset(ellipseAsset, height: 220, width: 220),
              ),
              Positioned(
                bottom: -100,
                right: -140,
                child: SvgPicture.asset(ellipseAsset, height: 300, width: 300),
              ),
              if (_isLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF2553)),
                  ),
                )
              else
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                    
                    
                    SvgPicture.asset(lineAsset, height: 5, width: 400),
                    
                    const SizedBox(height: 24),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeInOut,
                      child: Row(
                        key: ValueKey(_showMobileDesigns),
                        children: [
                          Text(
                            'Designs',
                            style: GoogleFonts.plusJakartaSans(
                              color: textColor,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey[800] : Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ToggleButtons(
                              isSelected: [_showMobileDesigns, !_showMobileDesigns],
                              onPressed: (int index) {
                                setState(() {
                                  _showMobileDesigns = index == 0;
                                });
                              },
                              borderRadius: BorderRadius.circular(12),
                              selectedColor: Colors.white,
                              color: textColor,
                              fillColor: const Color(0xFFFF2553),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              borderWidth: 0,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text('Mobile', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  child: Text('Desktop', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.amber : const Color(0xFFFF2553),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _showAddDesignDialog,
                            icon: const Icon(Icons.add, color: Colors.white),
                            label: const Text('Add New Design', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInOut,
                        child: AnimationLimiter(
                          key: ValueKey(_showMobileDesigns), // Key to trigger re-render on toggle
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: (_showMobileDesigns ? _mobileDesignImages : _desktopDesignImages).length,
                            itemBuilder: (context, index) {
                              final imageUrl = (_showMobileDesigns ? _mobileDesignImages : _desktopDesignImages)[index];
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                delay: Duration(milliseconds: index * 100),
                                duration: const Duration(milliseconds: 200),
                                child: SlideAnimation(
                                  horizontalOffset: 300.0,
                                  child: FadeInAnimation(
                                    child: GestureDetector(
                                      onTap: () => _showImageDialog(imageUrl),
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 12),
                                        width: 260,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(18),
                                          image: DecorationImage(
                                            image: NetworkImage(imageUrl),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) {},
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 12,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(child: Container()),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.5),
                                                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(18)),
                                              ),
                                              padding: const EdgeInsets.all(12),
                                              child: Row(
                                                children: [
                                                  RotatedBox(
                                                    quarterTurns: -1,
                                                    child: Text(
                                                      'Design ${index + 1}',
                                                      style: GoogleFonts.plusJakartaSans(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  const Spacer(),
                                                  IconButton(
                                                    icon: Icon(Icons.delete, color: deleteIconColor),
                                                    tooltip: 'Delete Design',
                                                    onPressed: () => _deleteDesign(index, _showMobileDesigns),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
