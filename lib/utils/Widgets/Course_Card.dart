import 'package:flutter/material.dart';

import '../../Models/course.dart';

class CourseCard extends StatelessWidget {
  final Course courses;

  const CourseCard({
    Key? key,
    required this.courses,
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
            ],
          ),
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
          Row(
            children: [
              Icon(Icons.people, color: Colors.grey,),
              Text(
                '${courses.stunum}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),

            ],
          )
        ],
      ),
    );
  }
}