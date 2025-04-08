import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/clientConfig.dart';

class CourseDeleteAlert extends StatefulWidget {
  final int courseID;
  final Function onTaskDeleted;

  const CourseDeleteAlert({
    Key? key,
    required this.courseID,
    required this.onTaskDeleted,
  }) : super(key: key);

  @override
  _CourseDeleteAlertState createState() => _CourseDeleteAlertState();
}

class _CourseDeleteAlertState extends State<CourseDeleteAlert> {
  bool _isDeleting = false;

  Future<bool> _deleteCourse(BuildContext context) async {
    setState(() => _isDeleting = true);

    try {
      var url = "courses/deleteCourse.php?courseID=${widget.courseID}";
      final response = await http.get(Uri.parse(serverPath + url));

      print("Full Delete Response:");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Attempting to delete Course ID: ${widget.courseID}");

      setState(() => _isDeleting = false);

      if (response.statusCode == 200) {
        if (response.body.trim().startsWith('[')) {
          print("Server returned a list of courses instead of a deletion confirmation");
          return false;
        }

        try {
          var jsonResponse = json.decode(response.body);

          print("JSON Response: $jsonResponse");

          if (jsonResponse is Map && jsonResponse.containsKey('result')) {
            if (jsonResponse['result'] == '1' || jsonResponse['result'] == 1) {
              // Execute the callback before returning
              widget.onTaskDeleted();
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
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
          const SizedBox(width: 8),
          const Text('Delete Course', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      content: const Text('Are you sure you want to delete this course?', style: TextStyle(fontSize: 16)),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: _isDeleting ? null : () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: _isDeleting ? null : () async {
            final result = await _deleteCourse(context);
            Navigator.of(context).pop(result);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isDeleting
              ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2)
          )
              : const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}