import 'dart:convert';

import 'package:final_project/Models/course.dart';
import 'package:final_project/utils/Widgets/Courses_Screen_Design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/clientConfig.dart';
import '../../ViewModels/StudentMain_VM.dart';
import 'package:http/http.dart' as http;

class MyCoursesScreen extends StatelessWidget {
  final String title;
  final String userID;

  const MyCoursesScreen({super.key, required this.title, required this.userID});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _MyCoursesScreen(title: title, userID: userID),
    );
  }
}

class _MyCoursesScreen extends StatefulWidget {
  final String title;
  final String userID;

  const _MyCoursesScreen({required this.title, required this.userID});

  @override
  State<_MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<_MyCoursesScreen> {
  late Future<List<Course>> _CoursesFuture;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _CoursesFuture = getUserCourses();
    });
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



        // print("Formatted Task List: $tasksString");
      } else {
        // throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
        backgroundColor: const Color(0xFFE3DFD6),
        appBar: AppBar(
          title: const Text('My Courses'),
          backgroundColor: Colors.white,
          elevation: 1,

        ),
        body: FutureBuilder<List<Course>>(
          future: _CoursesFuture,
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data?.isEmpty ?? true) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text('אין תוצאות',
                          style: TextStyle(fontSize: 23, color: Colors.black))),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                          itemCount: projectSnap.data?.length,
                          itemBuilder: (context, index) {
                            Course course = projectSnap.data![index];

                            return CoursesScreenDesign(
                              courses: course,
                              isStudent: true,
                              onTaskDeleted: _refreshTasks,
                            );
                          },
                        )),
                  ],
                );
              }
            } else if (projectSnap.hasError) {
              return const Center(
                  child: Text('שגיאה, נסה שוב',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)));
            }
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          },
        ));
  }
}