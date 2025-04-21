import 'dart:convert';

import 'package:final_project/utils/Widgets/Confirm_Del_Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/clientConfig.dart';
import '../../Models/task.dart';
import 'package:http/http.dart' as http;

import '../../Models/user.dart';
import 'Confirm_Del_UserTask.dart';
import 'Courses_Screen_Design.dart';

class TasksScreenDesign extends StatefulWidget {
  final Task task;
  final bool isStudent;
  final Function onTaskDeleted;
  final Function? onToggleCompletion;
  final Function? onToggleBookmark;

  const TasksScreenDesign({
    Key? key,
    required this.task,
    required this.isStudent,
    required this.onTaskDeleted,
    this.onToggleCompletion,
    this.onToggleBookmark,
  }) : super(key: key);

  @override
  State<TasksScreenDesign> createState() => _TasksScreenDesignState();
}

class _TasksScreenDesignState extends State<TasksScreenDesign> {
  bool isExpanded = false;
  bool _isCompleted = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  bool _isLoadingStudents = false;
  List<User> _taskStudents = [];
  int? studentCount;




  final TextEditingController _tutorController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }
  Future<void> _loadStudentCount() async {
    setState(() {
      isLoading = true;
    });

    try {
      final count = await getTaskStunum(widget.task.taskID);

      if (mounted) {
        setState(() {
          studentCount = count;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          studentCount = 0;
          isLoading = false;
        });
      }
    }
  }
  Future<void> showTaskStudents() async {
    setState(() {
      _isLoadingStudents = true;
    });

    try {
      final students = await getTaskStudents(widget.task.taskID);

      if (mounted) {
        setState(() {
          _taskStudents = students;
          _isLoadingStudents = false;
        });

        if (mounted) {
          _showStudentsBottomSheet();
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingStudents = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to load students: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
  void _showAddStudentForm(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        _emailController.clear();
        _phoneNumberController.clear();
        bool isLoading = false;

        return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Add New Student'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildFormField(
                        label: 'Student e-Mail',
                        controller: _emailController,
                        hint: 'Enter Student e-Mail',
                        icon: Icons.person_outline,
                        isRequired: true,
                      ),
                      _buildFormField(
                        label: 'Student PhoneNumber',
                        controller: _phoneNumberController,
                        hint: 'Enter Student PhoneNumber',
                        icon: Icons.school_outlined,
                        isRequired: true,
                      ),
                      if (isLoading)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text('Processing...'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: isLoading ? null : () {
                      Navigator.of(dialogContext).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: isLoading ? null : () async {
                      // Show loading indicator
                      setState(() {
                        isLoading = true;
                      });

                      int uID = await getUserID(_emailController.text, _phoneNumberController.text);

                      if(uID == 0) {
                        Navigator.of(dialogContext).pop();
                        Navigator.pop(context);

                        scaffoldContext.showSnackBar(
                          const SnackBar(
                            content: Text('No student found with the matching credentials'),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        bool success = await InsertUserTask(uID, widget.task.taskID);

                        // Close the dialog
                        Navigator.of(dialogContext).pop();
                        // Close the bottom sheet
                        Navigator.pop(context);

                        if (success) {
                          scaffoldContext.showSnackBar(
                            const SnackBar(
                              content: Text('Added Student successfully'),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );

                          Future.delayed(Duration(milliseconds: 300), () {
                            if (mounted) {
                              showTaskStudents();
                              _loadStudentCount();
                            }
                          });
                        } else {
                          scaffoldContext.showSnackBar(
                            const SnackBar(
                              content: Text('Failed to add student to course'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }

  Future<void> _loadCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatus = prefs.getBool('task_${widget.task.taskID}_completed');

    if (savedStatus != null) {
      setState(() {
        _isCompleted = savedStatus;
      });
    } else {
      setState(() {
        _isCompleted = widget.task.isCompleted;
      });
    }
  }
  Future<bool> InsertUserTask(int userID, int taskID) async {
    try {

      var url = "https://darkgray-hummingbird-925566.hostingersite.com/watad/userTasks/insertUserTask.php?"
          "taskID=$taskID"
          "&userID=$userID";

      print("InsertUserTask - Final URL: $url");

      final response = await http.get(Uri.parse(url));

      print("InsertUserTask Response Status Code: ${response.statusCode}");
      print("InsertUserTask Response Body: ${response.body}");

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
  Future<int> getTaskStunum(int taskID) async {
    try {
      var url = "getTaskDetails/getTaskStunum.php?taskID=$taskID";
      final fullUrl = serverPath + url;

      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          return 0;
        }

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('studentCount')) {
          var count = jsonData['studentCount'];
          if (count is int) {
            return count;
          } else if (count is String) {
            return int.tryParse(count) ?? 0;
          }
          return 0;
        }

        return 0;
      } else {
        throw Exception("Failed to load student count: ${response.statusCode}");
      }
    } catch (e) {
      return 0;
    }
  }
  Future<List<User>> getTaskStudents(int taskID) async {
    List<User> arr = [];

    try {
      var url = "getTaskDetails/getTaskStudents.php?taskID=$taskID";
      print("Fetching task Students with URL: ${serverPath + url}");
      final response = await http.get(Uri.parse(serverPath + url));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);

        if (jsonData == null) {
          throw Exception("Response body is null");
        }

        if (jsonData is Map<String, dynamic> && jsonData.containsKey('users')) {
          var users = jsonData['users'];

          if (users is List) {
            for (var user in users) {
              arr.add(User.fromJson(user));
            }
          } else {
            throw Exception("'users' is not a List. Received: $users");
          }
        } else {
          throw Exception("Response does not contain 'users' array. Received: $jsonData");
        }
      } else {
        print('Failed to load Task Students: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error in get TaskStudents: $e');
    }
    print("Returning ${arr.length} task Students");
    return arr;
  }

  void showEditTaskForm() {
    _tutorController.text = widget.task.tutor;
    _courseController.text = widget.task.course;
    _timeController.text = widget.task.time;
    _dayController.text = widget.task.day;
    _dueDateController.text = widget.task.dueDate;
    _descriptionController.text = widget.task.description;
    bool isCompleted = widget.task.isCompleted;

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
                          'Edit Task',
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
                            _buildFormField(
                              label: 'Tutor',
                              controller: _tutorController,
                              hint: 'Enter tutor name',
                              icon: Icons.person_outline,
                              isRequired: true,
                            ),
                            _buildFormField(
                              label: 'Task ',
                              controller: _courseController,
                              hint: 'Enter task subject name',
                              icon: Icons.school_outlined,
                              isRequired: true,
                            ),
                            _buildFormField(
                              label: 'Time',
                              controller: _timeController,
                              hint: 'Enter for which time the task is up for',
                              icon: Icons.location_on_outlined,
                              isRequired: true,
                            ),
                            _buildFormField(
                              label: 'Day',
                              controller: _dayController,
                              hint: 'Enter a day',
                              icon: Icons.calendar_today_outlined,
                              isRequired: true,
                            ),
                            _buildFormField(
                              label: 'Due Date',
                              controller: _dueDateController,
                              hint: 'Enter time',
                              icon: Icons.access_time_outlined,
                              isRequired: true,
                            ),
                            _buildFormField(
                              label: 'Description (optional)',
                              controller: _descriptionController,
                              hint: 'Enter course description',
                              icon: Icons.description_outlined,
                              isRequired: false,
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),

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
                                content: Text('Updating course...'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color(0xFF1F2937),
                              ),
                            );

                            try {
                              bool success = await EditTask(
                                  widget.task.taskID,
                                  _tutorController.text,
                                  _courseController.text,
                                  _timeController.text,
                                  _dayController.text,
                                  _dueDateController.text,
                                  _descriptionController.text,
                                  isCompleted
                              );

                              print("Task updated: $success");

                              if (success) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                Navigator.pop(context);

                                widget.onTaskDeleted();

                                Future.delayed(const Duration(milliseconds: 300), () {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Task successfully updated!'),
                                        backgroundColor: Color(0xFF1F2937),
                                      ),
                                    );
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to update task. Please try again.'),
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
                          'Save Changes',
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

  void _showStudentsBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Students',
                        style: const TextStyle(
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

                  // Student count
                  Text(
                    "${_taskStudents.length} Students Enrolled",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Student list
                  Expanded(
                    child: _taskStudents.isEmpty
                        ? Center(
                      child: Text(
                        "No students enrolled in this course yet",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                        ),
                      ),
                    )
                        : ListView.separated(
                      itemCount: _taskStudents.length,
                      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.shade200),
                      itemBuilder: (context, index) {
                        final student = _taskStudents[index];
                        final fullName = "${student.firstName ?? ''} ${student.secondName ?? ''}".trim();
                        print(student.userID);

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: getCourseColor(widget.task.taskID),
                            child: Text(
                              fullName.isNotEmpty
                                  ? fullName.substring(0, 1).toUpperCase()
                                  : "?",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            fullName.isNotEmpty ? fullName : "Unknown",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (student.email.isNotEmpty)
                                Text(
                                  "Email: ${student.email}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              if (student.phoneNumber.isNotEmpty)
                                Text(
                                  "Phone: ${student.phoneNumber}",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                            ],
                          ),

                          trailing: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) => UserTaskDeleteAlert(
                                  userID: student.userID,
                                  taskID: widget.task.taskID,
                                  onTaskDeleted: () {

                                    Navigator.pop(context);
                                    showTaskStudents();
                                    _loadStudentCount();

                                  },
                                ),
                              ).then((result) {
                                if (result != null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        result == true
                                            ? 'Student removed successfully!'
                                            : 'Failed to remove student.',
                                      ),
                                      backgroundColor: result == true ? Colors.green : Colors.red,
                                    ),
                                  );
                                }
                              });
                            },
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                              size: 20,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                elevation: 2,
                child: const Icon(Icons.add, color: Color(0xFF1F2937)),
                onPressed: () {
                  _showAddStudentForm(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> EditTask(int taskID, String tutor, String course, String time, String day, String dueDate, String description, bool isCompleted) async {
    try {
      String descriptionValue = description.isNotEmpty ? description : "";

      var url = "${serverPath}tasks/updateTask.php?"
          "taskID=$taskID"
          "&tutor=${Uri.encodeComponent(tutor)}"
          "&course=${Uri.encodeComponent(course)}"
          "&time=${Uri.encodeComponent(time)}"
          "&day=${Uri.encodeComponent(day)}"
          "&dueDate=${Uri.encodeComponent(dueDate)}"
          "&description=${Uri.encodeComponent(descriptionValue)}"
          "&isCompleted=${isCompleted ? '1' : '0'}";

      print("EditTask - Final URL: $url");

      final response = await http.get(Uri.parse(url));
      print("EditTask Status Code: ${response.statusCode}");
      print("EditTask Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Parsed response data: $data");

        // Check if the result is a success indicator
        if (data['result'] == '1' || data['result'] == 1) {
          print("Successfully updated task with ID: $taskID");
          return true;
        } else {
          print("API returned unsuccessful result: ${data['result']}");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("EditTask Error: $e"); // Changed from EditCourse to EditTask for clarity
      return false;
    }
  }

  Widget _buildFormField({
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

  Future<void> _saveCompletionStatus(bool isCompleted) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('task_${widget.task.taskID}_completed', isCompleted);
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

  String getDaysRemaining(String dueDate) {
    if (dueDate.isEmpty) return 'No due date';

    final today = DateTime.now();

    try {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final due = formatter.parse(dueDate);

      final difference = due.difference(today).inDays;

      if (difference < 0) return 'Overdue';
      if (difference == 0) return 'Due today';
      return '$difference days left';
    } catch (e) {
      print('Error parsing date: $e');
      return 'Invalid date';
    }
  }

  void _toggleCompletion() async {
    setState(() {
      _isCompleted = !_isCompleted;
    });

    await _saveCompletionStatus(_isCompleted);

    if (widget.onToggleCompletion != null) {
      widget.onToggleCompletion!(widget.task.taskID);
    }
  }

  void _showDeleteConfirmation() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => TaskDeleteAlert(
        taskID: widget.task.taskID,
        onTaskDeleted: widget.onTaskDeleted,
      ),
    );

    if (result == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('task_${widget.task.taskID}_completed');

      widget.onTaskDeleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseColor = getCourseColor(widget.task.taskID);
    final daysRemaining = getDaysRemaining(widget.task.dueDate);
    final isDueToday = daysRemaining == 'Due today';
    final isOverdue = daysRemaining == 'Overdue';

    final isCompleted = _isCompleted;

    Color borderColor;
    if (isCompleted) {
      borderColor = const Color(0xFF10B981);
    } else if (isOverdue) {
      borderColor = const Color(0xFFEF4444);
    } else if (isDueToday) {
      borderColor = const Color(0xFFF59E0B);
    } else {
      borderColor = courseColor;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border(
          left: BorderSide(
            color: borderColor,
            width: 4,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: courseColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.task.course,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                decoration: isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                decorationColor: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if(widget.isStudent)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _toggleCompletion,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  isCompleted
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: isCompleted
                                      ? const Color(0xFF10B981)
                                      : Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),

                        if (!widget.isStudent) ...[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: showEditTaskForm,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.mode_edit,
                                  color: Colors.grey,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: showTaskStudents,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.people_outline,
                                  color: Colors.blueAccent,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: _showDeleteConfirmation,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.redAccent,
                                  size: 22,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              setState(() {
                                isExpanded = !isExpanded;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.task.day,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.task.time,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: Colors.black12),
                  const SizedBox(height: 12),
                  if (widget.task.description != null && widget.task.description.isNotEmpty)
                    Text(
                      widget.task.description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    )
                  else
                    const Text(
                      '',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tutor: ${widget.task.tutor}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: isOverdue
                              ? const Color(0xFFFEE2E2)
                              : isDueToday
                              ? const Color(0xFFFEF3C7)
                              : const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          daysRemaining,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isOverdue
                                ? const Color(0xFFB91C1C)
                                : isDueToday
                                ? const Color(0xFF92400E)
                                : const Color(0xFF1E40AF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );

  }
}