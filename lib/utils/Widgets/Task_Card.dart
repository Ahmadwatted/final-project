
import 'package:flutter/material.dart';
import '../../Models/task.dart';
import '../Widgets/Confirm_Del.dart';
import 'Random_color.dart';

class TaskCard extends StatelessWidget {
  final Task tasks;
  final bool isStudent;
  final Function onTaskDeleted;
  final Color courseColor = RandomColor.getRandomShade700();

   TaskCard({
    Key? key,
    required this.tasks,
    this.isStudent =true,
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
                Icons.task_alt,
                size: 20,
                color: Colors.blue[600],
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  tasks.course,
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
                        taskID: tasks.taskID,
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




              },
            ],

          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.person, color: Colors.grey,),
              Text(
                tasks.tutor,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),

            ],
          ),
          SizedBox(height: 8),
          Text(
            tasks.day,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            tasks.time,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

        ],
      ),
    );
  }
}