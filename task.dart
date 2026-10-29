class PlacementTask {
  PlacementTask({
    required this.id,
    required this.title,
    required this.description,
    required this.project,
    required this.priority,
    required this.status,
    required this.dueDate,
  });

  final String id;
  String title;
  String description;
  String project;
  String priority;
  String status;
  String dueDate;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'project': project,
        'priority': priority,
        'status': status,
        'dueDate': dueDate,
      };

  factory PlacementTask.fromJson(Map<String, dynamic> json) => PlacementTask(
        id: json['id'] as String,
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        project: json['project'] as String? ?? 'Placement Preparation',
        priority: json['priority'] as String? ?? 'Medium',
        status: json['status'] as String? ?? 'To Do',
        dueDate: json['dueDate'] as String? ?? DateTime.now().toIso8601String().substring(0, 10),
      );
}
