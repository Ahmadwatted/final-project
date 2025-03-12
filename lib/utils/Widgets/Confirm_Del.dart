import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/clientConfig.dart';

class TaskDeleteAlert extends StatefulWidget {
  final int taskID;
  final Function? onTaskDeleted;

  const TaskDeleteAlert({
    Key? key,
    required this.taskID,
    this.onTaskDeleted,
  }) : super(key: key);

  @override
  _TaskDeleteAlertState createState() => _TaskDeleteAlertState();
}

class _TaskDeleteAlertState extends State<TaskDeleteAlert> {
  bool _isDeleting = false;

  Future<bool> _deleteTask(BuildContext context) async {
    setState(() => _isDeleting = true);

    try {
      var url = "tasks/deleteTask.php?taskID=${widget.taskID}";
      final response = await http.get(Uri.parse(serverPath + url));

      print("Full Delete Response:");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Attempting to delete Task ID: ${widget.taskID}");

      setState(() => _isDeleting = false);

      if (response.statusCode == 200) {
        if (response.body.trim().startsWith('[')) {

          print("Server returned a list of tasks instead of a deletion confirmation");
          return false;
        }

        try {
          var jsonResponse = json.decode(response.body);

          print("JSON Response: $jsonResponse");

          if (jsonResponse is Map && jsonResponse.containsKey('result')) {
            if (jsonResponse['result'] == '1' || jsonResponse['result'] == 1) {
              widget.onTaskDeleted?.call();
              return true;
            } else {
              print("Deletion failed: ${jsonResponse['message'] ?? 'Unknown error'}");
              return false;
            }
          } else {
            print("Unexpected response format");
            return false;
          }
        } catch (e) {
          print("JSON parsing error: $e");
          return false;
        }
      }

      return false;
    } catch (e) {
      print('Deletion Error: $e');
      setState(() => _isDeleting = false);
      return false;
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
          Text('Delete Task', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      content: Text('Are you sure you want to delete this task?', style: TextStyle(fontSize: 16)),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: _isDeleting ? null : () async {
            final result = await _deleteTask(context);
            Navigator.of(context).pop(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isDeleting
              ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2)
          )
              : Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}