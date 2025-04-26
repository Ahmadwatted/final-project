import 'dart:convert';
import 'package:final_project/utils/Widgets/Course_Card.dart';
import 'package:final_project/utils/Widgets/Schedule_Card.dart';
import 'package:final_project/utils/Widgets/Task_Card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Models/clientConfig.dart';
import '../../Models/course.dart';
import '../../Models/schedule.dart';
import '../../Models/task.dart';
import '../../utils/Widgets/Add_Button_Design.dart';
import 'MyCoursesScreen.dart';
import 'MyScheduleScreen.dart';
import 'MyTasksScreen.dart';

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

class _MainStudentScreenState extends State<MainStudentScreen> {
  late Future<List<Task>> _tasksFuture;
  late Future<List<Course>> _coursesFuture;
  late Future<List<Schedule>> _scheduleFuture;

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

  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];

    try {
      var url = "userTasks/getUserTasks.php?userID=${widget.userID}";
      print("Fetching tasks with URL: ${serverPath + url}");
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        print("Task response body: ${response.body}");
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
        print('Failed to load tasks: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error in getUserTasks: $e');
    }
    print("Returning ${arr.length} tasks");
    return arr;
  }

  Future<List<Course>> getUserCourses() async {
    List<Course> arr = [];

    try {
      var url = "userCourses/getUserCourses.php?userID=${widget.userID}";
      print("Fetching courses with URL: ${serverPath + url}");
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        print("Course response body: ${response.body}");
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception("Response body is null");
        }
        if (jsonData is! List) {
          throw Exception("Response is not a List. Received: $jsonData");
        }

        for (var i in jsonData) {
          print("Adding course: $i");
          arr.add(Course.fromJson(i));
        }
      } else {
        print('Failed to load courses: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error in getUserCourses: $e');
    }
    print("Returning ${arr.length} courses");
    return arr;
  }

  Future<List<Schedule>> getUserSchedule() async {
    List<Schedule> arr = [];

    try {
      var url = "userSchedule/getUserSchedule.php?userID=${widget.userID}";
      print("Fetching schedule with URL: ${serverPath + url}");
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        print("Schedule response body: ${response.body}");
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
        print('Failed to load schedule: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error in getUserSchedule: $e');
    }
    print("Returning ${arr.length} schedule items");
    return arr;
  }









  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Student Dashboard',
          style: TextStyle(
            color: Color(0xFF1A1F36),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  'My Courses',
                  Icons.book_outlined,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyCoursesScreen(
                        title: 'My Courses',
                        userID: widget.userID,
                      ),
                    ),
                  ),
                ),
                _buildCoursesList(),

                const SizedBox(height: 24),

                _buildSectionHeader(
                  'My Schedule',
                  Icons.schedule_outlined,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyScheduleScreen(
                        title: 'My Schedule',
                        userID: widget.userID,
                      ),
                    ),
                  ),
                ),
                _buildScheduleList(),

                const SizedBox(height: 24),

                _buildSectionHeader(
                  'My Tasks',
                  Icons.check_box_outlined,
                      () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyTasksScreen(
                        title: 'My Tasks',
                        userID: widget.userID,
                      ),
                    ),
                  ),
                ),
                _buildTasksList(),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget _buildSectionHeader(String title, IconData icon, VoidCallback onViewAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1F36),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onViewAll,
            style: TextButton.styleFrom(
              foregroundColor: Colors.blue.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Row(
              children: [
                const Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Colors.blue.shade600,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesList() {
    return SizedBox(
      height: 160,
      child: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorState('Error loading courses: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState('You have not participated in any courses yet');
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final Course course = snapshot.data![index];
                return CourseCard(courses: course, isStudent: true,onTaskDeleted: _refreshCourses,);
              },
            );
          }
        },
      ),
    );
  }



  Widget _buildScheduleList() {
    return SizedBox(
      height: 160,
      child: FutureBuilder<List<Course>>(
        future: _coursesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorState('Error loading schedule: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState('No scheduled classes');
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final course = snapshot.data![index];
                return ScheduleCard(course:course, isStudent: true,onTaskDeleted: _refreshSchedule,);
              },
            );
          }
        },
      ),
    );
  }



  Widget _buildTasksList() {
    return SizedBox(
      height: 160,
      child: FutureBuilder<List<Task>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return _buildErrorState('Error loading tasks: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState('No tasks yet');
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final task = snapshot.data![index];
                return TaskCard(tasks:task, isStudent: true, onTaskDeleted: _refreshTasks,);
              },
            );
          }
        },
      ),
    );
  }



  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.blue,
        strokeWidth: 3,
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: Colors.red.shade800,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}