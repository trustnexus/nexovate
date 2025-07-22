// ! DEPRECATED, this file is no longer used in the application!

import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class SavedProject {
  final String id;
  final DateTime timestamp;
  final List<String> questions;
  final List<String> selectedAnswers;
  final String frontend;
  final String backend;
  final String database;

  SavedProject({
    required this.id,
    required this.timestamp,
    required this.questions,
    required this.selectedAnswers,
    required this.frontend,
    required this.backend,
    required this.database,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'timestamp': timestamp.toIso8601String(),
    'questions': questions,
    'selectedAnswers': selectedAnswers,
    'frontend': frontend,
    'backend': backend,
    'database': database,
  };

  static SavedProject fromJson(Map<String, dynamic> json) => SavedProject(
    id: json['id'],
    timestamp: DateTime.parse(json['timestamp']),
    questions: List<String>.from(json['questions']),
    selectedAnswers: List<String>.from(json['selectedAnswers']),
    frontend: json['frontend'],
    backend: json['backend'],
    database: json['database'],
  );
}

/// Get a safe application documents directory path and ensure the file exists
Future<File> _getSavedProjectsFile() async {
  final directory = await getApplicationSupportDirectory();
  final filePath =
      '${directory.path}${Platform.pathSeparator}saved_projects.json';
  final file = File(filePath);

  // ✅ Ensure the directory and file both exist
  if (!await file.exists()) {
    await file.create(recursive: true);
    await file.writeAsString("[]"); // Start with empty list
  }

  return file;
}

/// Save a project locally by appending to existing list in JSON
Future<void> saveProjectLocally({
  required List<String> questions,
  required List<String> answers,
  required String frontend,
  required String backend,
  required String database,
}) async {
  try {
    final file = await _getSavedProjectsFile();
    final String id = const Uuid().v4();

    final project = SavedProject(
      id: id,
      timestamp: DateTime.now(),
      questions: questions,
      selectedAnswers: answers,
      frontend: frontend,
      backend: backend,
      database: database,
    );

    List<SavedProject> existingProjects = [];

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.trim().isNotEmpty) {
        final decoded = json.decode(content);
        existingProjects =
            (decoded as List)
                .map((item) => SavedProject.fromJson(item))
                .toList();
      }
    }

    // Check for duplication (you can customize this logic as needed)
    bool exists = existingProjects.any(
      (p) =>
          p.questions.join() == project.questions.join() &&
          p.selectedAnswers.join() == project.selectedAnswers.join(),
    );

    if (!exists) {
      existingProjects.add(project);
      final encoded = json.encode(
        existingProjects.map((e) => e.toJson()).toList(),
      );
      await file.writeAsString(encoded);
    }
  } catch (e) {
    print("❌ Failed to save project: $e");
  }
}

/// Load all saved projects from local file
Future<List<SavedProject>> loadSavedProjects() async {
  final file = await _getSavedProjectsFile();
  if (await file.exists()) {
    final content = await file.readAsString();
    try {
      final decoded = json.decode(content);
      return (decoded as List).map((e) => SavedProject.fromJson(e)).toList();
    } catch (_) {
      return [];
    }
  }
  return [];
}

Future<void> saveAllProjects(List<SavedProject> projects) async {
  final file = await _getSavedProjectsFile();
  final encoded = json.encode(projects.map((e) => e.toJson()).toList());
  await file.writeAsString(encoded);
}
