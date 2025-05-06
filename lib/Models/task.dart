class Task {
  final int taskID;
  final String tutor;
  final String course;
  final String time;
  final String day;
  final bool isCompleted;
  final String dueDate;
  final description;

  Task({
    required this.taskID,
    required this.tutor,
    required this.course,
    required this.day,
    required this.time,
    this.isCompleted = false,
    this.dueDate = '',
    this.description='',
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskID: int.parse(json['taskID'].toString()),
      tutor: json['tutor'] ?? '',
      course: json['course'] ?? '',
      day: json['day'] ?? '',
      time: json['time'] ?? '',
      isCompleted: false,
      dueDate: json['dueDate'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskID': taskID,
      'tutor': tutor,
      'course': course,
      'day': day,
      'time': time,
      'isCompleted': isCompleted,
      'dueDate': dueDate,
      'description' : description
    };
  }
}