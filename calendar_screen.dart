import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key, required this.ctl});
  final TaskController ctl;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime month = DateTime(2026, 10);

  @override
  Widget build(BuildContext context) {
    final firstWeekday = month.weekday % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = ((firstWeekday + daysInMonth + 6) ~/ 7) * 7;
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        const Text('Sprint & Deadline Calendar', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Card(child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(children: [
              IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month - 1)), icon: const Icon(Icons.chevron_left)),
              Expanded(child: Text('${_monthName(month.month)} ${month.year}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              IconButton(onPressed: () => setState(() => month = DateTime(month.year, month.month + 1)), icon: const Icon(Icons.chevron_right)),
            ]),
            const SizedBox(height: 8),
            Row(children: const [
              Expanded(child: Center(child: Text('Sun', style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('Mon', style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('Tue', style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('Wed', style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('Thu', style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('Fri', style: TextStyle(fontWeight: FontWeight.bold)))),
              Expanded(child: Center(child: Text('Sat', style: TextStyle(fontWeight: FontWeight.bold)))),
            ]),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cells,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7, childAspectRatio: 1.0),
              itemBuilder: (context, index) {
                final day = index - firstWeekday + 1;
                if (day < 1 || day > daysInMonth) return const SizedBox();
                final date = '${month.year}-${month.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
                final dayTasks = widget.ctl.tasks.where((t) => t.dueDate == date).toList();
                final today = DateTime.now();
                final isToday = today.year == month.year && today.month == month.month && today.day == day;
                return Container(
                  margin: const EdgeInsets.all(2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isToday ? const Color(0xFFE5E2FF) : const Color(0xFFF7F8FC),
                    border: Border.all(color: isToday ? const Color(0xFF4F46E5) : Colors.black12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('$day', style: TextStyle(fontWeight: isToday ? FontWeight.bold : FontWeight.normal)),
                    if (dayTasks.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFF4F46E5), borderRadius: BorderRadius.circular(5)),
                        child: Text('${dayTasks.length} task${dayTasks.length > 1 ? 's' : ''}', style: const TextStyle(color: Colors.white, fontSize: 9)),
                      ),
                    ],
                  ]),
                );
              },
            ),
          ]),
        )),
        const SizedBox(height: 16),
        const Text('Tasks this month', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final task in widget.ctl.tasks.where((t) => t.dueDate.startsWith('${month.year}-${month.month.toString().padLeft(2, '0')}')).toList()..sort((a,b) => a.dueDate.compareTo(b.dueDate)))
          ListTile(
            leading: const Icon(Icons.event_note),
            title: Text(task.title),
            subtitle: Text('${task.dueDate} • ${task.project}'),
            trailing: Text(task.status),
          ),
      ],
    );
  }

  String _monthName(int month) => const [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ][month - 1];
}
