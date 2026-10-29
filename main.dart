import 'package:flutter/material.dart';
import 'controllers/task_controller.dart';
import 'screens/analytics_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/kanban_screen.dart';
import 'screens/task_list_screen.dart';
import 'widgets/task_dialog.dart';

const ink = Color(0xFF25233B);
const violet = Color(0xFF6554E8);
const canvas = Color(0xFFF7F8FC);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TaskFlowApp());
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'TaskFlow', debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: violet, primary: violet),
      scaffoldBackgroundColor: canvas,
      fontFamily: 'Arial',
      cardTheme: const CardThemeData(color: Colors.white, elevation: 0, margin: EdgeInsets.zero),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE7E8F0))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE7E8F0))),
      ),
    ),
    home: const HomeShell(),
  );
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});
  @override State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final TaskController ctl = TaskController();
  int pageIndex = 0;
  bool ready = false;
  static const titles = ['Dashboard', 'Task List', 'Kanban Board', 'Calendar', 'Analytics'];
  static const pageIcons = [Icons.dashboard_outlined, Icons.checklist_rounded, Icons.view_kanban_outlined, Icons.calendar_month_outlined, Icons.bar_chart_rounded];
  @override void initState() { super.initState(); _initialize(); }
  Future<void> _initialize() async { await ctl.load(); if (mounted) setState(() => ready = true); }
  @override void dispose() { ctl.dispose(); super.dispose(); }

  Future<void> _newTask() async {
    final task = await showTaskDialog(context);
    if (task != null) {
      await ctl.add(task);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Task added successfully')));
    }
  }
  Widget _sidebar({required bool compact}) => Container(
    width: compact ? 220 : 238,
    decoration: const BoxDecoration(color: Colors.white, border: Border(right: BorderSide(color: Color(0xFFE9EAF2)))),
    child: SafeArea(child: ListView(padding: const EdgeInsets.fromLTRB(14, 12, 14, 18), children: [
      const Padding(padding: EdgeInsets.fromLTRB(5, 6, 5, 20), child: Row(children: [
        CircleAvatar(radius: 17, backgroundColor: violet, child: Icon(Icons.check_rounded, color: Colors.white, size: 20)),
        SizedBox(width: 9), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('TaskFlow', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)), Text('Project Suite', style: TextStyle(fontSize: 11, color: Colors.black45))]),
      ])),
      const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 8), child: Text('N A V I G A T I O N   P A G E S', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.black45))),
      for (var i = 0; i < titles.length; i++)
        Padding(padding: const EdgeInsets.only(bottom: 3), child: Material(
          color: pageIndex == i ? const Color(0xFFEDEBFF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: ListTile(
            dense: true, visualDensity: const VisualDensity(vertical: -2),
            leading: Icon(pageIcons[i], size: 17, color: pageIndex == i ? violet : const Color(0xFF6C6C7D)),
            title: Text('${i + 1}. ${titles[i]}', style: TextStyle(fontSize: 12, fontWeight: pageIndex == i ? FontWeight.w700 : FontWeight.w500, color: pageIndex == i ? violet : ink)),
            trailing: i == 1 ? Text('${ctl.tasks.length}', style: const TextStyle(fontSize: 11, color: Colors.black45)) : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onTap: () => setState(() => pageIndex = i),
          ),
        )),
      const SizedBox(height: 14),
      const Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 9), child: Text('P R O J E C T S   &   T E A M S', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.black45))),
      for (final project in ctl.projects)
        ListTile(dense: true, visualDensity: const VisualDensity(vertical: -3), contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: Icon(Icons.circle, size: 7, color: project.color),
          title: Text(project.name, style: const TextStyle(fontSize: 11, color: ink)),
          trailing: Text('${ctl.tasks.where((t) => t.project == project.name).length}', style: const TextStyle(fontSize: 11, color: Colors.black45)),
        ),
    ])),
  );

  Widget _header() => Container(
    height: 56, padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(color: Colors.white, border: Border(bottom: BorderSide(color: Color(0xFFE9EAF2)))),
    child: Row(children: [
      Expanded(child: Text(switch (pageIndex) {0 => 'Executive Dashboard', 1 => 'Master Task Manager', 2 => 'Agile Kanban Board', 3 => 'Sprint & Deadline Calendar', _ => 'Team Analytics & Performance'}, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: ink))),
      IconButton(tooltip: 'Notifications', onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications'))), icon: const Icon(Icons.notifications_none, size: 19, color: Colors.black45)),
      const SizedBox(width: 6),
      FilledButton.icon(onPressed: _newTask, icon: const Icon(Icons.add, size: 16), label: const Text('New Task', style: TextStyle(fontSize: 11)), style: FilledButton.styleFrom(backgroundColor: violet, padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)))),
    ]),
  );

  Widget _page() => switch (pageIndex) {
    0 => DashboardScreen(ctl: ctl, onAdd: _newTask),
    1 => TaskListScreen(ctl: ctl),
    2 => KanbanScreen(ctl: ctl),
    3 => CalendarScreen(ctl: ctl),
    _ => AnalyticsScreen(ctl: ctl),
  };

  @override Widget build(BuildContext context) => ListenableBuilder(listenable: ctl, builder: (context, _) => Scaffold(
    body: LayoutBuilder(builder: (context, box) {
      final desktop = box.maxWidth >= 760;
      if (!desktop) return Column(children: [
        _header(), Expanded(child: !ready ? const Center(child: CircularProgressIndicator()) : _page()),
        NavigationBar(selectedIndex: pageIndex, onDestinationSelected: (i) => setState(() => pageIndex = i), destinations: const [
          NavigationDestination(icon: Icon(Icons.dashboard_outlined), label: 'Dashboard'), NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'), NavigationDestination(icon: Icon(Icons.view_kanban_outlined), label: 'Board'), NavigationDestination(icon: Icon(Icons.calendar_month_outlined), label: 'Calendar'), NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Analytics'),
        ]),
      ]);
      return Row(children: [
        _sidebar(compact: box.maxWidth < 1050),
        Expanded(child: Column(children: [_header(), Expanded(child: !ready ? const Center(child: CircularProgressIndicator()) : _page())])),
      ]);
    }),
  ));
}
