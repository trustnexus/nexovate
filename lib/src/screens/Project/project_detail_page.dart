import 'package:flutter/material.dart';
import 'package:nexovate/src/screens/utils/questionnaire_storage.dart';

class ProjectDetailPage extends StatelessWidget {
  final SavedProject project;

  const ProjectDetailPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Project Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.pinkAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              "Your Answers",
              style: TextStyle(color: Colors.orange, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            for (int i = 0; i < project.questions.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  "${project.questions[i]}: ${project.selectedAnswers[i]}",
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            const Divider(color: Colors.pinkAccent, height: 30),
            const Text("Recommended Tech Stack", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text("Frontend: ${project.frontend}", style: const TextStyle(color: Colors.white70)),
            Text("Backend: ${project.backend}", style: const TextStyle(color: Colors.white70)),
            Text("Database: ${project.database}", style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
