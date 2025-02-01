import 'package:flutter/material.dart';
import '../../Models/task.dart';

class TaskCard extends StatelessWidget {
  final DayTask task;



  const TaskCard({Key? key, required this.task}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      width: 280,

      decoration: BoxDecoration(

        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            task.day,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...task.name.map((className) {
            return Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(className),
            );
          }),
        ],
      ),
    );
  }
}

