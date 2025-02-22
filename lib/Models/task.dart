import 'package:flutter/cupertino.dart';

class Task {
  final int taskID;
  final String tutor;
  final String course;
  final String time;
  final String day;
   Color? c;

  Task({
    required this.taskID,
    required this.tutor,
    required this.course,
    required this.day,
    required this.time,
     this.c,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskID: json['id'] ?? 0,
      tutor: json['tutor'] ,
      course: json['course'] ,
      day: json['day'] ,
      time: json['time'] ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'taskID': taskID,
      'tutor' : tutor,
      'course': course,
      'day': day,
      'time': time,
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
