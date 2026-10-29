import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key, required this.ctl});
  final TaskController ctl;

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String query = '';
  String category = 'All';
  String status = 'All';
  String priority = 'All';

  @override
  Widget build(BuildContext context) {
    final tasks = widget.ctl.tasks.where((t) {
      final matchesQuery = '${t.title} ${t.description} ${t.project}'.toLowerCase().contains(query.toLowerCase());
      return matchesQuery && (category == 'All' || t.project == category) && (status == 'All' || t.status == status) && (priority == 'All' || t.priority == priority);
    }).toList();
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text('All Tasks & Projects', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        const Text('Organize, search, and manage your full task list.', style: TextStyle(fontSize: 11, color: Colors.black54)),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search tasks, descriptions or projects', border: OutlineInputBorder()),
          onChanged: (v) => setState(() => query = v),
        ),
        const SizedBox(height: 12),
        Wrap(spacing: 12, runSpacing: 8, children: [
          _filter('Category', category, ['All', ...widget.ctl.projects.map((p) => p.name)], (v) => setState(() => category = v)),
          _filter('Status', status, ['All', 'To Do', 'In Progress', 'Completed'], (v) => setState(() => status = v)),
          _filter('Priority', priority, ['All', 'Urgent', 'High', 'Medium', 'Low'], (v) => setState(() => priority = v)),
        ]),
        const SizedBox(height: 16),
        Text('${tasks.length} task(s)', style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 8),
        if (tasks.isEmpty) const Padding(padding: EdgeInsets.all(28), child: Center(child: Text('No matching tasks found.'))),
        for (final task in tasks) Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: TaskTile(task: task, ctl: widget.ctl),
        ),
      ],
    );
  }

  Widget _filter(String label, String value, List<String> values, ValueChanged<String> changed) => SizedBox(
    width: 220,
    child: DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      items: values.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
      onChanged: (v) { if (v != null) changed(v); },
    ),
  );
}
