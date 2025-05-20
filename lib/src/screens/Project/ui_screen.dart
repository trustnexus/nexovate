import 'package:flutter/material.dart';
import 'package:nexovate/src/screens/utils/questionnaire_storage.dart';

class UIProjectScreen extends StatelessWidget {
  final SavedProject project;

  const UIProjectScreen({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Project UI Preview", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.pinkAccent),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Image.asset('assets/images/N_log.png', height: 28),
          )
        ],
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildSectionHeader("Selected Project Type"),
            _buildPreviewCard(project.selectedAnswers[0], icon: Icons.device_hub),

            const SizedBox(height: 20),
            _buildSectionHeader("Target Platform"),
            _buildPreviewCard(project.selectedAnswers[1], icon: Icons.devices),

            const SizedBox(height: 20),
            _buildSectionHeader("Timeline & Support"),
            _buildPreviewCard("${project.selectedAnswers[2]} | Support: ${project.selectedAnswers[3]}", icon: Icons.schedule),

            const SizedBox(height: 20),
            _buildSectionHeader("Tech Stack"),
            _buildTechStackRow("Frontend", project.frontend, Colors.deepPurple),
            _buildTechStackRow("Backend", project.backend, Colors.teal),
            _buildTechStackRow("Database", project.database, Colors.indigo),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.orange, Colors.pinkAccent],
        ).createShader(bounds),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildPreviewCard(String text, {required IconData icon}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey[900],
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.orangeAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white70, fontSize: 14, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechStackRow(String label, String value, Color color) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          Text(
            "$label:",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontFamily: 'Poppins'),
            ),
          ),
        ],
      ),
    );
  }
}
