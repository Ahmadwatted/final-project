import 'package:final_project/Models/usertype.dart';
import 'package:final_project/Views/StudentViews/MyCoursesScreen.dart';
import 'package:final_project/Views/TeacherViews/MainTeacherScreen.dart';
import 'package:final_project/Views/TeacherViews/TeacherCoursesScreen.dart';
import 'package:flutter/material.dart';
import '../../Models/course.dart';
import '../../Models/schedule.dart';
import 'Confirm_Del.dart';
import 'Random_color.dart';

class CoursesScreenDesign extends StatelessWidget {
  final Course courses;
  final bool isStudent;
  final Function onTaskDeleted;
  final Color courseColor = RandomColor.getRandomShade700();

   CoursesScreenDesign({
    Key? key,
    required this.courses,
    this.isStudent = true,
     required this.onTaskDeleted,
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
                color: courseColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        courses.course,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                  const SizedBox(height: 4),
                  if(isStudent)...[
                    Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.grey),
                        const SizedBox(width: 8),
                        Text(
                          courses.tutor.toString(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
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
            ),
          ],
        ),
      ),
    );
  }
}