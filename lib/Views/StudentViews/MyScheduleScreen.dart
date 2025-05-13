import 'dart:convert';
import 'package:final_project/utils/Widgets/Schedule_Screen_Design.dart';
import 'package:flutter/material.dart';
import 'package:final_project/Models/course.dart';
import 'package:http/http.dart' as http;
import '../../Models/clientConfig.dart';

class MyScheduleScreen extends StatelessWidget {
  final String title;
  final String userID;
  const MyScheduleScreen({super.key, required this.title, required this.userID});
  @override
  Widget build(BuildContext context) {
    return MyScheduleScreenState(title: title, userID: userID);
  }
}

class MyScheduleScreenState extends StatefulWidget {
  final String title;
  final String userID;
  const MyScheduleScreenState({required this.title, required this.userID});
  @override
  State<MyScheduleScreenState> createState() => MyCoursesScreenState();
}

class MyCoursesScreenState extends State<MyScheduleScreenState> {
  late Future<List<Course>> CoursesFuture;
  bool isStudent = true;
  String activeTab = 'all';
  @override
  void initState() {
    super.initState();
    refreshTasks();
  }
  void refreshTasks() {
    setState(() {
      CoursesFuture = getUserCourses();
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
      backgroundColor: const Color(0xFFE3DFD6),
      appBar: AppBar(
        title: const Text('My Schedule'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Row(
              children: [
                buildFilterTab('all', 'All Courses'),
                buildFilterTab('sunday', 'Sunday'),
                buildFilterTab('monday', 'Monday'),
                buildFilterTab('tuesday', 'Tuesday'),
                buildFilterTab('wednesday', 'Wednesday'),
                buildFilterTab('thursday', 'Thursday'),
                buildFilterTab('friday', 'Friday'),
                buildFilterTab('saturday', 'Saturday'),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: CoursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                        'שגיאה, נסה שוב',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return buildEmptyState();
                } else {
                  final filteredCourses = activeTab == 'all'
                      ? snapshot.data!
                      : snapshot.data!.where((course) =>
                      course.day.toLowerCase().contains(activeTab)).toList();
                  if (filteredCourses.isEmpty) {
                    return buildEmptyState();
                  }
                  return ListView.builder(
                    itemCount: filteredCourses.length,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return ScheduleScreenDesign(
                        courses: course,
                        isStudent: isStudent,
                        onTaskDeleted: refreshTasks,
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
  Widget buildFilterTab(String tabId, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: activeTab == tabId
            ? const Color(0xFF3B82F6)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            setState(() {
              activeTab = tabId;
            });
          },
          borderRadius: BorderRadius.circular(24),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: activeTab != tabId
                  ? Border.all(color: const Color(0xFFE5E7EB))
                  : null,
            ),
            child: Text(
              label,
              style: TextStyle(
                color: activeTab == tabId
                    ? Colors.white
                    : const Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.calendar_month,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 16),
            const Text(
              'Get your-self busy',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              activeTab == 'all'
                  ? 'You haven\'t enrolled in any courses yet.'
                  : 'There are no courses scheduled for this day.',
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