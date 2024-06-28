class Task {
  final int id;
  String title;
  bool isComplete;

  Task({
    required this.id,
    required this.title,
    this.isComplete = false,
  });
}
