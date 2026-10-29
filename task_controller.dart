import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class ProjectInfo {
  const ProjectInfo(this.name, this.color);
  final String name;
  final Color color;
}

class TaskController extends ChangeNotifier {
  static const _storageKey = 'taskflow_placement_tasks_v1';

  final List<PlacementTask> tasks = [];
  bool loading = false;
  String? error;

  final List<ProjectInfo> projects = const [
    ProjectInfo('Work & Projects', Color(0xFF6554E8)),
    ProjectInfo('Personal Life', Color(0xFF21B88A)),
    ProjectInfo('Study & Upskilling', Color(0xFFE8AD28)),
    ProjectInfo('Fitness & Health', Color(0xFFE66A8B)),
  ];

  Future<void> load() async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw != null) {
        final list = jsonDecode(raw) as List<dynamic>;
        tasks
          ..clear()
          ..addAll(list.map((e) => PlacementTask.fromJson(
              Map<String, dynamic>.from(e as Map))));
      } else {
        tasks
          ..clear()
          ..addAll(_sampleTasks());
        await _save();
      }
    } catch (e) {
      error = 'Could not load tasks: $e';
    }
    loading = false;
    notifyListeners();
  }

  List<PlacementTask> _sampleTasks() => [
    PlacementTask(id: 'sample-1', title: 'Design high-fidelity wireframes for client portal',
      description: 'Finalize navigation structure and dashboard metrics widget in Figma.', project: 'Work & Projects',
      priority: 'Urgent', status: 'Completed', dueDate: '2026-10-26'),
    PlacementTask(id: 'sample-2', title: 'Complete System Architecture Review',
      description: 'Evaluate microservices architecture and write report.', project: 'Work & Projects',
      priority: 'High', status: 'To Do', dueDate: '2026-10-28'),
    PlacementTask(id: 'sample-3', title: 'Study TypeScript Generics & Utility types',
      description: 'Read handbook chapters 3 and 5 with practical exercises.', project: 'Study & Upskilling',
      priority: 'Medium', status: 'To Do', dueDate: '2026-10-30'),
    PlacementTask(id: 'sample-4', title: 'Attend 45-minute HIIT workout session',
      description: 'Gym cardio and mobility stretches.', project: 'Fitness & Health',
      priority: 'Medium', status: 'Completed', dueDate: '2026-10-25'),
  ];

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey,
        jsonEncode(tasks.map((task) => task.toJson()).toList()));
  }

  Future<void> add(PlacementTask task) async {
    tasks.insert(0, task);
    await _save();
    notifyListeners();
  }

  Future<void> update(PlacementTask updated) async {
    final index = tasks.indexWhere((t) => t.id == updated.id);
    if (index >= 0) {
      tasks[index] = updated;
      await _save();
      notifyListeners();
    }
  }

  Future<void> remove(String id) async {
    tasks.removeWhere((t) => t.id == id);
    await _save();
    notifyListeners();
  }

  Future<void> setStatus(PlacementTask task, String status) async {
    task.status = status;
    await _save();
    notifyListeners();
  }

  Color projectColor(String project) =>
      projects.where((p) => p.name == project).firstOrNull?.color ?? const Color(0xFF64748B);
}
