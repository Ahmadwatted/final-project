import 'package:flutter/cupertino.dart';

class Task {
  final int taskID;
  final String tutor;
  final String course;
  final String time;
  final String day;
  final Color c;
  String done;

  Task({
    required this.taskID,
    required this.tutor,
    required this.course,
    required this.day,
    required this.time,
    required this.done,
    required this.c,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskID: json['id'] as int,
      tutor: json['tutor'] as String,
      course: json['course'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      done: json['done'] as String,
      c: json['c'] as Color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskID': taskID,
      'tutor' : tutor,
      'course': course,
      'day': day,
      'time': time,
      'done': done,
      'c': c,
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
