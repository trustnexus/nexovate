import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  final List<FAQItem> faqItems = [
    FAQItem(
      question: "What is a scope document?",
      answer: "A scope document defines the boundaries, requirements, deliverables, and key details of a project. It helps ensure all stakeholders have a clear understanding of what the project will and won't include.",
    ),
    FAQItem(
      question: "How do I use this with my dev team?",
      answer: "Share the document with your development team during project planning. Review it together to ensure everyone understands the requirements, timeline, and deliverables. Use it as a reference point throughout the development process.",
    ),
    FAQItem(
      question: "What if I don't know technical terms?",
      answer: "Don't worry! You can describe your needs in plain language. Our team can help translate your requirements into technical specifications. It's more important to clearly communicate what you want the application to do than to use technical jargon.",
    ),
    FAQItem(
      question: "What is a scope document?",
      answer: "A scope document defines the boundaries, requirements, deliverables, and key details of a project. It helps ensure all stakeholders have a clear understanding of what the project will and won't include.",
    ),
    FAQItem(
      question: "How do I use this with my dev team?",
      answer: "Share the document with your development team during project planning. Review it together to ensure everyone understands the requirements, timeline, and deliverables. Use it as a reference point throughout the development process.",
    ),
    FAQItem(
      question: "What if I don't know technical terms?",
      answer: "Don't worry! You can describe your needs in plain language. Our team can help translate your requirements into technical specifications. It's more important to clearly communicate what you want the application to do than to use technical jargon.",
    ),
    FAQItem(
      question: "What is a scope document?",
      answer: "A scope document defines the boundaries, requirements, deliverables, and key details of a project. It helps ensure all stakeholders have a clear understanding of what the project will and won't include.",
    ),
    FAQItem(
      question: "How do I use this with my dev team?",
      answer: "Share the document with your development team during project planning. Review it together to ensure everyone understands the requirements, timeline, and deliverables. Use it as a reference point throughout the development process.",
    ),
  ];

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
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
                    ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
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
            child: ListView.builder(
              itemCount: faqItems.length,
              itemBuilder: (context, index) {
                return FAQListItem(faqItem: faqItems[index]);
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}

class FAQListItem extends StatefulWidget {
  final FAQItem faqItem;

  const FAQListItem({super.key, required this.faqItem});

  @override
  _FAQListItemState createState() => _FAQListItemState();
}

class _FAQListItemState extends State<FAQListItem> with SingleTickerProviderStateMixin {
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
              if (_expanded) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Image.asset('assets/images/bullet.png', width: 10, height: 10),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.faqItem.question,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
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
                )
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
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ),
        ),
        Divider(
          color: Colors.grey[900],
          height: 1,
        ),
      ],
    );
  }
}
