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
  "What is the name of your project?",
  "What is the primary purpose of your project?",
  "What type of project are you building?",
  "Who are the intended users of this project?",
  "What is the expected number of users?",
  "Which essential features should be included?",
  "What admin functionalities do you require?",
  "What is your preferred development approach in terms of cost?",
  "Which platform do you prefer for building this project?",
  "What is your estimated budget for this project?",
  "What is your expected project timeline?",
  "What level of data protection or compliance is required?",
  "Is offline access required for your project?",
  "What third-party services or integrations do you need?",
  "What kind of post-launch support do you require?",
];


final List<List<String>> options = [
  ["Custom Input"], // For 1.1 (Project Name) – handle as TextField
  ["Online Store", "Social Platform", "Business Management Tool", "Informational Website", "Other"],
  ["Website", "Mobile App (Android)", "Mobile App (iOS)", "Mobile App (Both)", "Desktop Software", "Hybrid"],
  ["General Public", "Business Customers", "Employees/Staff", "Students", "Other"],
  ["Less than 1,000", "1,000 - 10,000", "More than 10,000"],
  ["User Accounts", "Online Payments", "Messaging/Chat", "File Uploads", "Basic Analytics", "Other"],
  ["Dashboard", "User Management", "Content Approval"],
  ["Open-Source Technologies", "Custom Solution"],
  ["WordPress", "Laravel", "Flutter", "No Preference"],
  ["Under Rs. 20,000", "Rs. 20,000 – 50,000", "Rs. 50,000- 1,000,000", "Over Rs. 1,000,000"],
  ["1-3 Months", "3-6 Months", "6+ Months"],
  ["Basic Privacy Policy", "GDPR Compliance", "PCI Compliance", "Not Applicable"],
  ["Required", "Not Needed"],
  ["Payment Gateway (JazzCash, EasyPaisa)", "SMS Notifications", "Google Maps", "Other"],
  ["Basic Maintenance Package", "One-Time Delivery"],
];

final Map<int, TextEditingController> customInputs = {}; // for custom/other input

  @override
  void initState() {
    super.initState();
    selectedOptions = List.filled(questions.length, null); // ✅ Initialize here
  }

  List<int?> selectedOptions = List.filled(15, null);
  bool isQuizCompleted = false;

  void _onRestartQuiz() {
    setState(() {
      selectedOptions = List.filled(15, null);
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
    itemCount: options[index].length + 1, // +1 for the conditional TextField
    itemBuilder: (context, optionIndex) {
      // 🟠 Handle dynamic text field separately
      if (optionIndex == options[index].length) {
        final selectedText = options[index][selectedOptions[index] ?? 0];
        if ((selectedText == "Custom Input" || selectedText == "Other")) {
          customInputs.putIfAbsent(index, () => TextEditingController());

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: TextField(
              controller: customInputs[index],
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your custom input here...",
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.black12,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.orangeAccent),
                ),
              ),
              onChanged: (value) {
                setState(() {}); // rebuild on input
              },
            ),
          );
        } else {
          return const SizedBox.shrink(); // no field
        }
      }

      // 🟢 Regular option button
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
          padding: const EdgeInsets.all(2.5),
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
          String frontend = "";
String backend = "";
String database = "";

final type = options[2][selectedOptions[2] ?? 0];
final platform = options[8][selectedOptions[8] ?? 0];
final budget = options[9][selectedOptions[9] ?? 0];
final devApproach = options[7][selectedOptions[7] ?? 0];
final features = [options[5][selectedOptions[5] ?? 0]];
final compliance = options[11][selectedOptions[11] ?? 0];

if (platform == "Flutter") {
  frontend = "Flutter";
  backend = "Firebase";
  database = "Firestore";
} else if (platform == "Laravel") {
  frontend = "HTML/CSS/JS";
  backend = "PHP Laravel";
  database = "MySQL";
} else if (platform == "WordPress") {
  frontend = "WordPress";
  backend = "PHP (WordPress API)";
  database = "MySQL";
} else {
  // Dynamic fallback logic
  if (type.contains("Mobile")) {
    frontend = "Flutter";
    backend = devApproach == "Open-Source Technologies" ? "Node.js" : "Firebase";
  } else {
    frontend = "React.js";
    backend = devApproach == "Open-Source Technologies" ? "Node.js" : "Django";
  }

  database = compliance == "GDPR Compliance" ? "PostgreSQL" : "MongoDB";
}


          // 📝 Save the project locally
          final answers = List<String>.generate(questions.length, (i) {
  final selectedIndex = selectedOptions[i] ?? 0;
  final selectedValue = options[i][selectedIndex];

  if ((selectedValue == "Custom Input" || selectedValue == "Other") &&
      customInputs[i]?.text.trim().isNotEmpty == true) {
    return customInputs[i]!.text.trim(); // 🟢 Save the custom text
  } else {
    return selectedValue;
  }
});

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
  String frontend = "";
String backend = "";
String database = "";

final type = options[2][selectedOptions[2] ?? 0];
final platform = options[8][selectedOptions[8] ?? 0];
final budget = options[9][selectedOptions[9] ?? 0];
final devApproach = options[7][selectedOptions[7] ?? 0];
final features = [options[5][selectedOptions[5] ?? 0]];
final compliance = options[11][selectedOptions[11] ?? 0];

if (platform == "Flutter") {
  frontend = "Flutter";
  backend = "Firebase";
  database = "Firestore";
} else if (platform == "Laravel") {
  frontend = "HTML/CSS/JS";
  backend = "PHP Laravel";
  database = "MySQL";
} else if (platform == "WordPress") {
  frontend = "WordPress";
  backend = "PHP (WordPress API)";
  database = "MySQL";
} else {
  // Dynamic fallback logic
  if (type.contains("Mobile")) {
    frontend = "Flutter";
    backend = devApproach == "Open-Source Technologies" ? "Node.js" : "Firebase";
  } else {
    frontend = "React.js";
    backend = devApproach == "Open-Source Technologies" ? "Node.js" : "Django";
  }

  database = compliance == "GDPR Compliance" ? "PostgreSQL" : "MongoDB";
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

        _buildActionButton("Save to My Projects", () async {

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