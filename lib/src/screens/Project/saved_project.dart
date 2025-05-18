import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nexovate/src/screens/utils/questionnaire_storage.dart';
import 'package:nexovate/src/screens/Project/project_detail_page.dart';

class SavedProjectsScreen extends StatelessWidget {
  const SavedProjectsScreen({super.key});

  Future<List<SavedProject>> _loadProjects() async {
    return await loadSavedProjects();
  }

  Future<void> _deleteProject(String id, BuildContext context) async {
    final allProjects = await loadSavedProjects();
    final updatedList = allProjects.where((p) => p.id != id).toList();
    await saveAllProjects(updatedList);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Project deleted")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: FutureBuilder<List<SavedProject>>(
                future: _loadProjects(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator(color: Colors.pinkAccent));
                  }

                  final projects = snapshot.data!;
                  if (projects.isEmpty) {
                    return const Center(child: Text("No saved projects.", style: TextStyle(color: Colors.white70)));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: projects.length,
                    itemBuilder: (context, index) {
                      final project = projects[index];
                      return _buildAnimatedCard(project, context, index);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const BackButton(color: Colors.pinkAccent),
          const Expanded(
            child: Text(
              "Saved Projects",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
            ),
          ),
          Image.asset('assets/images/N_log.png', height: 28),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(SavedProject project, BuildContext context, int index) {
    final timestamp = DateFormat('MMM d, yyyy – h:mm a').format(project.timestamp);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + index * 100),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 20),
            child: child!,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ProjectDetailPage(project: project)),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 14),
          color: Colors.grey[900],
          child: ListTile(
            leading: Image.asset('assets/images/N_log.png', height: 40),
            title: Text(project.selectedAnswers[0], style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
            subtitle: Text("Created: $timestamp", style: const TextStyle(color: Colors.white60, fontSize: 12)),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.pinkAccent),
              onPressed: () async {
                await _deleteProject(project.id, context);
                (context as Element).reassemble();
              },
            ),
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, SavedProject project) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text("Project Details", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            for (int i = 0; i < project.questions.length; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text("${project.questions[i]}: ${project.selectedAnswers[i]}", style: const TextStyle(color: Colors.white70)),
              ),
            const Divider(height: 32, color: Colors.white24),
            const Text("Recommended Stack", style: TextStyle(fontSize: 16, color: Colors.pinkAccent, fontWeight: FontWeight.bold)),
            Text("Frontend: ${project.frontend}", style: const TextStyle(color: Colors.white)),
            Text("Backend: ${project.backend}", style: const TextStyle(color: Colors.white)),
            Text("Database: ${project.database}", style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
