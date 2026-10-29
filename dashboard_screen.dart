import 'package:flutter/material.dart';
import '../controllers/task_controller.dart';
import '../widgets/task_tile.dart';

const purple = Color(0xFF6554E8);
const textInk = Color(0xFF25233B);

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.ctl, required this.onAdd});
  final TaskController ctl;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final total = ctl.tasks.length;
    final completed = ctl.tasks.where((t) => t.status == 'Completed').length;
    final active = ctl.tasks.where((t) => t.status == 'In Progress').length;
    final urgent = ctl.tasks.where((t) => t.priority == 'Urgent' && t.status != 'Completed').length;
    final progress = total == 0 ? 0.0 : completed / total;
    return ListView(padding: const EdgeInsets.all(20), children: [
      Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF6E5BEE), Color(0xFF5D50D7)]), borderRadius: BorderRadius.circular(12)),
        child: Row(children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [Text('Welcome back! 👋', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)), SizedBox(height: 5), Text('Here is your daily productivity snapshot across all ongoing projects.', style: TextStyle(fontSize: 11, color: Colors.white70))])), const SizedBox(width: 8), OutlinedButton.icon(onPressed: onAdd, icon: const Icon(Icons.add, size: 15), label: const Text('Create New Task', style: TextStyle(fontSize: 11)), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white70), backgroundColor: Colors.white.withValues(alpha: .08))) ])),
      const SizedBox(height: 16),
      Wrap(spacing: 12, runSpacing: 12, children: [
        _metric('TOTAL TASKS', '$total', Icons.bar_chart_rounded, const Color(0xFF6554E8), 230),
        _metric('COMPLETED', '$completed', Icons.check_circle_outline, const Color(0xFF25B88A), 230),
        _metric('IN PROGRESS', '$active', Icons.schedule, const Color(0xFFE6AC2D), 230),
        _metric('URGENT / OVERDUE', '$urgent', Icons.error_outline, const Color(0xFFE66A8B), 230),
      ]),
      const SizedBox(height: 16),
      LayoutBuilder(builder: (context, constraints) {
        final wide = constraints.maxWidth > 780;
        final left = _completion(progress, ctl);
        final right = _attention(ctl);
        if (!wide) return Column(children: [left, const SizedBox(height: 14), right]);
        return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(flex: 11, child: left), const SizedBox(width: 14), Expanded(flex: 9, child: right)]);
      }),
    ]);
  }

  Widget _metric(String label, String value, IconData icon, Color color, double width) => SizedBox(width: width, child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11), side: const BorderSide(color: Color(0xFFECECF4))), child: Padding(padding: const EdgeInsets.all(14), child: Row(children: [Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(9)), child: Icon(icon, color: color, size: 19)), const SizedBox(width: 11), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontSize: 9, color: Colors.black54, fontWeight: FontWeight.w700)), const SizedBox(height: 3), Text(value, style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: textInk))]))]))));

  Widget _completion(double progress, TaskController ctl) => Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11), side: const BorderSide(color: Color(0xFFECECF4))), child: Padding(padding: const EdgeInsets.all(17), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Expanded(child: Text('Overall Completion Velocity', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textInk))), Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4), decoration: BoxDecoration(color: const Color(0xFFEDEBFF), borderRadius: BorderRadius.circular(20)), child: Text('${(progress * 100).round()}% Done', style: const TextStyle(fontSize: 9, color: purple, fontWeight: FontWeight.bold)))]), const SizedBox(height: 16), for (final project in ctl.projects) ...[
    Row(children: [Container(width: 6, height: 6, decoration: BoxDecoration(color: project.color, shape: BoxShape.circle)), const SizedBox(width: 7), Expanded(child: Text(project.name, style: const TextStyle(fontSize: 10, color: textInk))), Text('${ctl.tasks.where((t) => t.project == project.name && t.status == 'Completed').length}/${ctl.tasks.where((t) => t.project == project.name).length}', style: const TextStyle(fontSize: 9, color: Colors.black54))]), const SizedBox(height: 5), LinearProgressIndicator(value: ctl.tasks.where((t) => t.project == project.name).isEmpty ? 0 : ctl.tasks.where((t) => t.project == project.name && t.status == 'Completed').length / ctl.tasks.where((t) => t.project == project.name).length, color: project.color, backgroundColor: const Color(0xFFF0F0F6), minHeight: 5, borderRadius: BorderRadius.circular(8)), const SizedBox(height: 12),
  ]])));

  Widget _attention(TaskController ctl) => Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11), side: const BorderSide(color: Color(0xFFECECF4))), child: Padding(padding: const EdgeInsets.all(17), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [const Expanded(child: Text('Requires Immediate Attention', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: textInk))), TextButton(onPressed: () {}, child: const Text('View All →', style: TextStyle(fontSize: 10, color: purple)))]), const SizedBox(height: 16), if (ctl.tasks.where((t) => t.status != 'Completed' && t.priority == 'Urgent').isEmpty) const SizedBox(height: 82, child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.auto_awesome, color: Color(0xFF38C6A1), size: 24), SizedBox(height: 10), Text('Awesome! No overdue or pressing\ntasks today.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black45, fontSize: 10, height: 1.5))]))) else ...ctl.tasks.where((t) => t.status != 'Completed' && t.priority == 'Urgent').map((t) => Padding(padding: const EdgeInsets.only(bottom: 7), child: TaskTile(task: t, ctl: ctl))),])));
}
