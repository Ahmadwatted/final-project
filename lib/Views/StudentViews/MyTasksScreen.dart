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
  // In MyTasksScreen class - replace this entire method
  void _toggleTaskCompletion(int taskId) async {
    try {
      // Load the current tasks list
      final currentTasks = await _tasksFuture;

      // Find the task and toggle its completion status in memory
      final updatedTasks = currentTasks.map((task) {
        if (task.taskID == taskId) {
          return Task(
            taskID: task.taskID,
            tutor: task.tutor,
            course: task.course,
            day: task.day,
            time: task.time,
            isCompleted: !task.isCompleted,
            dueDate: task.dueDate,
            description: task.description,
          );
        }
        return task;
      }).toList();

      // Update the SharedPreferences directly
      final prefs = await SharedPreferences.getInstance();
      final taskToUpdate = updatedTasks.firstWhere((task) => task.taskID == taskId);
      await prefs.setBool('task_${taskId}_completed', taskToUpdate.isCompleted);

      // Update the state with the new task list
      setState(() {
        _tasksFuture = Future.value(updatedTasks);
        // Force refresh by triggering a rebuild
        _filterStatus = _filterStatus; // This forces the filter to be reapplied
      });
    } catch (e) {
      print("Error toggling task completion: $e");
    }
  }

// And also fix the _filterAndSortTasks method to ensure proper filtering
  List<Task> _filterAndSortTasks(List<Task> tasks) {
    // First apply the status filter
    var filteredTasks = tasks.where((task) {
      bool taskCompletionStatus = task.isCompleted;

      // Get the stored completion status if available
      try {
        final prefs = SharedPreferences.getInstance();
        prefs.then((p) {
          final savedStatus = p.getBool('task_${task.taskID}_completed');
          if (savedStatus != null) {
            taskCompletionStatus = savedStatus;
          }
        });
      } catch (e) {
        print("Error reading completion status: $e");
      }

      if (_filterStatus == 'completed') return taskCompletionStatus;
      if (_filterStatus == 'pending') return !taskCompletionStatus;
      return true; // 'all' filter
    }).toList();

    // Then apply the search filter if needed
    if (_searchTerm.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.course.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            task.tutor.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }

    return filteredTasks;
  }

  Future<List<Task>> getUserTasks() async {
    List<Task> arr = [];

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
          // Create task from API (isCompleted will be false)
          Task task = Task.fromJson(i);

          // Check for locally stored completion status
          final savedStatus = prefs.getBool('task_${task.taskID}_completed');

          if (savedStatus != null) {
            // We have a local status, use it
            task = Task(
              taskID: task.taskID,
              tutor: task.tutor,
              course: task.course,
              day: task.day,
              time: task.time,
              isCompleted: savedStatus,
              dueDate: task.dueDate,
              description: task.description,
            );
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
                      return TasksScreenDesign(
                        task: task,
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