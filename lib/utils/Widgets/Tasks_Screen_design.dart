import 'package:flutter/material.dart';
import '../../Models/schedule.dart';
import '../../Models/task.dart';
import '../Widgets/Confirm_Del.dart';

class TasksScreenDesign extends StatelessWidget {
  final Task tasks;
  final bool isStudent;

  const TasksScreenDesign({Key? key, required this.tasks, this.isStudent=true}) : super(key: key);

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
                color: tasks.c,
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
                        tasks.course,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(!isStudent)...[
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => TaskDeleteAlert(taskId: tasks.taskID.toString()),
                            );
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          splashRadius: 24,
                        ),
                      ],





                    ],
                  ),

                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${tasks.day}, ${tasks.time}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
