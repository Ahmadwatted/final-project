import 'package:flutter/material.dart';

import '../../Models/clientConfig.dart';
import '../../Models/course.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<int> getCourseStunum(int courseID) async {
  try {
    var url = "getCourseDetails/getCourseStunum.php?courseID=$courseID";
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


class CoursesScreenDesign extends StatefulWidget {
  final Course courses;
  final bool isStudent;
  final Function() onTaskDeleted;
  final bool isGridView;

  const CoursesScreenDesign({
    Key? key,
    required this.courses,
    required this.isStudent,
    required this.onTaskDeleted,
    this.isGridView = true,
  }) : super(key: key);

  @override
  State<CoursesScreenDesign> createState() => _CoursesScreenDesignState();
}

class _CoursesScreenDesignState extends State<CoursesScreenDesign> {
  bool showNotes = false;
  late String notes;
  int? studentCount;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    notes = widget.courses.notes;
    if (!widget.isStudent) {
      _loadStudentCount();
    }
  }

  Future<void> _loadStudentCount() async {
    setState(() {
      isLoading = true;
    });

    try {
      final count = await getCourseStunum(widget.courses.courseID);

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

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      elevation: 1,
      child: widget.isGridView
          ? _buildGridLayout()
          : _buildListLayout(),
    );
  }

  Widget _buildGridLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 8,
          width: double.infinity,
          decoration: BoxDecoration(
            color: getCourseColor(widget.courses.courseID),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
        ),
        _buildCardContent(),
      ],
    );
  }

  Widget _buildListLayout() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 8,
            decoration: BoxDecoration(
              color: getCourseColor(widget.courses.courseID),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(child: _buildCardContent()),
        ],
      ),
    );
  }

  Widget _buildCardContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.courses.course,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.courses.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 12),
          _buildInfoRow(Icons.person_outline, widget.courses.tutor),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.location_on_outlined, widget.courses.location),
          const SizedBox(height: 6),
          _buildInfoRow(Icons.calendar_today_outlined, "${widget.courses.day}, ${widget.courses.time}"),

          if (!widget.isStudent)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: _buildStudentCountRow(),
            ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showNotes = !showNotes;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade100,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(showNotes ? "Hide Notes" : "Course Notes"),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to course details page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Details"),
                ),
              ),
            ],
          ),

          if (showNotes)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Add your course notes here...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 3,
                    minLines: 3,
                    onChanged: (value) {
                      setState(() {
                        notes = value;
                      });
                    },
                    controller: TextEditingController(text: notes),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Save notes functionality
                      widget.courses.notes = notes;
                      // Additional code to save notes to server/database
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Notes saved successfully"),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Save Notes"),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentCountRow() {
    if (isLoading) {
      return Row(
        children: [
          Icon(
            Icons.group_outlined,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(width: 8),

        ],
      );
    } else {
      return Row(
        children: [
          Icon(
            Icons.group_outlined,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 8),
          if(studentCount!=0)...{
            Text(

              "${studentCount!-1} Students",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          }
          else...{
            Text(

              "${studentCount ?? 0} Students",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          },

        ],
      );
    }
  }
}