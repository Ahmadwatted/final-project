import 'package:final_project/Models/task.dart';
import 'package:flutter/material.dart';
import '../Models/schedule.dart';
import 'package:final_project/Models/course.dart';
import '../Models/task.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  List<Course> courses = [];
  List<Schedule> schedule = [];
  List<DayTask> task=[];



  StudentDashboardViewModel() {
    _initializeData();
  }

  void _initializeData() {

    courses = [
      Course(
        id: 1,
        course: 'Aanced Algorithms',
        day: 'Monday',
        time: '10:00 AM - 11:30 AM',
        location: 'Tech Building, Room 205',
      ),
      Course(
        id: 2,
        course: 'Data Structures',
        day: 'Wednesday',
        time: '2:00 PM - 3:30 PM',
        location: 'Science Complex, Room 302',
      ),
    ];


     schedule = [
      Schedule(
        id: 1,
        course: 'Advanced Algorithms',
        day: 'Monday',
        time: '10:00 AM - 11:30 AM',
        location: 'Tech Building, Room 205',
      ),
      Schedule(
        id: 2,
        course: 'Data Structures',
        day: 'Wednesday',
        time: '2:00 PM - 3:30 PM',
        location: 'Science Complex, Room 302',
      ),
    ];




    task=[
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