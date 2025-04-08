import 'package:final_project/utils/Widgets/Random_color.dart';
import 'package:flutter/material.dart';
import '../../Models/task.dart';
import '../Widgets/Confirm_Del_Task.dart';

class TasksScreenDesign extends StatelessWidget {
  final Task task;
  final bool isStudent;
  final Function onTaskDeleted;
  final Color taskColor = RandomColor.getRandomShade700();

   TasksScreenDesign({
    Key? key,
    required this.task,
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
                color: taskColor,
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
                        task.course,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if(!isStudent)
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => TaskDeleteAlert(
                                taskID: task.taskID,
                                onTaskDeleted: onTaskDeleted,
                              ),
                            ).then((result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result == true
                                        ? 'Task deleted successfully!'
                                        : 'Failed to delete task.',
                                  ),
                                ),
                              );
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        '${task.day}, ${task.time}',
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