import 'dart:convert';

import 'package:final_project/utils/Widgets/Tasks_Screen_design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Models/clientConfig.dart';
import '../../Models/task.dart';
import '../../ViewModels/StudentMain_VM.dart';
import 'package:http/http.dart' as http;

class MyTasksScreen extends StatelessWidget {
  final String title;

  const MyTasksScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _MyTasksScreen(title: title),
    );
  }
}

class _MyTasksScreen extends StatefulWidget {
  final String title;

  const _MyTasksScreen({required this.title});

  @override
  State<_MyTasksScreen> createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<_MyTasksScreen> {
  late Future<List<Task>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  void _refreshTasks() {
    setState(() {
      _tasksFuture = getUserTasks();
    });
  }

  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];

    try {
      var url = "userTasks/getUserTasks.php?userID=1";
      final response = await http.get(Uri.parse(serverPath + url));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception("Response body is null");
        }
        if (jsonData is! List) {
          throw Exception("Response is not a List. Received: $jsonData");
        }

        for (var i in jsonData) {
          arr.add(Task.fromJson(i));
        }

        String tasksString = arr
            .map((task) =>
        '${task.taskID}, ${task.tutor}, ${task.course}, ${task.day},${task.time}')
            .join(', ');

        // print("Formatted Task List: $tasksString");
      } else {
        // throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      // print('Error: $e');
    }
    return arr;
  }

  @override
  Widget build(BuildContext context) {

    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
        backgroundColor: const Color(0xFFE3DFD6),
        appBar: AppBar(
          title: const Text('Uploaded tasks'),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        body: FutureBuilder<List<Task>>(
          future: _tasksFuture,
          builder: (context, projectSnap) {
            if (projectSnap.hasData) {
              if (projectSnap.data?.isEmpty ?? true) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 2,
                  child: const Align(
                      alignment: Alignment.center,
                      child: Text('No Tasks Yet',
                          style: TextStyle(fontSize: 23, color: Colors.black))),
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: ListView.builder(
                          itemCount: projectSnap.data?.length,
                          itemBuilder: (context, index) {
                            Task task = projectSnap.data![index];

                            return TasksScreenDesign(
                              task: task,
                              isStudent: true,
                              onTaskDeleted: _refreshTasks,
                            );
                          },
                        )),
                  ],
                );
              }
            } else if (projectSnap.hasError) {
              return const Center(
                  child: Text('שגיאה, נסה שוב',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)));
            }
            return const Center(
                child: CircularProgressIndicator(color: Colors.red));
          },
        ));
  }
}