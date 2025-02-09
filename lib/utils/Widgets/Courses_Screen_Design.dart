import 'package:final_project/Models/usertype.dart';
import 'package:final_project/Views/StudentViews/MyCoursesScreen.dart';
import 'package:final_project/Views/TeacherViews/MainTeacherScreen.dart';
import 'package:final_project/Views/TeacherViews/TeacherCoursesScreen.dart';
import 'package:flutter/material.dart';
import '../../Models/course.dart';
import '../../Models/schedule.dart';

class CoursesScreenDesign extends StatelessWidget {
  final Course courses;
  final bool showStudentCount;  // Simple boolean flag

  const CoursesScreenDesign({
    Key? key,
    required this.courses,
    this.showStudentCount = false,  // Defaults to false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: courses.c,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courses.course,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.play_lesson, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${courses.day},',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        courses.location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Only show student numbers if showStudentCount is true
                  if (showStudentCount) ...[
                    Row(
                      children: [
                        const Icon(Icons.people, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          courses.stunum.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}