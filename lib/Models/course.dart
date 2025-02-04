import 'package:flutter/cupertino.dart';



class Course {
  final int id;
  final String course;
  final String time;
  final String location;
  final String day;

  Course({
    required this.id,
    required this.course,
    required this.day,
    required this.time,
    required this.location,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      course: json['course'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'day': day,
      'time': time,
      'location': location,
    };
  }
}


class StudentViewModel extends ChangeNotifier {
  List<Course> courses = [];

  void loadCourseFromJson(List<Map<String, dynamic>> jsonList) {
  courses = jsonList.map((json) => Course.fromJson(json)).toList();
  notifyListeners();
  }

  List<Map<String, dynamic>> coursesToJson() {
  return courses.map((course) => course.toJson()).toList();
  }
}