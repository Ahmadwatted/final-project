import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/clientConfig.dart';
import '../../Models/task.dart';
import '../../utils/Widgets/Tasks_Screen_design.dart';

class MyTasksScreen extends StatefulWidget {
  final String title;
  final String userID;
  const MyTasksScreen({
    Key? key,
    required this.title,
    required this.userID,
  }) : super(key: key);
  @override
  State<MyTasksScreen> createState() => MyTasksScreenState();
}

class MyTasksScreenState extends State<MyTasksScreen> {
  late Future<List<Task>> tasksFuture;
  String searchTerm = '';
  String filterStatus = 'all';
  String sortBy = 'dueDate';
  bool isAscending = true;
  bool isFilterMenuOpen = false;
  Map<int, bool> taskCompletionStatus = {};
  @override
  void initState() {
    super.initState();
    refreshTasks();
  }
  void refreshTasks() {
    setState(() {
      tasksFuture = getUserTasks();
    });
  }
  void toggleTaskCompletion(int taskId) async {
    try {
      taskCompletionStatus[taskId] = !(taskCompletionStatus[taskId] ?? false);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('task_${taskId}_completed', taskCompletionStatus[taskId]!);
      setState(() {});
    } catch (e) {
      print("Error toggling task completion: $e");
    }
  }
  List<Task> filterAndSortTasks(List<Task> tasks) {
    var filteredTasks = tasks.where((task) {
      bool isCompleted = taskCompletionStatus.containsKey(task.taskID)
          ? taskCompletionStatus[task.taskID]!
          : task.isCompleted;
      if (filterStatus == 'completed') return isCompleted;
      if (filterStatus == 'pending') return !isCompleted;
      return true;
    }).toList();
    if (searchTerm.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.course.toLowerCase().contains(searchTerm.toLowerCase()) ||
            task.tutor.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
    }
    filteredTasks.sort((a, b) {
      return 0;
    });
    return filteredTasks;
  }
  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];
    taskCompletionStatus.clear();
    try {
      final prefs = await SharedPreferences.getInstance();
      var url = "userTasks/getUserTasks.php?userID=${widget.userID}";
      final response = await http.get(Uri.parse(serverPath + url));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData == null || jsonData is! List) {
          throw Exception("Invalid response format");
        }
        for (var i in jsonData) {
          Task task = Task.fromJson(i);
          final savedStatus = prefs.getBool('task_${task.taskID}_completed');
          if (savedStatus != null) {
            taskCompletionStatus[task.taskID] = savedStatus;
          } else {
            taskCompletionStatus[task.taskID] = task.isCompleted;
            await prefs.setBool('task_${task.taskID}_completed', task.isCompleted);
          }
          arr.add(task);
        }
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
    return arr;
  }
  void toggleSort(String field) {
    setState(() {
      if (sortBy == field) {
        isAscending = !isAscending;
      } else {
        sortBy = field;
        isAscending = true;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3DFD6),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  buildFilterTab('All', 'all', const Color(0xFF3B82F6)),
                  buildFilterTab('Pending', 'pending', const Color(0xFFF59E0B)),
                  buildFilterTab('Done', 'completed', const Color(0xFF10B981)),
                ],
              ),
            ),
          ),
          if (isFilterMenuOpen)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Error loading tasks, please try again',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.notifications_none,
                          size: 64,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchTerm.isNotEmpty
                              ? 'No tasks found for this search'
                              : 'No tasks available',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  final filteredTasks = filterAndSortTasks(snapshot.data!);
                  if (filteredTasks.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.notifications_none,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Keep going :)',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      final task = filteredTasks[index];
                      final isCompleted = taskCompletionStatus[task.taskID] ?? task.isCompleted;
                      final updatedTask = Task(
                        taskID: task.taskID,
                        tutor: task.tutor,
                        course: task.course,
                        day: task.day,
                        time: task.time,
                        isCompleted: isCompleted,
                        dueDate: task.dueDate,
                        description: task.description,
                      );
                      return TasksScreenDesign(
                        task: updatedTask,
                        isStudent: true,
                        onTaskDeleted: refreshTasks,
                        onToggleCompletion: toggleTaskCompletion,
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget buildFilterTab(String title, String value, Color activeColor) {
    bool isActive = filterStatus == value;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            filterStatus = value;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
  Widget buildSortOption(String title, String value) {
    return InkWell(
      onTap: () => toggleSort(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14),
            ),
            if (sortBy == value)
              Icon(
                isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: const Color(0xFF3B82F6),
              ),
          ],
        ),
      ),
    );
  }
}