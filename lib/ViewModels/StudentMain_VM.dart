import 'package:final_project/Models/task.dart';
import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/schedule.dart';
import '../Models/task.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  List<Course> _courses = [];
  List<DaySchedule> _schedule = [];
  List<DayTask> _task=[];

  List<Course> get courses => _courses;
  List<DaySchedule> get schedule => _schedule;
  List<DayTask> get task=> _task;

  StudentDashboardViewModel() {
    _initializeData();
  }

  void _initializeData() {

    _courses = [
      Course(
        name: 'Mathematics',
        instructor: 'Saeed al sabha ',
        time: 'Mon/Wed 10:00 AM',
        colorValue: Colors.blue[100]?.value ?? 0,
      ),
      Course(
        name: 'Physics',
        instructor: 'Prof. Johnson',
        time: 'Tue/Thu 2:00 PM',
        colorValue: Colors.green[100]?.value ?? 0,
      ),
      Course(
        name: 'Computer Science',
        instructor: 'Dr. Williams',
        time: 'Mon/Wed 1:00 PM',
        colorValue: Colors.purple[100]?.value ?? 0,
      ),
      Course(
        name: 'History',
        instructor: 'Prof. Davis',
        time: 'Fri 11:00 AM',
        colorValue: Colors.orange[100]?.value ?? 0,
      ),
      Course(
        name: 'Literature',
        instructor: 'Dr. Brown',
        time: 'Tue/Thu 9:00 AM',
        colorValue: Colors.pink[100]?.value ?? 0,
      ),
    ];

    // Initialize schedule
    _schedule = [
      DaySchedule(
        day: 'Sunday',
        classes: ['Mathematics', 'Computer Science'],
      ),
      DaySchedule(
        day: 'Monday',
        classes: ['Mathematics', 'Computer Science'],
      ),
      DaySchedule(
        day: 'Tuesday',
        classes: ['Physics', 'Literature'],
      ),
      DaySchedule(
        day: 'Wednesday',
        classes: ['Mathematics', 'Computer Science'],
      ),
      DaySchedule(
        day: 'Thursday',
        classes: ['Physics', 'Literature'],
      ),
      DaySchedule(
        day: 'Friday',
        classes: ['History'],
      ),
      DaySchedule(
        day: 'Saturday',
        classes: ['History'],
      ),
    ];
    _task=[
      DayTask(day: 'Sunday', name: ['Math', 'Physics', 'arabic','math']),

      DayTask(day: 'Monday', name: ['Physics']),

      DayTask(day: 'Tuesday', name: ['history']),

      DayTask(day: 'Wednesday', name: ['Computer', 'Science', 'English']),

      DayTask(day: 'Thursday', name: ['Math']),

      DayTask(day: 'Friday', name: ['Biology']),

      DayTask(day: 'Saturday', name: ['English'])


    ];
    notifyListeners();
  }
}