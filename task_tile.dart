import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import 'task_dialog.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.ctl});
  final PlacementTask task;
  final TaskController ctl;

  @override
  Widget build(BuildContext context) {
    final color = ctl.projectColor(task.project);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(task.status == 'Completed' ? Icons.check : Icons.event_note, color: color),
        ),
        title: Text(task.title, style: TextStyle(
          fontWeight: FontWeight.w600,
          decoration: task.status == 'Completed' ? TextDecoration.lineThrough : null,
        )),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(spacing: 8, runSpacing: 5, children: [
            Text(task.project),
            Text('• ${task.dueDate}'),
            Chip(label: Text(task.priority), visualDensity: VisualDensity.compact),
            Chip(label: Text(task.status), visualDensity: VisualDensity.compact),
          ]),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'edit') {
              final edited = await showTaskDialog(context, existing: task, ctl: ctl);
              if (edited != null) await ctl.update(edited);
            } else if (value == 'delete') {
              final yes = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete task?'),
                  content: Text('Delete "${task.title}"?'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                  ],
                ),
              );
              if (yes == true) await ctl.remove(task.id);
            } else if (value.startsWith('status:')) {
              await ctl.setStatus(task, value.substring(7));
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'edit', child: Text('Edit')),
            PopupMenuItem(value: 'status:To Do', child: Text('Move to To Do')),
            PopupMenuItem(value: 'status:In Progress', child: Text('Move to In Progress')),
            PopupMenuItem(value: 'status:Completed', child: Text('Mark Completed')),
            PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
      ),
    );
  }
}
