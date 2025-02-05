import 'package:final_project/Models/task.dart';
import 'package:flutter/material.dart';
import '../Models/schedule.dart';
import 'package:final_project/Models/course.dart';
import '../Models/task.dart';

class StudentDashboardViewModel extends ChangeNotifier {
  List<Course> courses = [];
  List<Schedule> schedule = [];
  List<Task> tasks=[];



  StudentDashboardViewModel() {
    _initializeData();
  }

  void _initializeData() {

    courses = [
      Course(
        id: 1,
        course: 'Aanced Algorithms',
        day: 'Monday',
        location: 'Tech Building, Room 205',
      ),
      Course(
        id: 2,
        course: 'Data Structures',
        day: 'Wednesday',
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




    tasks=[
      Task(
        id: 1,
        course: 'Advanced Algorithms',
        day: 'Monday',
        time: '10:00 AM - 11:30 AM',
        done: 'Completed',
      ),
      Task(
        id: 2,
        course: 'Data Structures',
        day: 'Wednesday',
        time: '2:00 PM - 3:30 PM',
        done: 'Not completed',
      ),



    ];
    notifyListeners();
  }
}