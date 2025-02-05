import 'package:flutter/cupertino.dart';

class Task {
  final int id;
  final String course;
  final String time;
  final String done;
  final String day;

  Task({
    required this.id,
    required this.course,
    required this.day,
    required this.time,
    required this.done,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      course: json['course'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      done: json['done'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'day': day,
      'time': time,
      'done': done,
    };
  }
}


class StudentViewModel extends ChangeNotifier {
  List<Task> tasks = [];

  void loadTaskFromJson(List<Map<String, dynamic>> jsonList) {
    tasks = jsonList.map((json) => Task.fromJson(json)).toList();
    notifyListeners();
  }

  List<Map<String, dynamic>> tasksToJson() {
    return tasks.map((task) => task.toJson()).toList();
  }
}