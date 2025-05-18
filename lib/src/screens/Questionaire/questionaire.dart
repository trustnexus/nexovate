import 'package:nexovate/src/screens/utils/questionnaire_storage.dart';
// Enhanced version of QuestionnaireScreen with dynamic scope document generation
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:nexovate/src/screens/utils/sidebar_navigation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart'; // 👈 REQUIRED for rootBundle
import 'package:nexovate/src/screens/Project/saved_project.dart';

class QuestionnaireScreen extends StatefulWidget {
  const QuestionnaireScreen({super.key});

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  final PageController _controller = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<String> questions = [
    "What kind of software project are you interested in developing?",
    "Which platform do you prefer?",
    "What's your preferred development timeline?",
    "Do you require ongoing support?",
    "Which technologies do you prefer for development?"
  ];

  final List<List<String>> options = [
    [
      "Mobile App (Android/iOS)",
      "Web Application",
      "Desktop Software",
      "E-commerce Platform",
      "Management System",
      "Game Development",
      "AI/ML-Based Application"
    ],
    ["Android", "iOS", "Cross-platform", "Web", "Desktop"],
    ["Less than 1 month", "1-3 months", "3-6 months", "6+ months"],
    ["Yes", "No", "Not Sure"],
    ["Flutter", "React Native", "Django", "Node.js", "Java", "PHP", "Other"]
  ];

  List<int?> selectedOptions = List.filled(5, null);
  bool isQuizCompleted = false;
  pw.Widget _buildTechRow(String title, String value, PdfColor color) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 90,
          child: pw.Text(
            "$title:",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: color),
          ),
        ),
        pw.Expanded(
          child: pw.Text(value),
        ),
      ],
    ),
  );
}

Future<pw.ImageProvider> _loadBullet() async {
  final data = await rootBundle.load('assets/images/bullet.png');
  return pw.MemoryImage(data.buffer.asUint8List());
}

pw.Font? poppinsRegular;
pw.Font? poppinsBold;

Future<void> _loadFonts() async {
  if (poppinsRegular == null) {
    poppinsRegular = pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Regular.ttf'));
  }
  if (poppinsBold == null) {
    poppinsBold = pw.Font.ttf(await rootBundle.load('assets/fonts/Poppins-Bold.ttf'));
  }
}


Future<pw.ImageProvider> _loadLogo() async {
    final logoData = await rootBundle.load('assets/images/N_log.png');
    return pw.MemoryImage(logoData.buffer.asUint8List());
  }

Future<void> _onDownloadScopeDocument() async {
  try {
    final pdf = pw.Document();
    await _loadFonts();
    String frontend = "JavaScript";
    String backend = "Python";
    String database = "MySQL SQLserver";

    final selectedTech = options[4][selectedOptions[4] ?? 0].toLowerCase();
    if (selectedTech.contains("flutter") || selectedTech.contains("react")) {
      frontend = selectedTech.contains("flutter") ? "Flutter" : "React Native";
      backend = "Firebase";
      database = "Firestore";
    } else if (selectedTech.contains("django") || selectedTech.contains("node")) {
      frontend = "JavaScript";
      backend = selectedTech.contains("django") ? "Django (Python)" : "Node.js";
      database = "MongoDB";
    } else if (selectedTech.contains("java")) {
      frontend = "JavaFX / JSP";
      backend = "Spring Boot";
      database = "PostgreSQL";
    } else if (selectedTech.contains("php")) {
      frontend = "HTML/CSS/JS";
      backend = "PHP Laravel";
      database = "MySQL";
    }

    print("Generating PDF...");
    print("Frontend: $frontend | Backend: $backend | Database: $database");

    final logo = await _loadLogo();
final bullet = await _loadBullet();

pdf.addPage(
  pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (context) {
      return pw.Container(
        color: PdfColors.grey200,
        padding: const pw.EdgeInsets.all(24),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Nexovate", style: pw.TextStyle(font: poppinsBold, fontSize: 22, color: PdfColors.deepOrange)),
                    pw.Text("Project Scope Document", style: pw.TextStyle(font: poppinsRegular, fontSize: 14)),
                  ],
                ),
                pw.Image(logo, width: 50),
              ],
            ),

            pw.Divider(thickness: 1),
            pw.SizedBox(height: 20),

            // Summary
            pw.Text("Project Summary", style: pw.TextStyle(font: poppinsBold, fontSize: 18)),
            pw.SizedBox(height: 10),
            for (int i = 0; i < questions.length; i++)
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.RichText(
                  text: pw.TextSpan(
                    children: [
                      pw.TextSpan(
                        text: "${i + 1}. ${questions[i]}\n",
                        style: pw.TextStyle(font: poppinsBold, fontSize: 12),
                      ),
                      pw.WidgetSpan(
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              width: 8,
                              height: 8,
                              margin: const pw.EdgeInsets.only(right: 6, top: 3),
                              child: pw.Image(bullet),
                            ),
                            pw.Expanded(
                              child: pw.Text(
                                options[i][selectedOptions[i] ?? 0],
                                style: pw.TextStyle(font: poppinsRegular, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),

            pw.SizedBox(height: 20),

            // Tech Stack
            pw.Text("Recommended Tech Stack", style: pw.TextStyle(font: poppinsBold, fontSize: 16, color: PdfColors.pink800)),
            pw.SizedBox(height: 10),
            _buildTechRow("Frontend", frontend, PdfColors.deepPurple),
            _buildTechRow("Backend", backend, PdfColors.teal),
            _buildTechRow("Database", database, PdfColors.indigo),

            pw.SizedBox(height: 20),

            // Notes
            pw.Text("Notes", style: pw.TextStyle(font: poppinsBold, fontSize: 14)),
            pw.SizedBox(height: 4),
            pw.Text(
              "This document outlines your preferences and suggests technologies for building your software project. "
              "It serves as a foundational scope to guide development.",
              style: pw.TextStyle(font: poppinsRegular, fontSize: 12),
            ),

            pw.Spacer(),
            pw.Divider(thickness: 0.5),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text("Generated by Nexovate", style: pw.TextStyle(fontSize: 10, font: poppinsRegular, color: PdfColors.grey600)),
            ),
          ],
        ),
      );
    },
  ),
);

    final output = await getApplicationDocumentsDirectory();
    final path = "${output.path}scope_document.pdf";
    final file = File(path);

    print("📂 Saving PDF to: $path");
    await file.writeAsBytes(await pdf.save());
    print("✅ PDF saved successfully.");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('📄 Scope document downloaded: $path')),
    );

    // 📝 Also save project data
    final answers = List<String>.generate(
      selectedOptions.length,
      (i) => options[i][selectedOptions[i] ?? 0],
    );

    await saveProjectLocally(
      questions: questions,
      answers: answers,
      frontend: frontend,
      backend: backend,
      database: database,
    );

    ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('📄 Scope document downloaded & project saved: $path')),
);

    // Optional: Open the file after generation (Windows, Mac, Linux only)
    if (Platform.isWindows) {
      await Process.run('explorer', [path]);
    } else if (Platform.isMacOS) {
      await Process.run('open', [path]);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [path]);
    }
  } catch (e) {
    print("❌ PDF generation error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to generate PDF. Check logs for details.')),
    );
  }
}

  void _onRestartQuiz() {
    setState(() {
      selectedOptions = List.filled(5, null);
      isQuizCompleted = false;
    });
    _controller.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
      body: isQuizCompleted
          ? buildFinalOptions()
          : PageView.builder(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: questions.length,
              itemBuilder: (context, index) => buildQuestionPage(index),
            ),
    );
  }

Widget buildQuestionPage(int index) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),

        // 🔘 Soft glowing step indicator
        TweenAnimationBuilder<double>(
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
        ),

        const SizedBox(height: 16),

        // 🧠 Gradient-bordered soft question box
        TweenAnimationBuilder<double>(
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
                    questions[index],
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
        ),

        const SizedBox(height: 30),

        // 🎯 Glowy Option List
Expanded(
  child: ListView.builder(
    itemCount: options[index].length,
    itemBuilder: (context, optionIndex) {
      final isSelected = selectedOptions[index] == optionIndex;
      return GestureDetector(
        onTap: () {
          setState(() {
            selectedOptions[index] = optionIndex;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.all(2.5), // border thickness
          decoration: isSelected
              ? BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pinkAccent.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                )
              : BoxDecoration(
                  border: Border.all(color: Colors.white24, width: 1),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text(
                options[index][optionIndex],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
        // 🔘 Animated gradient button
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: selectedOptions[index] != null ? 1 : 0.5,
          child: GestureDetector(
            onTap: selectedOptions[index] != null
    ? () async {
        if (index < questions.length - 1) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        } else {
          // Calculate tech stack before saving
          String frontend = "JavaScript";
          String backend = "Python";
          String database = "MySQL SQLserver";

          final selectedTech = options[4][selectedOptions[4] ?? 0].toLowerCase();
          if (selectedTech.contains("flutter") || selectedTech.contains("react")) {
            frontend = selectedTech.contains("flutter") ? "Flutter" : "React Native";
            backend = "Firebase";
            database = "Firestore";
          } else if (selectedTech.contains("django") || selectedTech.contains("node")) {
            frontend = "JavaScript";
            backend = selectedTech.contains("django") ? "Django (Python)" : "Node.js";
            database = "MongoDB";
          } else if (selectedTech.contains("java")) {
            frontend = "JavaFX / JSP";
            backend = "Spring Boot";
            database = "PostgreSQL";
          } else if (selectedTech.contains("php")) {
            frontend = "HTML/CSS/JS";
            backend = "PHP Laravel";
            database = "MySQL";
          }

          // 📝 Save the project locally
          final answers = List<String>.generate(
            selectedOptions.length,
            (i) => options[i][selectedOptions[i] ?? 0],
          );

          await saveProjectLocally(
            questions: questions,
            answers: answers,
            frontend: frontend,
            backend: backend,
            database: database,
          );

          setState(() => isQuizCompleted = true);
        }
      }
    : null,
            child: Container(
              width: double.infinity,
              height: 45,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                gradient: selectedOptions[index] != null
                    ? const LinearGradient(
                        colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
                      )
                    : null,
                color: selectedOptions[index] == null ? Colors.grey[800] : null,
                boxShadow: selectedOptions[index] != null
                    ? [
                        BoxShadow(
                          color: Colors.pinkAccent.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  index == questions.length - 1 ? "Submit" : "Next",
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

        const SizedBox(height: 24),
      ],
    ),
  );
}

 Widget buildFinalOptions() {
  String frontend = "JavaScript";
  String backend = "Python";
  String database = "MySQL SQLserver";

  final selectedTech = options[4][selectedOptions[4] ?? 0].toLowerCase();

  if (selectedTech.contains("flutter") || selectedTech.contains("react")) {
    frontend = selectedTech.contains("flutter") ? "Flutter" : "React Native";
    backend = "Firebase";
    database = "Firestore";
  } else if (selectedTech.contains("django") || selectedTech.contains("node")) {
    frontend = "JavaScript";
    backend = selectedTech.contains("django") ? "Django (Python)" : "Node.js";
    database = "MongoDB";
  } else if (selectedTech.contains("java")) {
    frontend = "JavaFX / JSP";
    backend = "Spring Boot";
    database = "PostgreSQL";
  } else if (selectedTech.contains("php")) {
    frontend = "HTML/CSS/JS";
    backend = "PHP Laravel";
    database = "MySQL";
  }

  return Padding(
    padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 20),

        const Text(
          "Project Requirements\nProcessed Successfully!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
          ),
        ),

        const SizedBox(height: 30),

        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color.fromARGB(255, 255, 153, 0), Color.fromARGB(255, 253, 0, 241)],
          ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
          child: const Text(
            "Recommended TechStack:",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
        ),

        const SizedBox(height: 28),

        _buildTechItem("Frontend:", frontend),
        _buildTechItem("Backend:", backend),
        _buildTechItem("Database:", database),

        const SizedBox(height: 40),

        const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.info_outline, color: Colors.white54, size: 18),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                "Click below to download Scope document.",
                style: TextStyle(color: Colors.white54, fontFamily: 'Poppins'),
              ),
            )
          ],
        ),

        const SizedBox(height: 24),

        _buildActionButton("Download", () async {
          await _onDownloadScopeDocument();

          // ✅ Navigate to Saved Projects after download
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SavedProjectsScreen()),
          );
        }),

        const SizedBox(height: 12),
        _buildActionButton("Restart", _onRestartQuiz),
      ],
    ),
  );
}

  Widget _buildTechItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Image.asset('assets/images/check.png', height: 20, width: 20), // ✅ Your tick icon
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButton(String label, VoidCallback onPressed) {
  return Center(
    child: Container(
      width: 200,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(25),
          onTap: onPressed,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
            ),
          ),
         ),
        ),
       ),
      ),
    );
  }
}