import 'package:flutter/cupertino.dart';



class Course {
  final int courseID;
   String? tutor;
  final String course;
  final String location;
  
  final String day;
  final int? stunum;
  final Color? c;

  Course({
    required this.courseID,
     this.tutor,
    required this.course,
    required this.day,
    required this.location,
     this.c,
    this.stunum,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseID: json['courseID'] as int,
      tutor: json['tutor'] as String,
      course: json['course'] as String,
      day: json['day'] as String,
      location: json['location'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseID': courseID,
      'tutor' : tutor,
      'course': course,
      'day': day,
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