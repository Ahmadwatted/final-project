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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_lesson,
                size: 20,
                color: Colors.blue[600],
              ),
              SizedBox(width: 8),

                Expanded(
                  child: Text(
                    courses.course,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if(!isStudent)...{
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => TaskDeleteAlert(
                        taskID: courses.courseID,
                        onTaskDeleted: onTaskDeleted,
                      ),
                    ).then((result) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            result == true
                                ? 'Course deleted successfully!'
                                : 'Failed to delete course.',
                          ),
                        ),
                      );
                    });
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  splashRadius: 24,
                ),




              },



            ],
          ),
          SizedBox(height: 4),
          if(isStudent)...[
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey,),
                Text(
                  courses.tutor.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),

              ],
            )
          ],
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey,),
              Text(
                courses.location,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),

            ],
          ),
          SizedBox(height: 4),
          if (!isStudent) ...[
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
    );
  }
}