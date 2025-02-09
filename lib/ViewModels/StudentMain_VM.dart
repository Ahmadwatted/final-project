import 'package:final_project/Models/task.dart';
import 'package:final_project/utils/Widgets/Random_color.dart';
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
        courseID: 1,
        tutor: 'mohmmad majadly',
        course: 'Aanced Algorithms',
        day: 'Monday',
        location: 'Tech Building, Room 205',
        c: RandomColor.getRandomShade700(),
        stunum: 100
      ),
      Course(
        courseID: 2,
        course: 'Data Structures',
        tutor: 'yamin massri',
        day: 'Wednesday',
        location: 'Science Complex, Room 302',
          c: RandomColor.getRandomShade700(),
        stunum: 20,
      ),
    ];


     schedule = [
      Schedule(
        scheduleID: 1,

        course: 'Advanced Algorithms',
        tutor: 'mohmmad majadly',
        day: 'Monday',
        time: '10:00 AM - 11:30 AM',
        location: 'Tech Building, Room 205',
        c: RandomColor.getRandomShade700(),


      ),
      Schedule(
        scheduleID: 2,
        tutor: 'mohmmad majadly',
        course: 'Data Structures',
        day: 'Wednesday',
        time: '2:00 PM - 3:30 PM',
        location: 'Science Complex, Room 302',
        c: RandomColor.getRandomShade700(),
      ),
    ];




    tasks=[
      Task(
        id: 1,
        tutor: 'mohmmad majadly',
        course: 'Advanced Algorithms',
        day: 'Monday',
        time: '00:00 AM',
        done: 'Completed',
        c: RandomColor.getRandomShade700(),

      ),
      Task(
        id: 2,
        tutor: 'mohmmad majadly',
        course: 'Data Structures',
        day: 'Wednesday',
        time: '00:00 AM',
        done: 'Not completed',
        c: RandomColor.getRandomShade700(),

      ),



    ];
    notifyListeners();
  }
}