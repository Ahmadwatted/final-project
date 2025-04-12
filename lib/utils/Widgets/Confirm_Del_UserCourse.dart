import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/clientConfig.dart';

class UserCourseDeleteAlert extends StatefulWidget {
  final int courseID;
  final Function onTaskDeleted;
  final int userID;


  const UserCourseDeleteAlert({
    Key? key,
    required this.courseID,
     required  this.userID,
    required this.onTaskDeleted,
  }) : super(key: key);

  @override
  _UserCourseDeleteAlertState createState() => _UserCourseDeleteAlertState();
}

class _UserCourseDeleteAlertState extends State<UserCourseDeleteAlert> {
  bool _isDeleting = false;

  Future<bool> deleteUserCourse(BuildContext context) async {
    setState(() => _isDeleting = true);

    try {
      var url = "userCourses/deleteUserCourse.php?courseID=${widget.courseID}&userID=${widget.userID}";
      final response = await http.get(Uri.parse(serverPath + url));

      print("Full Delete Response:");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Attempting to delete Course ID: ${widget.courseID}");
      print("Attempting to delete userID: ${widget.userID}");



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
              widget.onTaskDeleted();
              return true;
            } else {
              showErrorDialog(context, jsonResponse['message'] ?? 'Unknown error');
              return false;
            }
          } else {
            print("Unexpected response format");
            showErrorDialog(context, 'Unexpected response from the server.');
            return false;
          }
        } catch (e) {
          print("JSON parsing error: $e");
          showErrorDialog(context, 'Error parsing server response');
          return false;
        }
      } else {
        showErrorDialog(context, 'Failed to connect to the server');
        return false;
      }
    } catch (e) {
      print('Deletion Error: $e');
      setState(() => _isDeleting = false);
      showErrorDialog(context, 'An error occurred while deleting the course');
      return false;
    }
  }

  void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          const Text('Delete the student from the course', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      content: const Text('Are you sure you want to delete this student from your course?', style: TextStyle(fontSize: 16)),
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
            final result = await deleteUserCourse(context);
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
            child: CircularProgressIndicator(strokeWidth: 2),
          )
              : const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
