import 'dart:convert';

import 'package:final_project/Models/task.dart';
import 'package:final_project/utils/Widgets/Random_color.dart';
import 'package:flutter/material.dart';
import '../Models/schedule.dart';
import 'package:final_project/Models/course.dart';
import '../Models/student.dart';
import '../Views/TeacherViews/StudentsRequests.dart';
import '../Models/task.dart';
import 'package:http/http.dart' as http;
import '/../../Models/clientConfig.dart';

Future deleteUser(BuildContext context, String userID) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
  var url = "users/deleteUser.php?userID=" + userID;
  final response = await http.get(Uri.parse(serverPath + url));
  Navigator.pop(context);
}

Future<bool> checkLogin(BuildContext context, String email, String password) async {
  var url = "checkLogins/checkLogin.php?"
      "email=$email"
      "&password=$password";


  final response = await http.get(Uri.parse(serverPath + url));

  Navigator.pop(context); // Close the loading dialog or current screen

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);

    if (data['status'] == 'success') {
      return true; // Login successful
    } else {
      return false; // Login failed
    }
  } else {
    return false; // Server error
  }
}


Future insertUser(
    BuildContext context,
    int userTypeID,
    String firstName,
    String secondName,
    String email,
    String password,
    String phoneNumber) async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
  var url = "users/insertUser.php?"
      "firstName=$firstName"
      "&secondName=$secondName"
      "&email=$email"
      "&password=$password"
      "&phoneNumber=$phoneNumber"
      "&userTypeID=$userTypeID";

  final response = await http.get(Uri.parse(serverPath + url));
   Navigator.pop(context);
}

Future<bool> checkLogin(BuildContext context, String email, String password) async {
  var url = "checkLogins/checkLogin.php?email=$email&password=$password";

  final response = await http.get(Uri.parse(serverPath + url));

  Navigator.pop(context); // Close the loading dialog or current screen

  if (response.statusCode == 200) {
    return jsonDecode(response.body) == true; // Directly check if response is true
  } else {
    return false; // Server error
  }
}



class StudentDashboardViewModel extends ChangeNotifier {
  List<Course> courses = [];
  List<Schedule> schedule = [];
  List<Task> tasks = [];
  List<Student> students = [];

  StudentDashboardViewModel() {
    _initializeData();
  }

  Future<void> _initializeData() async {
    courses = [
      Course(
          courseID: 1,
          tutor: 'mohmmad majadly',
          course: 'Advanced Algorithms',
          day: 'Monday',
          location: 'Tech Building, Room 205',
          c: RandomColor.getRandomShade700(),
          stunum: 100),
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

    tasks = [
      Task(
        taskID: 1,
        tutor: 'mohmmad majadly',
        course: 'Advanced Algorithms',
        day: 'Monday',
        time: '00:00 AM',
        done: 'Completed',
        c: RandomColor.getRandomShade700(),
      ),
      Task(
        taskID: 2,
        tutor: 'mohmmad majadly',
        course: 'Data Structures',
        day: 'Wednesday',
        time: '00:00 AM',
        done: 'Not completed',
        c: RandomColor.getRandomShade700(),
      ),
    ];

    students = await getStudents();
    notifyListeners();
  }

  Future getStudents() async {
    // final String? getInfoDeviceSTR = localStorage.getItem('getInfoDeviceSTR');
    var url = "students/getStudents.php";
    final response = await http.get(Uri.parse(serverPath + url));
    // print(serverPath + url);
    List<Student> arr = [];

    for (Map<String, dynamic> i in json.decode(response.body)) {
      arr.add(Student.fromJson(i));
    }

    return arr;
  }
}
