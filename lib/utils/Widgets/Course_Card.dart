import 'package:flutter/material.dart';

import '../../Models/course.dart';
import 'Confirm_Del.dart';
import 'Random_color.dart';

class CourseCard extends StatelessWidget {
  final Course courses;
  final bool isStudent;
  final Function onTaskDeleted;
  final Color courseColor = RandomColor.getRandomShade700();

   CourseCard({
    Key? key,
    required this.courses,
    this.isStudent = true,
     required this.onTaskDeleted,
  }) : super(key: key);
  Color getCourseColor(Course course) {
    final colors = [
      Colors.blue.shade600,
      Colors.green.shade600,
      Colors.orange.shade600,
      Colors.purple.shade600,
      Colors.pink.shade600,
      Colors.teal.shade600,
    ];

    int colorIndex = 0;

    colorIndex = course.courseID.hashCode;

    return colors[colorIndex.abs() % colors.length];
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top color strip
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: getCourseColor(courses),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day badge

                const SizedBox(height: 8),
                // Course title
                Row(
                  children: [
                    Text(
                      courses.course,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1F36),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  ],







                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person_2_sharp, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      courses.tutor,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),



                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey.shade600),
                    const SizedBox(width: 6),
                    Text(
                      courses.location,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}