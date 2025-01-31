import 'package:flutter/material.dart';
import 'package:final_project/Views/StudentViews/MyCoursesScreen.dart';

import 'MyScheduleScreen.dart';

class MainStudentScreen extends StatelessWidget {
  final String title;

  const MainStudentScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final schedule = [
      {
        'day': 'Sunday',
        'classes': ['Mathematics', 'Computer Science']
      },
      {
        'day': 'Monday',
        'classes': ['Mathematics', 'Computer Science']
      },
      {
        'day': 'Tuesday',
        'classes': ['Physics', 'Literature']
      },
      {
        'day': 'Wednesday',
        'classes': ['Mathematics', 'Computer Science']
      },
      {
        'day': 'Thursday',
        'classes': ['Physics', 'Literature']
      },
      {
        'day': 'Friday',
        'classes': ['History']
      },
      {
        'day': 'Saturday',
        'classes': ['History']
      },
    ];
    final courses = [
      {
        'name': 'Mathematics',
        'instructor': 'Dr. Smith',
        'time': 'Mon/Wed 10:00 AM',
        'color': Colors.blue[100],
      },
      {
        'name': 'Physics',
        'instructor': 'Prof. Johnson',
        'time': 'Tue/Thu 2:00 PM',
        'color': Colors.green[100],
      },
      {
        'name': 'Computer Science',
        'instructor': 'Dr. Williams',
        'time': 'Mon/Wed 1:00 PM',
        'color': Colors.purple[100],
      },
      {
        'name': 'History',
        'instructor': 'Prof. Davis',
        'time': 'Fri 11:00 AM',
        'color': Colors.orange[100],
      },
      {
        'name': 'Literature',
        'instructor': 'Dr. Brown',
        'time': 'Tue/Thu 9:00 AM',
        'color': Colors.pink[100],
      },
    ];
    return Scaffold(
      backgroundColor: Color(0xFFE3DFD6),
      appBar: AppBar(
        title: Text('Courses DashBoard'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //
              // Courses Section
              TextButton(

                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                           const  Mycoursesscreen (title: 'tomainapppage')),
                  ),
                },
                child: const Text(
                  'My Courses',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Container(
                      width: 250,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: course['color'] as Color?,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course['name'] as String,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(course['instructor'] as String),
                          const SizedBox(height: 4),
                          Text(course['time'] as String),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              TextButton(

                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const  MyTimeTableScreen (title: 'tomainapppage')),
                  ),
                },
                child: const Text(
                  'My schedule',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: List.generate(
                      schedule.length,
                          (index) {
                        var day = schedule[index];
                        return Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.all(16),
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            // Add subtle shadow for better depth

                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                day['day'] as String,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...((day['classes'] as List<String>).map((className) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(className),
                                );
                              })),
                            ],),
                        );
                      },
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
