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
  State<MyTasksScreen> createState() => _MyTasksScreen();
}

class _MyTasksScreen extends State<MyTasksScreen> {
  late Future<List<Task>> _tasksFuture;
  String _searchTerm = '';
  String _filterStatus = 'all';
  String _sortBy = 'dueDate';
  bool _isAscending = true;
  bool _isFilterMenuOpen = false;

  // Map to store the completion status of tasks
  Map<int, bool> _taskCompletionStatus = {};

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

  void _toggleTaskCompletion(int taskId) async {
    try {
      // Toggle the status in the local map
      _taskCompletionStatus[taskId] = !(_taskCompletionStatus[taskId] ?? false);

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('task_${taskId}_completed', _taskCompletionStatus[taskId]!);

      // Update the UI by forcing a rebuild
      setState(() {});
    } catch (e) {
      print("Error toggling task completion: $e");
    }
  }

  List<Task> _filterAndSortTasks(List<Task> tasks) {
    // Apply status filter using the _taskCompletionStatus map
    var filteredTasks = tasks.where((task) {
      // Get completion status from our map, or fall back to task.isCompleted
      bool isCompleted = _taskCompletionStatus.containsKey(task.taskID)
          ? _taskCompletionStatus[task.taskID]!
          : task.isCompleted;

      if (_filterStatus == 'completed') return isCompleted;
      if (_filterStatus == 'pending') return !isCompleted;
      return true;
    }).toList();

    // Apply search filter
    if (_searchTerm.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.course.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            task.tutor.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }

    // Apply sorting
    filteredTasks.sort((a, b) {
      // Implementation of sorting logic would go here
      return 0; // Placeholder
    });

    return filteredTasks;
  }

  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];
    // Clear and rebuild the completion status map
    _taskCompletionStatus.clear();

    try {
      // Get SharedPreferences first
      final prefs = await SharedPreferences.getInstance();

      // Fetch tasks from API
      var url = "userTasks/getUserTasks.php?userID=${widget.userID}";
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        if (jsonData == null || jsonData is! List) {
          throw Exception("Invalid response format");
        }

        for (var i in jsonData) {
          // Create task from API
          Task task = Task.fromJson(i);

          // Check for locally stored completion status
          final savedStatus = prefs.getBool('task_${task.taskID}_completed');

          // Update our completion status map
          if (savedStatus != null) {
            _taskCompletionStatus[task.taskID] = savedStatus;
          } else {
            _taskCompletionStatus[task.taskID] = task.isCompleted;
            // Also save this initial value to SharedPreferences
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
      if (_sortBy == field) {
        _isAscending = !_isAscending;
      } else {
        _sortBy = field;
        _isAscending = true;
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
          // Search Bar
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
                  _searchTerm = value;
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

          if (_isFilterMenuOpen)
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
              future: _tasksFuture,
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
                          _searchTerm.isNotEmpty
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
                  final filteredTasks = _filterAndSortTasks(snapshot.data!);
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
                      // Use the completion status from our map
                      final isCompleted = _taskCompletionStatus[task.taskID] ?? task.isCompleted;

                      // Create a modified task with the correct completion status
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
                        onTaskDeleted: _refreshTasks,
                        onToggleCompletion: _toggleTaskCompletion,
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
    bool isActive = _filterStatus == value;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _filterStatus = value;
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
            if (_sortBy == value)
              Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
                color: const Color(0xFF3B82F6),
              ),
          ],
        ),
      ),
    );
  }
}