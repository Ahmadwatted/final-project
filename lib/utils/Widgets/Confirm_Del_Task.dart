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
  TaskDeleteAlertState createState() => TaskDeleteAlertState();
}

class TaskDeleteAlertState extends State<TaskDeleteAlert> {
  bool isDeleting = false;
  bool isddd= false;

  final String successMessage = 'تم حذف المهمة بنجاح';
  final String errorMessage = 'فشل في حذف المهمة، يرجى المحاولة مرة أخرى';
  final String networkErrorMessage =
      'حدث خطأ في الاتصال، يرجى التحقق من اتصالك بالإنترنت';
  Future<bool> deleteTask(BuildContext context) async {
    setState(() => isDeleting = true);
    try {
      var url = "tasks/deleteTask.php?taskID=${widget.taskID}";
      final response = await http.get(Uri.parse(serverPath + url));
      print("Full Delete Response:");
      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      print("Attempting to delete Task ID: ${widget.taskID}");

      setState(() => isDeleting = false);

      if (response.statusCode == 200) {
        if (response.body.trim().startsWith('[')) {
          print(
              "Server returned a list of tasks instead of a deletion confirmation");
          showMessage(context, errorMessage, isSuccess: false);
          return false;
        }

        try {
          var jsonResponse = json.decode(response.body);

          print("JSON Response: $jsonResponse");

          if (jsonResponse is Map && jsonResponse.containsKey('result')) {
            if (jsonResponse['result'] == '1' || jsonResponse['result'] == 1) {
              widget.onTaskDeleted?.call();
              showMessage(context, successMessage, isSuccess: true);
              return true;
            } else {
              String serverMessage = jsonResponse['message'] ?? 'Unknown error';
              print("Deletion failed: $serverMessage");
              showMessage(context, errorMessage, isSuccess: false);
              return false;
            }
          } else {
            print("Unexpected response format");
            showMessage(context, errorMessage, isSuccess: false);
            return false;
          }
        } catch (e) {
          print("JSON parsing error: $e");
          showMessage(context, errorMessage, isSuccess: false);
          return false;
        }
      } else {
        showMessage(context, errorMessage, isSuccess: false);
        return false;
      }
    } catch (e) {
      print('Deletion Error: $e');
      setState(() => isDeleting = false);
      showMessage(context, networkErrorMessage, isSuccess: false);
      return false;
    }
  }

  void showMessage(BuildContext context, String message,
      {required bool isSuccess}) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            textAlign: TextAlign.right,
          ),
          backgroundColor: isSuccess ? Colors.green : Colors.red,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    });
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
          Text('حذف المهمة',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ],
      ),
      content: Text('هل أنت متأكد أنك تريد حذف هذه المهمة؟',
          style: TextStyle(fontSize: 16)),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        ElevatedButton(
          onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[300],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('إلغاء', style: TextStyle(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: isDeleting
              ? null
              : () async {
                  final result = await deleteTask(context);
                  Navigator.of(context).pop(result);
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: isDeleting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : Text('حذف', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
