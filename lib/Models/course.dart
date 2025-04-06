import 'package:flutter/cupertino.dart';



class Course {
  final int courseID;
  final String tutor;
  final String course;
  final String location;
  final String day;
  final String time;
  final description;
  String notes;
   int? stunum;


  Course({
    required this.courseID,
    required this.tutor,
    required this.course,
    required this.day,
    required this.location,
    required this.time,
    required this.description,
    this.notes= '',
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
      description: json['description'] as String,
      notes: json['notes'] ?? '',

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
      'description' : description,
    };
  }
}