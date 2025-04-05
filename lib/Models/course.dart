import 'package:flutter/cupertino.dart';



class Course {
  final int courseID;
  final String tutor;
  final String course;
  final String location;
  final String day;
  final String time;
   int? stunum;
   Color? c;

  Course({
    required this.courseID,
    required this.tutor,
    required this.course,
    required this.day,
    required this.location,
    required this.time,
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
      time: json['time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseID': courseID,
      'tutor' : tutor,
      'course': course,
      'day': day,
      'location': location,
      'time' : time,
    };
  }
}