import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final List<_ToastData> _toastQueue = [];
OverlayEntry? _toastOverlay;

const double _baseTopOffset = 60.0;
const double _toastHeight = 70.0;
const double _toastGap = 12.0;

void showToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);

  _toastQueue.add(_ToastData(message: message));

  _showOverlay(overlay);
}

void _showOverlay(OverlayState overlay) {
  if (_toastOverlay != null) {
    _toastOverlay!.markNeedsBuild();
    return;
  }

  _toastOverlay = OverlayEntry(
    builder: (context) {
      return Positioned.fill(
        child: IgnorePointer(
          child: Stack(
            children: [
              for (int i = 0; i < _toastQueue.length; i++)
                _ToastWidget(
                  key: _toastQueue[i].key,
                  message: _toastQueue[i].message,
                  offset: _baseTopOffset + i * (_toastHeight + _toastGap),
                  onDismiss: () {
                    _toastQueue.removeAt(i);
                    if (_toastQueue.isEmpty) {
                      _toastOverlay?.remove();
                      _toastOverlay = null;
                    } else {
                      _toastOverlay?.markNeedsBuild();
                    }
                  },
                ),
            ],
          ),
        ),
      );
    },
  );

  overlay.insert(_toastOverlay!);
}

class _ToastData {
  final String message;
  final GlobalKey<_ToastWidgetState> key;

  _ToastData({required this.message}) : key = GlobalKey<_ToastWidgetState>();
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final double offset;
  final VoidCallback onDismiss;

  const _ToastWidget({
    super.key,
    required this.message,
    required this.offset,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      top: widget.offset,
      left: 24,
      right: 24,
      child: FadeTransition(
      opacity: _opacity,
      child: Material(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
        child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
          colors: [
            Colors.amber,
            Colors.pink,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
            widget.message,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            ),
          ),
          ],
        ),
        ),
      ),
      ),
    );
  }
}
