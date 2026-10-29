import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';

class KanbanScreen extends StatelessWidget {
  const KanbanScreen({super.key, required this.ctl});
  final TaskController ctl;

  @override
  Widget build(BuildContext context) {
    const statuses = ['To Do', 'In Progress', 'Completed'];
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text('Agile Kanban Board', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        const Text('Move tasks through your placement preparation workflow.'),
        const SizedBox(height: 18),
        LayoutBuilder(builder: (context, constraints) {
          final width = constraints.maxWidth > 950 ? (constraints.maxWidth - 24) / 3 : constraints.maxWidth;
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: statuses.map((status) {
              final items = ctl.tasks.where((t) => t.status == status).toList();
              return SizedBox(
                width: width,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEDEEF5), borderRadius: BorderRadius.circular(16)),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(status, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17))),
                      CircleAvatar(radius: 13, child: Text('${items.length}', style: const TextStyle(fontSize: 12))),
                    ]),
                    const SizedBox(height: 10),
                    if (items.isEmpty) const Padding(padding: EdgeInsets.all(12), child: Text('No tasks')),
                    for (final task in items)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(children: [
                          TaskTile(task: task, ctl: ctl),
                          const SizedBox(height: 5),
                          Wrap(spacing: 4, children: [
                            if (status != 'To Do')
                              TextButton(onPressed: () => ctl.setStatus(task, 'To Do'), child: const Text('To Do')),
                            if (status != 'In Progress')
                              TextButton(onPressed: () => ctl.setStatus(task, 'In Progress'), child: const Text('Start')),
                            if (status != 'Completed')
                              TextButton(onPressed: () => ctl.setStatus(task, 'Completed'), child: const Text('Done')),
                          ]),
                        ]),
                      ),
                  ]),
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }
}
