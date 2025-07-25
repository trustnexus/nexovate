import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:nexovate/src/models/questions/faq_dto.dart';
import 'package:nexovate/src/providers/faq.dart';
import 'package:nexovate/src/providers/user.dart';
import 'package:provider/provider.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token =
          Provider.of<UserProvider>(context, listen: false).user?.token;
      if (token == null || token.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('User not authenticated')));
        return;
      }
      Provider.of<FaqProvider>(context, listen: false).fetchFaqs(token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(''),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/N_log.png',
              width: 32,
              height: 32,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Center(
            child: ShaderMask(
              shaderCallback:
                  (bounds) => const LinearGradient(
                    colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
                  ).createShader(
                    Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                  ),
              blendMode: BlendMode.srcIn,
              child: const Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Consumer<FaqProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                    child: Lottie.asset(
                      'assets/anims/loading.json',
                      width: 100,
                    ),
                  );
                }

                if (provider.error != null) {
                  return Center(
                    child: Text(
                      'Error: ${provider.error}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: provider.faqs.length,
                  itemBuilder: (context, index) {
                    return FAQListItem(faqItem: provider.faqs[index]);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class FAQListItem extends StatefulWidget {
  final FaqDTO faqItem;

  const FAQListItem({super.key, required this.faqItem});

  @override
  State<FAQListItem> createState() => _FAQListItemState();
}

class _FAQListItemState extends State<FAQListItem>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              _expanded = !_expanded;
              _expanded
                  ? _animationController.forward()
                  : _animationController.reverse();
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                Image.asset('assets/images/bullet.png', width: 10, height: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.faqItem.question,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Image.asset(
                    'assets/images/arrow.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        SizeTransition(
          sizeFactor: _animation,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(36, 0, 16, 16),
            child: Text(
              widget.faqItem.answer,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ),
        ),
        Divider(color: Colors.grey[900], height: 1),
      ],
    );
  }
}
