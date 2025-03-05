import 'dart:convert';
import '../Models/task.dart';
import '../Models/user.dart';
import 'package:final_project/Views/TeacherViews/MainTeacherScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Views/EditProfile.dart';
import 'package:final_project/Views/ListPage.dart';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';
import 'package:http/http.dart' as http;

import '../Models/clientConfig.dart';

class MainAppPage extends StatefulWidget {

  const MainAppPage({super.key, required this.title});

  final String title;


  @override
  State<MainAppPage> createState() => _MainAppPage();
}
class _MainAppPage extends State<MainAppPage> {

  @override
  Widget build(BuildContext context) {


    Future<List<User>> getUsers() async {
      List<User> arr = [];

      try {
        var url = "users/getUsers.php";
        final response = await http.get(Uri.parse(serverPath + url));

        print("Response Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          // Check if jsonData is null or not a list
          if (jsonData == null) {
            throw Exception("Response body is null");
          }
          if (jsonData is! List) {
            throw Exception("Response is not a List. Received: $jsonData");
          }

          for (var i in jsonData) {
            arr.add(User.fromJson(i));
          }

          String usersString = arr.map((user) =>
          '${user.firstName}, ${user.secondName}, ${user.email}, ${user.phoneNumber}'
          ).join(', ');
                    print("Formatted User List: $usersString");
        } else {
          throw Exception('Failed to load users: ${response.statusCode}');
        }
      } catch (e) {

        print('Error: $e');

      }
      return arr;
    }


    String tasksList='';

    Future<List<Task>> getTasks() async {
      List<Task> arr = [];

      try {
        var url = "tasks/getTasks.php";
        final response = await http.get(Uri.parse(serverPath + url));

        print("Response Status Code: ${response.statusCode}");
         print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);

          // Check if jsonData is null or not a list
          if (jsonData == null) {
            throw Exception("Response body is null");
          }
          if (jsonData is! List) {
            throw Exception("Response is not a List. Received: $jsonData");
          }

          for (var i in jsonData) {
            arr.add(Task.fromJson(i));
          }

          String tasksString = arr.map((task) =>
          '${task.taskID}, ${task.tutor}, ${task.course}, ${task.day},${task.time}'
          ).join(', ');



          print("Formatted Task List: $tasksString");
        } else {
          throw Exception('Failed to load tasks: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
      }
      return arr;
    }
    // void printTasks() async {
    //   String tasks = (await getTasks()) as String;
    //   setState(() {
    //     tasksList = tasks;
    //   });
    //   print(tasksList);
    // }





    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE3DFD6),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MainStudentScreen(title: 'tomainapppage')),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sign-in',
                        style: TextStyle(
                          color: Colors.deepOrange[200],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Mainteacherscreen(title: 'tomainapppage')),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sign-in2',
                        style: TextStyle(
                          color: Colors.deepOrange[200],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: screenWidth,
        height: 50,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MainAppPage(title: 'tomainpage')),
                    );
                  },
                  child: Icon(Icons.home)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ListPage(title: 'toprofilepage')),
                    );
                  },
                  child: Icon(CupertinoIcons.list_bullet_indent)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const EditProfile(title: 'toprofilepage')),
                    );
                  },
                  child: Icon(CupertinoIcons.profile_circled))
            ],

          ),
        ),

      ),
    );
  }
}
