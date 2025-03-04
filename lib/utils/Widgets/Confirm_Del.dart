import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../Models/clientConfig.dart';

class TaskDeleteAlert extends StatelessWidget {
  final String taskId;
  final Function? onTaskDeleted; // Add a callback function

  const TaskDeleteAlert({
    Key? key,
    required this.taskId,
    this.onTaskDeleted,
  }) : super(key: key);

  Future<bool> _deleteTask(BuildContext context) async {
    try {
      var url = "tasks/deleteTask.php?taskID=$taskId";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        // Call callback if provided
        if (onTaskDeleted != null) {
          onTaskDeleted!();
        }
        return true; // Success
      }
      return false; // Failed
    } catch (e) {
      print('Error deleting task: ${e.toString()}');
      return false; // Error
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          SizedBox(width: 8),
          Text(
            'Delete Task',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
      content: Text(
        'Are you sure you want to delete this task?',
        style: TextStyle(fontSize: 16),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await _deleteTask(context);
            // Close dialog and show message in parent context
            Navigator.of(context).pop(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}