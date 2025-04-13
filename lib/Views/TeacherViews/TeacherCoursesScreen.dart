import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../Models/clientConfig.dart';
import '../../Models/course.dart';
import '../../utils/Widgets/Courses_Screen_Design.dart';

class TeacherCoursesScreen extends StatefulWidget {
  final String title;
  final String userID;

  const TeacherCoursesScreen({Key? key, required this.title, required this.userID}) : super(key: key);

  @override
  State<TeacherCoursesScreen> createState() => _TeacherCoursesScreen();
}

class _TeacherCoursesScreen extends State<TeacherCoursesScreen> {
  late Future<List<Course>> _CoursesFuture;
  bool isStudent = false;
  String searchTerm = '';

  final TextEditingController _tutorController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Initialize with a dummy Future that completes immediately
    _CoursesFuture = Future.value([]);
    // Then refresh the tasks in a separate operation
    Future.microtask(() => _refreshTasks());
  }

  @override
  void dispose() {
    _tutorController.dispose();
    _courseController.dispose();
    _locationController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<int?> InsertCourse(String tutor, String course, String location, String day, String time, String description) async {
    var url = "https://darkgray-hummingbird-925566.hostingersite.com/watad/courses/insertCourse.php?"
        "tutor=${Uri.encodeComponent(tutor)}"
        "&course=${Uri.encodeComponent(course)}"
        "&location=${Uri.encodeComponent(location)}"
        "&day=${Uri.encodeComponent(day)}"
        "&time=${Uri.encodeComponent(time)}"
        "&description=${Uri.encodeComponent(description)}";

    print("InsertCourse - Final URL: $url");

    try {
      final response = await http.get(Uri.parse(url));
      print("InsertCourse Status Code: ${response.statusCode}");
      print("InsertCourse Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Parsed response data: $data");

        if (data['result'] == '1' && data['id'] != null) {
          print("Successfully created course with ID: ${data['id']}");
          return int.parse(data['id'].toString());
        } else {
          print("API returned unsuccessful result: ${data['result']}");
          return null;
        }
      }
      return null;
    } catch (e) {
      print("InsertCourse Error: $e");
      return null;
    }
  }
  Future<void> _refreshTasks() async {
    final courses = await getUserCourses();

    if (mounted) {
      setState(() {
        _CoursesFuture = Future.value(courses);
      });
    }
  }

  Future<List<Course>> getUserCourses() async {
    List<Course> arr = [];

    try {
      // Make sure your URL is fully qualified
      var url = "${serverPath}userCourses/getUserCourses.php?userID=${widget.userID}";
      print("Fetching user courses from: $url");

      final response = await http.get(Uri.parse(url));

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Handle empty response
        if (response.body.trim().isEmpty) {
          print("Empty response received");
          return [];
        }

        try {
          var jsonData = json.decode(response.body);

          if (jsonData == null) {
            print("Response body decoded to null");
            return [];
          }

          if (jsonData is! List) {
            print("Response is not a List. Received: $jsonData");
            // Try to handle the case where it's an object with an error message
            if (jsonData is Map && jsonData.containsKey('error')) {
              print("Error from API: ${jsonData['error']}");
            }
            return [];
          }

          for (var i in jsonData) {
            try {
              arr.add(Course.fromJson(i));
            } catch (e) {
              print('Error parsing course data: $e');
              // Continue with next item instead of failing completely
            }
          }
        } catch (e) {
          print('JSON parsing error: $e');
        }
      } else {
        print('HTTP error: ${response.statusCode}');
      }
    } catch (e) {
      print('Network error: $e');
    }

    return arr;
  }

  Future<bool> InsertUserCourse(int courseID) async {
    try {
      String userID = widget.userID;

      var url = "https://darkgray-hummingbird-925566.hostingersite.com/watad/userCourses/insertUserCourse.php?"
          "courseID=$courseID"
          "&userID=$userID";

      print("InsertUserCourse - Final URL: $url");

      final response = await http.get(Uri.parse(url));

      print("InsertUserCourse Response Status Code: ${response.statusCode}");
      print("InsertUserCourse Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        // Check if the result is a non-zero number (meaning success)
        if (data['result'] != null) {
          // Try parsing as int first to check if it's a numeric value
          try {
            int resultValue = int.parse(data['result'].toString());
            return resultValue > 0; // Consider any positive number a success
          } catch (e) {
            // If it can't be parsed as int, check if it's "1" (the original success condition)
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
      print("Error in InsertUserCourse: $e");
      return false;
    }
  }

  void _showAddCourseForm() {
    _tutorController.clear();
    _courseController.clear();
    _locationController.clear();
    _dayController.clear();
    _timeController.clear();
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
                          'Add New Course',
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

                    // Form fields
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
                              label: 'Course',
                              controller: _courseController,
                              hint: 'Enter course name',
                              icon: Icons.school_outlined,
                              isRequired: true,
                            ),
                            _buildFormField(
                              label: 'Location',
                              controller: _locationController,
                              hint: 'Enter location',
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
                              label: 'Time',
                              controller: _timeController,
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
                                content: Text('Adding course...'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color(0xFF1F2937),
                              ),
                            );

                            try {
                              int? newCourseID = await InsertCourse(
                                _tutorController.text,
                                _courseController.text,
                                _locationController.text,
                                _dayController.text,
                                _timeController.text,
                                _descriptionController.text,
                              );

                              print("Course created with ID: $newCourseID");

                              if (newCourseID != null) {
                                bool success = await InsertUserCourse(newCourseID);
                                print("User added to course: $success");

                                if (success) {
                                  ScaffoldMessenger.of(context).clearSnackBars();

                                  await _refreshTasks();

                                  // Close the form
                                  Navigator.pop(context);

                                  // Show success message with a slight delay
                                  Future.delayed(const Duration(milliseconds: 300), () {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Course successfully added!'),
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
                                      content: Text('Failed to add user to course. Please try again.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to add course. Please try again.'),
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
                          'Add Course',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          // Search Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search courses...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) {
                setState(() {
                  searchTerm = value;
                });
              },
            ),
          ),

          // Course list
          Expanded(
            child: FutureBuilder<List<Course>>(
              future: _CoursesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF1F2937)),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        const Text(
                          'Error loading courses',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: _refreshTasks,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                } else {
                  // Filter courses based on search term
                  final filteredCourses = snapshot.data!
                      .where((course) =>
                  searchTerm.isEmpty ||
                      course.course.toLowerCase().contains(searchTerm.toLowerCase()) ||
                      course.day.toLowerCase().contains(searchTerm.toLowerCase())
                  ).toList();

                  if (filteredCourses.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.builder(
                    itemCount: filteredCourses.length,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      final course = filteredCourses[index];
                      return CoursesScreenDesign(
                        courses: course,
                        isStudent: false,
                        onTaskDeleted: _refreshTasks,
                        isGridView: false,
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
        onPressed: _showAddCourseForm,
      ),
    );
  }

  Widget _buildEmptyState() {
    String message = searchTerm.isNotEmpty
        ? 'No courses matching "$searchTerm"'
        : 'You haven\'t created any courses yet.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'No courses found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}