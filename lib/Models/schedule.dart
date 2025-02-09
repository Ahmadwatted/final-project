import 'package:flutter/cupertino.dart';

class Schedule {
  final int id;
  final String course;
  final String day;
  final String time;
  final String location;
  final Color c;

  Schedule({
    required this.id,
    required this.course,
    required this.day,
    required this.time,
    required this.location,
    required this.c,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'] as int,
      course: json['course'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      c: json['c'] as Color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'day': day,
      'time': time,
      'location': location,
      'c' : c,
    };
  }
}


class StudentViewModel extends ChangeNotifier {
  List<Schedule> schedule = [];

  void loadScheduleFromJson(List<Map<String, dynamic>> jsonList) {
    schedule = jsonList.map((json) => Schedule.fromJson(json)).toList();
    notifyListeners();
  }

  List<Map<String, dynamic>> scheduleToJson() {
    return schedule.map((schedule) => schedule.toJson()).toList();
  }
}