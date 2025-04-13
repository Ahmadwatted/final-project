import 'package:final_project/utils/Widgets/Confirm_Del_Task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/task.dart';

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
  bool _isCompleted = false; // Local state to track completion

  @override
  void initState() {
    super.initState();
    _loadCompletionStatus();
  }

  Future<void> _loadCompletionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final savedStatus = prefs.getBool('task_${widget.task.taskID}_completed');

    // If we have a saved status, use it; otherwise use the task's initial value
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
      // Parse the date in DD/MM/YYYY format
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

                        // Delete button for non-students
                        if (!widget.isStudent)
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
                  // Check if description exists before displaying it
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