import 'package:flutter/cupertino.dart';



class Course {
  final int id;
  final String course;
  final String location;
  final String day;
  final Color c;


  Course({
    required this.id,
    required this.course,
    required this.day,
    required this.location,
    required this.c,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      course: json['course'] as String,
      day: json['day'] as String,
      location: json['location'] as String,
      c:json['c'] as Color,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course,
      'day': day,
      'location': location,
      'c': c,
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