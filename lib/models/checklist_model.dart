class ChecklistItem {
  final String id;
  final String task;
  bool isCompleted;

  ChecklistItem({
    required this.id,
    required this.task,
    this.isCompleted = false,
  });

  ChecklistItem copyWith({
    String? id,
    String? task,
    bool? isCompleted,
  }) {
    return ChecklistItem(
      id: id ?? this.id,
      task: task ?? this.task,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class ChecklistCategory {
  final String id;
  final String title;
  final String description;
  final List<ChecklistItem> items;
  final int colorValue;

  ChecklistCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.items,
    required this.colorValue,
  });
}
