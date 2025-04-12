import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Models/clientConfig.dart';
import '../../Models/task.dart';
import '../../utils/Widgets/Tasks_Screen_design.dart';

class TeacherTasksScreen extends StatefulWidget {
  final String title;
  final String userID;

  const TeacherTasksScreen({
    Key? key,
    required this.title,
    required this.userID,
  }) : super(key: key);

  @override
  State<TeacherTasksScreen> createState() => _TeacherTasksScreenState();
}

class _TeacherTasksScreenState extends State<TeacherTasksScreen> {
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
              // Create a new task with the isCompleted value toggled
              // Note: Since Task is immutable, we need to create a new instance
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

    // Filter based on search term
    if (_searchTerm.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.course.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            task.tutor.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }

    // Sort the tasks
    filteredTasks.sort((a, b) {
      int comparison;

      if (_sortBy == 'dueDate') {
        // Handle cases where dueDate might be empty
        if (a.dueDate.isEmpty || b.dueDate.isEmpty) {
          return a.dueDate.isEmpty && b.dueDate.isEmpty
              ? 0
              : a.dueDate.isEmpty ? 1 : -1;
        }

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
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              setState(() {
                _isFilterMenuOpen = !_isFilterMenuOpen;
              });
            },
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

          // Filter Tabs
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
                  _buildFilterTab('All', 'all', const Color(0xFF3B82F6)),
                  _buildFilterTab('Pending', 'pending', const Color(0xFFF59E0B)),
                  _buildFilterTab('Done', 'completed', const Color(0xFF10B981)),
                ],
              ),
            ),
          ),

          // Sort Options (Conditionally shown)
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        'Sort by',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Divider(height: 1),
                    _buildSortOption('Due Date', 'dueDate'),
                    _buildSortOption('Course Name', 'course'),
                  ],
                ),
              ),
            ),

          // Course Colors Legend
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Course Colors',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: [
                    _buildColorLegend(0, 'Advanced'),
                    _buildColorLegend(1, 'Data'),
                    _buildColorLegend(2, 'UX'),
                    _buildColorLegend(3, 'Machine'),
                    _buildColorLegend(4, 'Creative'),
                    _buildColorLegend(5, 'Database'),
                  ],
                ),
              ],
            ),
          ),

          // Task List
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
                            'No tasks found with current filters',
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
                        isStudent: false,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new task functionality
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Add new task functionality coming soon!'),
            ),
          );
        },
        backgroundColor: const Color(0xFF3B82F6),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterTab(String title, String value, Color activeColor) {
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

  Widget _buildSortOption(String title, String value) {
    return InkWell(
      onTap: () => _toggleSort(value),
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

  Widget _buildColorLegend(int index, String label) {
    Color color = getCourseColor(index);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Color getCourseColor(int courseId) {
    final colors = [
      const Color(0xFF3B82F6), // blue
      const Color(0xFF10B981), // green
      const Color(0xFFF59E0B), // orange
      const Color(0xFF8B5CF6), // purple
      const Color(0xFFEC4899), // pink
      const Color(0xFF14B8A6), // teal
    ];
    return colors[courseId % colors.length];
  }
}