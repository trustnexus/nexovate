import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nexovate/src/providers/user.dart';
import 'package:nexovate/src/screens/Project/project_detail_page.dart';

import 'package:nexovate/src/screens/utils/sidebar_navigation.dart';
import 'package:nexovate/src/screens/utils/toast.dart';

import 'package:nexovate/src/services/document/download-doc.dart' as doc_downloader;
import 'package:provider/provider.dart';

class SavedProjectsScreen extends StatefulWidget {
  const SavedProjectsScreen({super.key});

  @override
  State<SavedProjectsScreen> createState() => _SavedProjectsScreenState();
}

class _SavedProjectsScreenState extends State<SavedProjectsScreen> {
  static const int maxProjects = 10;
  List<Map> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProjects();
  }

  Future<void> _loadProjects() async {
    final box = await Hive.openBox('Projects');
    final projects = box.values.cast<Map>().toList();
    setState(() {
      _projects = projects;
      _isLoading = false;
    });
  }

  Future<void> _deleteProject(int index) async {
    final box = await Hive.openBox('Projects');
    await box.deleteAt(index);
    await _loadProjects();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🗑️ Project deleted")),
      );
    }
  }

  Future<void> generatePdfFromProject(Map project, BuildContext context) async {
    final downloadUrl = project['downloadUrl'];
    final fileName = project['fileName'] ?? '${project['name'] ?? "Project"}.pdf';

    if (downloadUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No download URL available for this project.")),
      );
      return;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final token = userProvider.user?.token;

      final filePath = await doc_downloader.downloadDocument(downloadUrl, fileName, token!);

      showToast(context, "PDF downloaded to: $filePath");
        } catch (e) {
      showToast(context, "Error downloading PDF: $e");
    }
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.black,
    drawer: const SidebarNavigation(),
    appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Image.asset(
            'assets/images/N_log.png',
            height: 40,
            fit: BoxFit.contain,
          ),
        )
      ],
      title: ShaderMask(
        shaderCallback: (bounds) => const LinearGradient(
          colors: [Colors.orange, Colors.pinkAccent],
        ).createShader(bounds),
        child: const Text(
          "Saved Projects",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      centerTitle: true,
    ),
    body: SafeArea(
      child: Column(
        children: [
          if (_projects.length >= maxProjects) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "🚫 Project limit reached: Max 10 allowed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [Colors.redAccent, Colors.orange],
                    ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  shadows: const [
                    Shadow(
                      color: Colors.orangeAccent,
                      blurRadius: 16,
                      offset: Offset(0, 0),
                    )
                  ],
                ),
              ),
            ),
          ],
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.pinkAccent))
                : _projects.isEmpty
                    ? const Center(child: Text("No saved projects.", style: TextStyle(color: Colors.white70)))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _projects.length,
                        itemBuilder: (context, index) {
                          return _buildProjectCard(context, _projects[index], index);
                        },
                      ),
          ),
        ],
      ),
    ),
  );
}


  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: "Open Menu",
            ),
          ),
          Expanded(
            child: ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Colors.orange, Colors.pinkAccent],
              ).createShader(bounds),
              child: const Text(
                "Saved Projects",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Poppins'),
              ),
            ),
          ),
          Image.asset('assets/images/N_log.png', height: 28),
        ],
      ),
    );
  }

  Widget _buildProjectCard(BuildContext context, Map project, int index) {
    final timestamp = DateFormat('MMM d, yyyy – h:mm a').format(DateTime.parse(project['timestamp'] ?? DateTime.now().toIso8601String()));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9900), Color(0xFFFF3D5A)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.pinkAccent.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(1.8),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(14),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          leading: Image.asset('assets/images/N_log.png', height: 48),
          title: Text(
            project['name'] ?? 'Untitled Project',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              "Created: $timestamp",
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          trailing: SizedBox(
            width: 144,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_red_eye_rounded, color: Colors.orangeAccent),
                  tooltip: "View UI",
                  onPressed: () {
                    // Implement your UI preview logic here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.lightBlueAccent),
                  tooltip: "Download PDF",
                  onPressed: () => generatePdfFromProject(project, context),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.pinkAccent),
                  tooltip: "Delete Project",
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: Colors.grey[900],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        title: const Text("Delete Project", style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                        content: const Text("Are you sure you want to delete this project?", style: TextStyle(color: Colors.white70)),
                        actionsAlignment: MainAxisAlignment.spaceAround,
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            style: TextButton.styleFrom(backgroundColor: Colors.redAccent),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text("No", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            style: TextButton.styleFrom(backgroundColor: Colors.amber),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              child: Text("Yes", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await _deleteProject(index);
                    }
                  },
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ProjectDetailPage(project: project)),
            );
          },
        ),
      ),
    );
  }
}



