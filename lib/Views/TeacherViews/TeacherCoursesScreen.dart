import 'package:flutter/material.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Models/clientConfig.dart';
import '../../Models/course.dart';
import '../../utils/Widgets/Courses_Screen_Design.dart';

class TeacherCoursesScreen extends StatefulWidget {
  final String title;
  final String userID;

  const TeacherCoursesScreen({Key? key, required this.title, required this.userID}) : super(key: key);

  @override
  State<TeacherCoursesScreen> createState() => _TeacherCoursesScreen();
}

class _TeacherCoursesScreen extends State<TeacherCoursesScreen> {
  late Future<List<Course>> _CoursesFuture;
  bool isStudent = false;
  String searchTerm = '';

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
      }
    } catch (e) {
      print('Error: $e');
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          // Add new course button
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: () {
              // Navigate to add course page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Add course functionality"),
                  backgroundColor: Color(0xFF3B82F6),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),

          // Course list
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: _CoursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF3B82F6)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading courses',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: _refreshTasks,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  // Filter courses based on search term
                  final filteredCourses = snapshot.data!
                      .where((course) =>
                  searchTerm.isEmpty ||
                      course.course.toLowerCase().contains(searchTerm.toLowerCase()) ||
                      course.day.toLowerCase().contains(searchTerm.toLowerCase())
                  ).toList();

                  if (filteredCourses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    itemCount: filteredCourses.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return CoursesScreenDesign(
                        courses: course,
                        isStudent: false,
                        onTaskDeleted: _refreshTasks,
                        isGridView: false,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.add),
        onPressed: () {
          // Navigate to add course page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Add course functionality"),
              backgroundColor: Color(0xFF3B82F6),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = searchTerm.isNotEmpty
        ? 'No courses matching "$searchTerm"'
        : 'You haven\'t created any courses yet.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No courses found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Create Course'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                // Navigate to add course page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Add course functionality"),
                    backgroundColor: Color(0xFF3B82F6),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}