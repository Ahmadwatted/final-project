import 'package:final_project/Models/user.dart';
import 'package:final_project/utils/Widgets/Confirm_Del_UserCourse.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/clientConfig.dart';
import '../../Models/course.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Confirm_Del_Course.dart';

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

      if (jsonData is Map<String, dynamic> &&
          jsonData.containsKey('studentCount')) {
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

Future<int> getUserID(String email, String phoneNumber) async {
  try {
    var url = "users/getUserID.php?email=$email&phoneNumber=$phoneNumber";

    final response = await http.get(Uri.parse(serverPath + url));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);

      if (jsonData == null) {
        return 0;
      }

      if (jsonData is Map<String, dynamic>) {
        var userID = jsonData['userID'];
        if (userID is int) {
          return userID;
        } else if (userID is String) {
          return int.tryParse(userID) ?? 0;
        }
        return 0;
      }

      return 0;
    } else {
      throw Exception("Failed to load user ID: ${response.statusCode}");
    }
  } catch (e) {
    print("Error getting user ID: $e");
    return 0;
  }
}

Future<List<User>> getCourseStudents(int courseID) async {
  List<User> arr = [];

  try {
    var url = "getCourseDetails/getCourseStudents.php?courseID=$courseID";
    print("Fetching Course Students with URL: ${serverPath + url}");
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
        throw Exception(
            "Response does not contain 'users' array. Received: $jsonData");
      }
    } else {
      print(
          'Failed to load Course Students: ${response.statusCode}, ${response.body}');
    }
  } catch (e) {
    print('Error in get CourseStudents: $e');
  }
  print("Returning ${arr.length} course Students");
  return arr;
}

Future<bool> InsertUserCourse(int userID, int courseID) async {
  try {
    var url =
        "https://darkgray-hummingbird-925566.hostingersite.com/watad/userCourses/insertUserCourse.php?"
        "courseID=$courseID"
        "&userID=$userID";

    print("InsertUserCourse - Final URL: $url");

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
    print("Error in InsertUserCourse: $e");
    return false;
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
  State<CoursesScreenDesign> createState() => CoursesScreenDesignState();
}

class CoursesScreenDesignState extends State<CoursesScreenDesign> {
  bool showNotes = false;
  late String notes;
  int? studentCount;
  bool isLoading = false;
  List<User> _courseStudents = [];
  bool _isLoadingStudents = false;

  TextEditingController _notesController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _tutorController = TextEditingController();
  TextEditingController _courseController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _dayController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  Future<void> _loadCourseNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedNotes =
        prefs.getString('course_${widget.courses.courseID}_notes');

    setState(() {
      _notesController.text = savedNotes ?? widget.courses.notes;
    });
  }

  @override
  void initState() {
    super.initState();
    if (!widget.isStudent) {
      loadStudentCount();
    }
    _loadCourseNotes();
  }

  @override
  void dispose() {
    _notesController.dispose();
    _tutorController.dispose();
    _courseController.dispose();
    _locationController.dispose();
    _dayController.dispose();
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> loadStudentCount() async {
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

  Future<void> showCourseStudents() async {
    setState(() {
      _isLoadingStudents = true;
    });

    try {
      final students = await getCourseStudents(widget.courses.courseID);

      if (mounted) {
        setState(() {
          _courseStudents = students;
          _isLoadingStudents = false;
        });

        if (mounted) {
          showStudentsBottomSheet();
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

  void showStudentsBottomSheet() {
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
                        'Course Students',
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
                    "${_courseStudents.length} Students Enrolled",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Student list
                  Expanded(
                    child: _courseStudents.isEmpty
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
                            itemCount: _courseStudents.length,
                            separatorBuilder: (context, index) =>
                                Divider(height: 1, color: Colors.grey.shade200),
                            itemBuilder: (context, index) {
                              final student = _courseStudents[index];
                              final fullName =
                                  "${student.firstName ?? ''} ${student.secondName ?? ''}"
                                      .trim();
                              print(student.userID);

                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      getCourseColor(widget.courses.courseID),
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
                                  fullName,
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
                                      builder: (dialogContext) =>
                                          UserCourseDeleteAlert(
                                        userID: student.userID,
                                        courseID: widget.courses.courseID,
                                        onTaskDeleted: () {
                                          Navigator.pop(context);
                                          showCourseStudents();
                                          loadStudentCount();
                                        },
                                      ),
                                    ).then((result) {
                                      if (result != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              result == true
                                                  ? 'Student removed successfully!'
                                                  : 'Failed to remove student.',
                                            ),
                                            backgroundColor: result == true
                                                ? Colors.green
                                                : Colors.red,
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
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
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
                  showAddStudentForm(context);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> EditCourse(int courseID, String tutor, String course,
      String location, String day, String time, String description) async {
    try {
      var url = "${serverPath}courses/updateCourse.php?"
          "courseID=$courseID"
          "&tutor=${Uri.encodeComponent(tutor)}"
          "&course=${Uri.encodeComponent(course)}"
          "&location=${Uri.encodeComponent(location)}"
          "&day=${Uri.encodeComponent(day)}"
          "&time=${Uri.encodeComponent(time)}"
          "&description=${Uri.encodeComponent(description)}";

      print("EditCourse - Final URL: $url");

      final response = await http.get(Uri.parse(url));
      print("EditCourse Status Code: ${response.statusCode}");
      print("EditCourse Raw Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print("Parsed response data: $data");

        // Check if the result is a success indicator
        if (data['result'] == '1' || data['result'] == 1) {
          print("Successfully updated course with ID: $courseID");
          return true;
        } else {
          print("API returned unsuccessful result: ${data['result']}");
          return false;
        }
      }
      return false;
    } catch (e) {
      print("EditCourse Error: $e");
      return false;
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
      child: widget.isGridView ? buildGridLayout() : buildListLayout(),
    );
  }

  Widget buildGridLayout() {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        buildCardContent(),
      ],
    );
  }

  Widget buildListLayout() {
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
          Expanded(child: buildCardContent()),
        ],
      ),
    );
  }

  Widget buildCardContent() {
    final courseColor = getCourseColor(widget.courses.courseID);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.courses.course,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
              ),
              if (!widget.isStudent) ...{
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => CourseDeleteAlert(
                        courseID: widget.courses.courseID,
                        onTaskDeleted: () {
                          widget.onTaskDeleted();
                        },
                      ),
                    ).then((result) {
                      if (result == true) {
                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Course deleted successfully!'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else if (result == false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to delete course.'),
                            backgroundColor: Colors.red,
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
              },
            ],
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
          buildInfoRow(Icons.person_outline, widget.courses.tutor),
          const SizedBox(height: 6),
          buildInfoRow(Icons.location_on_outlined, widget.courses.location),
          const SizedBox(height: 6),
          buildInfoRow(Icons.calendar_today_outlined,
              "${widget.courses.day}, ${widget.courses.time}"),
          if (!widget.isStudent)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: buildStudentCountRow(),
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
                  child: Text(showNotes ? "Hide Notes" : "Show Notes"),
                ),
              ),
              const SizedBox(width: 8),
              if (!widget.isStudent)
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoadingStudents
                        ? null
                        : () {
                            showCourseStudents();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.lerp(Colors.grey.shade100,
                          getCourseColor(widget.courses.courseID), 0.5),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      disabledBackgroundColor: Colors.grey.shade200,
                      disabledForegroundColor: Colors.grey.shade400,
                    ),
                    child: _isLoadingStudents
                        ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.grey.shade400,
                            ),
                          )
                        : const Text("Participants"),
                  ),
                ),
              if (!widget.isStudent) const SizedBox(width: 8),
              if (!widget.isStudent)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showEditCourseForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: getCourseColor(widget.courses.courseID),
                      foregroundColor: Colors.black87,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Edit"),
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
                      hintText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 3,
                    minLines: 3,
                    controller: _notesController,
                    readOnly: widget.isStudent,
                  ),
                  const SizedBox(height: 8),
                  if (!widget.isStudent)
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userNote = _notesController.text.trim();

                        await prefs.setString(
                            'course_${widget.courses.courseID}_notes',
                            userNote);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Notes saved successfully!')),
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

  Widget buildInfoRow(IconData icon, String text) {
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

  Widget buildStudentCountRow() {
    if (isLoading) {
      loadStudentCount();

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
          if (studentCount != 0) ...{
            Text(
              "${studentCount} Students",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
          } else ...{
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

  void showEditCourseForm() {
    _tutorController.text = widget.courses.tutor;
    _courseController.text = widget.courses.course;
    _locationController.text = widget.courses.location;
    _dayController.text = widget.courses.day;
    _timeController.text = widget.courses.time;
    _descriptionController.text = widget.courses.description;

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
                          'Edit Course',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                        IconButton(
                          icon:
                              const Icon(Icons.close, color: Color(0xFF6B7280)),
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
                              hint: 'Enter tutor name',
                              icon: Icons.person_outline,
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
                              label: 'Location',
                              controller: _locationController,
                              hint: 'Enter location',
                              icon: Icons.location_on_outlined,
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
                              label: 'Time',
                              controller: _timeController,
                              hint: 'Enter time',
                              icon: Icons.access_time_outlined,
                              isRequired: true,
                            ),
                            buildFormField(
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Updating course...'),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color(0xFF1F2937),
                              ),
                            );

                            try {
                              bool success = await EditCourse(
                                widget.courses.courseID,
                                _tutorController.text,
                                _courseController.text,
                                _locationController.text,
                                _dayController.text,
                                _timeController.text,
                                _descriptionController.text,
                              );

                              print("Course updated: $success");

                              if (success) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                Navigator.pop(context);

                                widget.onTaskDeleted();

                                Future.delayed(
                                    const Duration(milliseconds: 300), () {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Course successfully updated!'),
                                        backgroundColor: Color(0xFF1F2937),
                                      ),
                                    );
                                  }
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Failed to update course. Please try again.'),
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

  void showAddStudentForm(BuildContext context) {
    final scaffoldContext = ScaffoldMessenger.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        _emailController.clear();
        _phoneNumberController.clear();
        bool isLoading = false;

        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Add New Student'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  buildFormField(
                    label: 'Student e-Mail',
                    controller: _emailController,
                    hint: 'Enter Student e-Mail',
                    icon: Icons.person_outline,
                    isRequired: true,
                  ),
                  buildFormField(
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
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.of(dialogContext).pop();
                      },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() {
                          isLoading = true;
                        });

                        int uID = await getUserID(
                            _emailController.text, _phoneNumberController.text);

                        if (uID == 0) {
                          Navigator.of(dialogContext).pop();
                          Navigator.pop(context);

                          scaffoldContext.showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'No student found with the matching credentials'),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        } else {
                          bool success = await InsertUserCourse(
                              uID, widget.courses.courseID);

                          Navigator.of(dialogContext).pop();
                          Navigator.pop(context);

                          if (success) {
                            scaffoldContext.showSnackBar(
                              const SnackBar(
                                content: Text('Added Student successfully'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );

                            if (mounted) {
                              showCourseStudents();
                              loadStudentCount();
                            }
                            ;
                          } else {
                            scaffoldContext.showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Failed to add student to course'),
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
        });
      },
    );
  }
}
