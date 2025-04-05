import 'package:flutter/material.dart';
import '../../Models/course.dart';
import '../../Models/schedule.dart';
import 'Confirm_Del.dart';
import 'Random_color.dart';

class ScheduleCard extends StatelessWidget {
  final Course course;
  final bool isStudent;
  final Function onTaskDeleted;
  final Color courseColor = RandomColor.getRandomShade700();

  ScheduleCard({
    Key? key,
    required this.course,
    this.isStudent = true,
    required this.onTaskDeleted,
  }) : super(key: key);

  Color getScheduleColor(Course schedule) {
    final colors = [
      Colors.teal.shade600,
      Colors.purple.shade600,
      Colors.green.shade600,
      Colors.blue.shade600,
      Colors.pink.shade600,
      Colors.orange.shade600,
    ];

    int colorIndex = 0;
    colorIndex = schedule.courseID.hashCode;
    return colors[colorIndex.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320, // Increased width to prevent overflow
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top color strip
          Container(
            height: 8,
            width: double.infinity,
            decoration: BoxDecoration(
              color: getScheduleColor(course),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          // Content section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today, size: 10, color: Colors.blue.shade800),
                      const SizedBox(width: 4),
                      Text(
                        course.day,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                // Course title
                Text(
                  course.course,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1F36),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                // Info rows with overflow protection
                infoRow(Icons.person_2_sharp, course.tutor),
                infoRow(Icons.access_time, course.time),
                infoRow(Icons.location_on, course.location),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Changed from start to center
        children: [
          SizedBox(
            width: 20, // Fixed width container for icon
            child: Icon(icon, size: 12, color: Colors.grey.shade600),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}