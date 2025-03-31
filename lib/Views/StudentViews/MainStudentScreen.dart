import 'dart:convert';

import 'package:final_project/Models/schedule.dart';
import 'package:http/http.dart' as http;
import '../../Models/clientConfig.dart';
import '../../Models/task.dart';
import '../../Views/StudentViews/MyCoursesScreen.dart';
import 'package:final_project/Views/StudentViews/MyTasksScreen.dart';
import 'package:final_project/utils/Widgets/Add_Button_Design.dart';
import 'package:final_project/utils/Widgets/Task_Card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/StudentMain_VM.dart';
import '../../utils/Widgets/Course_Card.dart';
import '../../utils/Widgets/Schedule_Card.dart';
import '../../Models/course.dart';
import 'MyScheduleScreen.dart';

class MainStudentScreen extends StatefulWidget {
  final String title;
  final String userID;

  const MainStudentScreen({
    super.key,
    required this.title,
    required this.userID,
  });

  @override
  State<MainStudentScreen> createState() => _MainStudentScreenState();
}

// Private state class
class _MainStudentScreenState extends State<MainStudentScreen> {
  late Future<List<Task>> _tasksFuture;
  late Future<List<Course>> _coursesFuture;
  late Future<List<Schedule>> _scheduleFuture;

  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];

    try {
      var url = "userTasks/getUserTasks.php?userID=${widget.userID}";
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
          arr.add(Task.fromJson(i));
        }
      } else {
        print('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserTasks: $e');
    }
    return arr;
  }

  Future<List<Course>> getUserCourses() async {
    List<Course> arr = [];

    try {
      var url = "userCourses/getUserCourses.php?userID=${widget.userID}";
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
          arr.add(Course.fromJson(i));
        }
      } else {
        print('Failed to load courses: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserCourses: $e');
    }
    return arr;
  }

  Future<List<Schedule>> getUserSchedule() async {
    List<Schedule> arr = [];

    try {
      var url = "userSchedule/getUserSchedule.php?userID=${widget.userID}";
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
      } else {
        print('Failed to load schedule: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUserSchedule: $e');
    }
    return arr;
  }


  @override
  void initState() {
    super.initState();
    _refreshTasks();
    _refreshCourses();
    _refreshSchedule();
  }

  void _refreshCourses() {
    setState(() {
      _coursesFuture = getUserCourses();
    });
  }
  void _refreshTasks() {
    setState(() {
      _tasksFuture = getUserTasks();
    });
  }
  void _refreshSchedule() {
    setState(() {
      _scheduleFuture = getUserSchedule();
    });
  }

  void _handleJoinCourse(String code) {
    // backend
    print('Joining course with code: $code');
  }

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddButtonDesign(
        onJoinCourse: _handleJoinCourse,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Remove the viewModel reference that's causing the error
    // final viewModel = Provider.of<StudentDashboardViewModel>(context);

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
              // COURSES SECTION
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
                          builder: (context) =>  MyCoursesScreen(title: 'tomainapppage', userID: 'userID=${widget.userID}',),
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
                  future: _coursesFuture,
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
                              isStudent: true,
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

              // SCHEDULE SECTION
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
                          builder: (context) => const MyScheduleScreen(title: 'tomainapppage'),
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
                  future: _scheduleFuture,
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
                          'No scheduled classes',
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
                            child: ScheduleCard(schedule: schedule, isStudent: true, onTaskDeleted: _refreshSchedule,),
                          );
                        },
                      );
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),

              // TASKS SECTION
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Tasks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyTasksScreen(title: 'tomainapppage'),
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
                              isStudent: true,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJoinSheet(context),
        child: const Icon(Icons.add_circle_outline, color: Colors.black),
        backgroundColor: Colors.transparent,
        elevation: 0,
        splashColor: Colors.transparent,
        highlightElevation: 0,
      ),
    );
  }
}