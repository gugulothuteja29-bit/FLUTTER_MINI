import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';

Future<PlacementTask?> showTaskDialog(BuildContext context, {PlacementTask? existing, TaskController? ctl}) async {
  final formKey = GlobalKey<FormState>();
  final title = TextEditingController(text: existing?.title ?? '');
  final description = TextEditingController(text: existing?.description ?? '');
  String project = existing?.project ?? 'Placement Preparation';
  String priority = existing?.priority ?? 'Medium';
  String status = existing?.status ?? 'To Do';
  DateTime due = DateTime.tryParse(existing?.dueDate ?? '') ?? DateTime.now().add(const Duration(days: 3));

  final result = await showDialog<PlacementTask>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(existing == null ? 'New Task' : 'Edit Task'),
        content: SizedBox(
          width: 460,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: title,
                    decoration: const InputDecoration(labelText: 'Task title *', border: OutlineInputBorder()),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter a task title' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: description,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: project,
                    decoration: const InputDecoration(labelText: 'Project', border: OutlineInputBorder()),
                    items: const [
                      DropdownMenuItem(value: 'Placement Preparation', child: Text('Placement Preparation')),
                      DropdownMenuItem(value: 'Resume & Portfolio', child: Text('Resume & Portfolio')),
                      DropdownMenuItem(value: 'Interview Practice', child: Text('Interview Practice')),
                      DropdownMenuItem(value: 'Skill Development', child: Text('Skill Development')),
                    ],
                    onChanged: (v) { if (v != null) setDialogState(() => project = v); },
                  ),
                  const SizedBox(height: 12),
                  Row(children: [
                    Expanded(child: DropdownButtonFormField<String>(
                      value: priority,
                      decoration: const InputDecoration(labelText: 'Priority', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'Urgent', child: Text('Urgent')),
                        DropdownMenuItem(value: 'High', child: Text('High')),
                        DropdownMenuItem(value: 'Medium', child: Text('Medium')),
                        DropdownMenuItem(value: 'Low', child: Text('Low')),
                      ],
                      onChanged: (v) { if (v != null) setDialogState(() => priority = v); },
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: DropdownButtonFormField<String>(
                      value: status,
                      decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'To Do', child: Text('To Do')),
                        DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                        DropdownMenuItem(value: 'Completed', child: Text('Completed')),
                      ],
                      onChanged: (v) { if (v != null) setDialogState(() => status = v); },
                    )),
                  ]),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: due,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) setDialogState(() => due = picked);
                    },
                    icon: const Icon(Icons.calendar_month),
                    label: Text('Due date: ${due.year}-${due.month.toString().padLeft(2, '0')}-${due.day.toString().padLeft(2, '0')}'),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              final date = '${due.year}-${due.month.toString().padLeft(2, '0')}-${due.day.toString().padLeft(2, '0')}';
              Navigator.pop(dialogContext, PlacementTask(
                id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
                title: title.text.trim(),
                description: description.text.trim(),
                project: project,
                priority: priority,
                status: status,
                dueDate: date,
              ));
            },
            child: const Text('Save Task'),
          ),
        ],
      ),
    ),
  );
  title.dispose();
  description.dispose();
  return result;
}
