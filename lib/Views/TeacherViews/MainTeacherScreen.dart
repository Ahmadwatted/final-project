import 'dart:convert';

import 'package:final_project/Views/StudentViews/MyTasksScreen.dart';
import 'package:final_project/Views/TeacherViews/TeacherCoursesScreen.dart';
import 'package:final_project/Views/TeacherViews/TeacherUploadedTasks.dart';
import 'package:final_project/utils/Widgets/Add_Button_Design.dart';
import 'package:final_project/utils/Widgets/Task_Card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/clientConfig.dart';
import '../../Models/schedule.dart';
import '../../Models/student.dart';
import '../../Models/task.dart';
import '../../Models/user.dart';
import '../../ViewModels/StudentMain_VM.dart';
import '../../utils/Widgets/Course_Card.dart';
import '../../utils/Widgets/Schedule_Card.dart';
import '../../Models/course.dart';
import '../StudentViews/MyScheduleScreen.dart';
import 'StudentsRequests.dart';
import 'package:http/http.dart' as http;

import 'TeacherScheduleScreen.dart';

class _MyTasksScreen extends StatefulWidget {
  final String title;

  const _MyTasksScreen({required this.title});

  @override
  _MyTasksScreenState createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<_MyTasksScreen> {
  late Future<List<Task>> _tasksFuture;
  late Future<List<Course>> _CoursesFuture;
  late Future<List<Schedule>> _ScheduleFuture;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
    _refreshCourses();
    _refreshSchedule();

  }

  Future<List<User>> getUsers() async {
    var url = "users/getUsers.php";
    final response = await http.get(Uri.parse("https://darkgray-hummingbird-925566.hostingersite.com/watad/users/getUsers.php"));
    List<User> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(User.fromJson(i));
    }

    return arr;
  }

  Future<List<Student>> getStudents() async {
    var url = "students/getStudents.php";
    final response = await http.get(Uri.parse("https://darkgray-hummingbird-925566.hostingersite.com/watad/students/getStudents.php"));
    List<Student> arr = [];

    for(Map<String, dynamic> i in json.decode(response.body)){
      arr.add(Student.fromJson(i));
    }

    return arr;
  }

  Future<List<Course>> getUserCourses() async {
    List<Course> arr = [];
    try {
      var url = "userCourses/getUserCourses.php?userID=1";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception("Response body is null");
        }
        if (jsonData is! List) {
          throw Exception("Response is not a List. Received: $jsonData");
        }

        for (var i in jsonData) {
          arr.add(Course.fromJson(i));
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return arr;
  }

  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];
    try {
      var url = "userTasks/getUserTasks.php?userID=1";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception("Response body is null");
        }
        if (jsonData is! List) {
          throw Exception("Response is not a List. Received: $jsonData");
        }

        for (var i in jsonData) {
          arr.add(Task.fromJson(i));
        }
      }
    } catch (e) {
      print('Error: $e');
    }
    return arr;
  }
  Future<List<Schedule>> getUserSchedule() async {
    List<Schedule> arr = [];

    try {
      var url = "userSchedule/getUserSchedule.php?userID=1";
      final response = await http.get(Uri.parse(serverPath + url));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception("Response body is null");
        }
        if (jsonData is! List) {
          throw Exception("Response is not a List. Received: $jsonData");
        }

        for (var i in jsonData) {
          arr.add(Schedule.fromJson(i));
        }



        // print("Formatted Task List: $tasksString");
      } else {
        // throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
    return arr;
  }

  void _refreshCourses() {
    setState(() {
      _CoursesFuture = getUserCourses();
    });
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = getUserTasks();
    });
  }
  void _refreshSchedule() {
    setState(() {
      _ScheduleFuture = getUserSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3DFD6),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Courses',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TeacherCoursesScreen(title: 'tomainapppage'),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: FutureBuilder<List<Course>>(
                  future: _CoursesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('שגיאה, נסה שוב',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'You have not participated in any courses yet',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final Course course = snapshot.data![index];
                          return Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: CourseCard(
                              courses: course,
                              isStudent: false,
                              onTaskDeleted: _refreshCourses,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Teacherschedulescreen(title: 'tomainapppage'),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: FutureBuilder<List<Schedule>>(
                  future: _ScheduleFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('שגיאה, נסה שוב',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'You are free for now',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final schedule = snapshot.data![index];
                          return Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: ScheduleCard(
                              schedule: schedule,
                              isStudent: false,
                              onTaskDeleted: _refreshSchedule,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Uploaded Tasks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Teacheruploadedtasks(title: 'tomainapppage'),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 160,
                child: FutureBuilder<List<Task>>(
                  future: _tasksFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.red));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text('שגיאה, נסה שוב',
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No tasks yet',
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final task = snapshot.data![index];
                          return Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: TaskCard(
                              tasks: task,
                              isStudent: false,
                              onTaskDeleted: _refreshTasks,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 75),
            ],
          ),
        ),
      ),
    );
  }
}