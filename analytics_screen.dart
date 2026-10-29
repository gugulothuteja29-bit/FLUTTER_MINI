import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key, required this.ctl});
  final TaskController ctl;

  @override
  Widget build(BuildContext context) {
    final total = ctl.tasks.length;
    final completed = ctl.tasks.where((t) => t.status == 'Completed').length;
    final active = ctl.tasks.where((t) => t.status == 'In Progress').length;
    final urgent = ctl.tasks.where((t) => t.priority == 'Urgent' && t.status != 'Completed').length;
    final efficiency = total == 0 ? 0 : (completed / total * 100).round();
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text('Performance & Project Analytics', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 18),
        Wrap(spacing: 14, runSpacing: 14, children: [
          _stat('Efficiency Score', '$efficiency%', Icons.speed),
          _stat('Active Workload', '$active tasks', Icons.work_outline),
          _stat('High-Priority Load', '$urgent', Icons.priority_high),
        ]),
        const SizedBox(height: 24),
        const Text('Status Breakdown', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (final entry in [
          MapEntry('To Do', ctl.tasks.where((t) => t.status == 'To Do').length),
          MapEntry('In Progress', active),
          MapEntry('Completed', completed),
        ])
          _bar(entry.key, entry.value, total, entry.key == 'Completed' ? const Color(0xFF0F9D8A) : const Color(0xFF4F46E5)),
        const SizedBox(height: 24),
        const Text('Priority Distribution', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        for (final entry in [
          MapEntry('Urgent', ctl.tasks.where((t) => t.priority == 'Urgent').length),
          MapEntry('High', ctl.tasks.where((t) => t.priority == 'High').length),
          MapEntry('Medium', ctl.tasks.where((t) => t.priority == 'Medium').length),
          MapEntry('Low', ctl.tasks.where((t) => t.priority == 'Low').length),
        ])
          _bar(entry.key, entry.value, total, entry.key == 'Urgent' ? const Color(0xFFDB5471) : const Color(0xFFF59E0B)),
        const SizedBox(height: 24),
        const Text('Project workload', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        for (final project in ctl.projects)
          _bar(project.name, ctl.tasks.where((t) => t.project == project.name).length, total, project.color),
      ],
    );
  }

  Widget _stat(String label, String value, IconData icon) => SizedBox(
    width: 240,
    child: Card(child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(children: [
        Icon(icon, size: 30, color: const Color(0xFF4F46E5)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
        ]),
      ]),
    )),
  );

  Widget _bar(String label, int value, int total, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Expanded(child: Text(label)), Text('$value')]),
      const SizedBox(height: 5),
      LinearProgressIndicator(value: total == 0 ? 0 : value / total, color: color, minHeight: 8, borderRadius: BorderRadius.circular(8)),
    ]),
  );
}
