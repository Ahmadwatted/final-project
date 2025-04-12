import 'package:flutter/cupertino.dart';

class Schedule {
  final int scheduleID;
  final String tutor;
  final String course;
  final String day;
  final String time;
  final String location;

  Schedule({
    required this.scheduleID,
    required this.tutor,
    required this.course,
    required this.day,
    required this.time,
    required this.location,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      scheduleID: json['scheduleID'] as int,
      tutor: json['tutor'] as String,
      course: json['course'] as String,
      day: json['day'] as String,
      time: json['time'] as String,
      location: json['location'] as String,

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduleID': scheduleID,
      'tutor' : tutor,
      'course': course,
      'day': day,
      'time': time,
      'location': location,

    };
  }
}


