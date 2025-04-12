import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  bool _isFilterMenuOpen = false;
  String _sortBy = 'dueDate';
  bool _isAscending = true;
  Task? _selectedTask;

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
      var url = "userTasks/getUserTasks.php?userID=${widget.userID}";
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
      }
    } catch (e) {
      print("Error fetching tasks: $e");
    }
    return arr;
  }

  void _toggleTaskCompletion(int taskId) async {
    try {
      // This would normally call an API to update the task status
      // For now we'll just update it in the local state
      setState(() {
        _tasksFuture = _tasksFuture.then((tasks) {
          return tasks.map((task) {
            if (task.taskID == taskId) {
              return Task(
                taskID: task.taskID,
                tutor: task.tutor,
                course: task.course,
                day: task.day,
                time: task.time,
                isCompleted: !task.isCompleted,
                dueDate: task.dueDate,
              );
            }
            return task;
          }).toList();
        });
      });
    } catch (e) {
      print("Error toggling task completion: $e");
    }
  }

  List<Task> _filterAndSortTasks(List<Task> tasks) {
    // Filter based on status
    var filteredTasks = tasks.where((task) {
      if (_filterStatus == 'completed') return task.isCompleted;
      if (_filterStatus == 'pending') return !task.isCompleted;
      return true; // 'all' filter
    }).toList();

    if (_searchTerm.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.course.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            task.tutor.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }

    filteredTasks.sort((a, b) {
      int comparison;

      if (_sortBy == 'dueDate' && a.dueDate.isNotEmpty && b.dueDate.isNotEmpty) {
        try {
          comparison = DateTime.parse(a.dueDate).compareTo(DateTime.parse(b.dueDate));
        } catch (e) {
          comparison = 0;
        }
      } else if (_sortBy == 'course') {
        comparison = a.course.compareTo(b.course);
      } else {
        comparison = 0;
      }

      return _isAscending ? comparison : -comparison;
    });

    return filteredTasks;
  }

  void _toggleSort(String field) {
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTasks,
            tooltip: 'Refresh Tasks',
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterMenuOpen = !_isFilterMenuOpen;
              });
            },
            tooltip: 'Filter Tasks',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by course or tutor',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
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

          if (_isFilterMenuOpen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 3,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        'Filter by:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _filterChip('All', 'all'),
                        _filterChip('Pending', 'pending'),
                        _filterChip('Completed', 'completed'),
                      ],
                    ),
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 4.0),
                      child: Text(
                        'Sort by:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _sortChip('Due Date', 'dueDate'),
                        _sortChip('Course', 'course'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          // Tasks List
          Expanded(
            child: FutureBuilder<List<Task>>(
              future: _tasksFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Error loading tasks: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _refreshTasks,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks found',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                final filteredTasks = _filterAndSortTasks(snapshot.data!);

                if (filteredTasks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No tasks match your filters',
                      style: TextStyle(fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredTasks.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return TasksScreenDesign(
                      task: task,
                      isStudent: true,
                      onTaskDeleted: () {},
                      onToggleCompletion: (taskId) => _toggleTaskCompletion(taskId),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Add new task functionality coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _filterChip(String label, String value) {
    final isSelected = _filterStatus == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _filterStatus = value;
            });
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
      ),
    );
  }

  Widget _sortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            if (isSelected)
              Icon(
                _isAscending ? Icons.arrow_upward : Icons.arrow_downward,
                size: 16,
              ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            _toggleSort(value);
          }
        },
        backgroundColor: Colors.grey[200],
        selectedColor: Colors.blue[100],
      ),
    );
  }
}