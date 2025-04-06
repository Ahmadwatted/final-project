import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Models/clientConfig.dart';
import '../../Models/course.dart';
import '../../utils/Widgets/Courses_Screen_Design.dart';

class MyCoursesScreen extends StatefulWidget {
  final String title;
  final String userID;

  const MyCoursesScreen({Key? key, required this.title, required this.userID}) : super(key: key);

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  late Future<List<Course>> _CoursesFuture;
  bool isStudent = true;
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
          // User type toggle
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                TextButton(
                  onPressed: () => setState(() => isStudent = true),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      isStudent ? const Color(0xFF3B82F6) : Colors.grey.shade200,
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'Student',
                    style: TextStyle(
                      color: isStudent ? Colors.white : Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => setState(() => isStudent = false),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      !isStudent ? const Color(0xFF3B82F6) : Colors.grey.shade200,
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    'Tutor',
                    style: TextStyle(
                      color: !isStudent ? Colors.white : Colors.grey.shade700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
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
                  // Filter courses based on search term only
                  final filteredCourses = snapshot.data!
                      .where((course) {
                    // Apply search filter
                    return searchTerm.isEmpty ||
                        course.course.toLowerCase().contains(searchTerm.toLowerCase()) ||
                        course.tutor.toLowerCase().contains(searchTerm.toLowerCase());
                  }).toList();

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
                        isStudent: isStudent,
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
    );
  }

  Widget _buildEmptyState() {
    String message = searchTerm.isNotEmpty
        ? 'No courses matching "$searchTerm"'
        : 'You haven\'t enrolled in any courses yet.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu_book_outlined,
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
          ],
        ),
      ),
    );
  }
}