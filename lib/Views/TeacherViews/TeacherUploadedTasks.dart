import 'dart:convert';
import 'package:final_project/utils/Widgets/Teacher_Tasks_Screen_Design.dart';
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
  final _formKey = GlobalKey<FormState>();

  late Future<List<Task>> _tasksFuture;
  String _searchTerm = '';
  String _filterStatus = 'all';
  String _sortBy = 'dueDate';
  bool _isAscending = true;
  final TextEditingController _tutorController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
  Future<int?> InsertTask(
      String tutor,
      String course,
      String time,
      String day,
      String isCompleted,
      String dueDate,
      String description) async {

    var url = "https://darkgray-hummingbird-925566.hostingersite.com/watad/tasks/insertTask.php?"
        "tutor=${Uri.encodeComponent(tutor)}"
        "&course=${Uri.encodeComponent(course)}"
        "&time=${Uri.encodeComponent(time)}"
        "&day=${Uri.encodeComponent(day)}"
        "&isCompleted=${Uri.encodeComponent(isCompleted)}"
        "&dueDate=${Uri.encodeComponent(dueDate)}"
        "&description=${Uri.encodeComponent(description)}";

    print("InsertTask - Final URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("InsertTask Status Code: ${response.statusCode}");
      print("InsertTask Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Parsed response data: $data");

        if (data['result'] == '1' && data['taskID'] != null) {
          print("Successfully created task with ID: ${data['taskID']}");
          return int.parse(data['taskID'].toString());
        } else {
          print("API returned unsuccessful result: ${data['result']}");
          return null;
        }
      }
      return null;
    } catch (e) {
      print("InsertTask Error: $e");
      return null;
    }
  }
  Future<bool> InsertUserTask(int taskID) async {
    try {
      String userID = widget.userID;

      var url = "https://darkgray-hummingbird-925566.hostingersite.com/watad/userTasks/insertUserTask.php?"
          "taskID=$taskID"
          "&userID=$userID";

      print("InsertUserTask - Final URL: $url");

      final response = await http.get(Uri.parse(url));

      print("InsertUserCourse Response Status Code: ${response.statusCode}");
      print("InsertUserCourse Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['result'] != null) {
          try {
            int resultValue = int.parse(data['result'].toString());
            return resultValue > 0;
          } catch (e) {
            return data['result'] == '1';
          }
        } else {
          print("Error: No result field in response");
          return false;
        }
      } else {
        print("Error: Server returned ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error in InsertUserTask: $e");
      return false;
    }
  }



  List<Task> filterAndSortTasks(List<Task> tasks) {
    var filteredTasks = tasks.where((task) {
      if (_filterStatus == 'Completed') return task.isCompleted;
      if (_filterStatus == 'Pending') return !task.isCompleted;
      return true; //
    }).toList();

    if (_searchTerm.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        return task.course.toLowerCase().contains(_searchTerm.toLowerCase()) ||
            task.tutor.toLowerCase().contains(_searchTerm.toLowerCase());
      }).toList();
    }

    filteredTasks.sort((a, b) {
      int comparison;

      if (_sortBy == 'dueDate') {
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

            ),
          ),


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
                      return TeacherTasksScreenDesign(
                        task: task,
                        isStudent: false,
                        onTaskDeleted: _refreshTasks,
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
        backgroundColor: Colors.white,
        elevation: 2,
        child: const Icon(Icons.add, color: Color(0xFF1F2937)),
        onPressed: (){

          showAddTaskForm();

        },
      ),
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

  void showAddTaskForm() {
    _tutorController.clear();
    _courseController.clear();
    _timeController.clear();
    _dayController.clear();
    _dueDateController.clear();
    _descriptionController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Add New Task',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            buildFormField(
                              label: 'Tutor',
                              controller: _tutorController,
                              hint: 'Enter Tutor name',
                              icon: Icons.person_2_outlined,
                              isRequired: true,
                            ),

                            buildFormField(
                              label: 'Course',
                              controller: _courseController,
                              hint: 'Enter course name',
                              icon: Icons.school_outlined,
                              isRequired: true,
                            ),
                            buildFormField(
                              label: 'Time',
                              controller: _timeController,
                              hint: 'Enter time',
                              icon: Icons.access_time_outlined,
                              isRequired: true,
                            ),
                            buildFormField(
                              label: 'Day',
                              controller: _dayController,
                              hint: 'Enter a day',
                              icon: Icons.calendar_today_outlined,
                              isRequired: true,
                            ),
                            buildFormField(
                              label: 'Due Date',
                              controller: _dueDateController,
                              hint: 'Enter due date (DD/MM/YYYY)',
                              icon: Icons.event_outlined,
                              isRequired: true,
                            ),
                            buildFormField(
                              label: 'Description (optional)',
                              controller: _descriptionController,
                              hint: 'Enter task description',
                              icon: Icons.description_outlined,
                              isRequired: false,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Submit button
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1F2937),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Show loading indicator
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Adding task...'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color(0xFF1F2937),
                              ),
                            );

                            try {
                              String isCompleted = "0";

                              int? newTaskID = await InsertTask(
                                _tutorController.text,
                                _courseController.text,
                                _timeController.text,
                                _dayController.text,
                                isCompleted,
                                _dueDateController.text,
                                _descriptionController.text,
                              );

                              print("Task created with ID: $newTaskID");

                              if (newTaskID != null) {
                                bool success = await InsertUserTask(newTaskID);
                                print("User added to task: $success");

                                if (success) {
                                  ScaffoldMessenger.of(context).clearSnackBars();

                                   _refreshTasks();

                                  Navigator.pop(context);

                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Task successfully added!'),
                                          backgroundColor: Color(0xFF1F2937),
                                        ),
                                      );
                                    }
                                  });

                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                      });
                                    }
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Failed to add user to task. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to add task. Please try again.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              print("Error in form submission: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error: $e'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Add Task',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isRequired,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400),
              prefixIcon: Icon(icon, color: const Color(0xFF6B7280), size: 20),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFF9CA3AF)),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            validator: isRequired
                ? (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            }
                : null,
          ),
        ],
      ),
    );
  }

}
