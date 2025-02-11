import 'package:final_project/Models/student.dart';
import 'package:final_project/Views/StudentViews/MyTasksScreen.dart';
import 'package:final_project/utils/Widgets/Add_Button_Design.dart';
import 'package:final_project/utils/Widgets/Task_Card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/StudentMain_VM.dart';
import '../../utils/Widgets/Course_Card.dart';
import '../../utils/Widgets/Schedule_Card.dart';
import '../../Models/course.dart';


import 'MyCoursesScreen.dart';
import 'MyScheduleScreen.dart';
class MainStudentScreen extends StatelessWidget {
  final String title;


  const MainStudentScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _MainStudentScreenContent(title: title),
    );
  }
}


class _MainStudentScreenContent extends StatelessWidget {
  final String title;
  void _handleJoinCourse(String code) {
    // backend
    print('Joining course with code: $code');
  }

  void _showJoinSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => AddButtonDesign(
        onJoinCourse: _handleJoinCourse,
      ),
    );
  }

  const _MainStudentScreenContent({required this.title});


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3DFD6),
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Courses',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const MyCoursesScreen(title: 'tomainapppage'),
                            ),
                          ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


              ),
              SizedBox(
                height: 160,
                child: viewModel.courses.isEmpty
                    ? Center(
                  child: Text(
                    'You have not participated in any courses yet',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.courses.length,
                  itemBuilder: (context, index) {
                    final Course course = viewModel.courses[index] as Course;
                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: CourseCard(courses: course,),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Schedule',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const MyScheduleScreen(title: 'tomainapppage'),
                            ),
                          ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ),
              SizedBox(
                height: 160,
                child: viewModel.schedule.isEmpty
                    ? Center(
                  child: Text(
                    'No scheduled classes',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.schedule.length,
                  itemBuilder: (context, index) {
                    final schedule = viewModel.schedule[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: ScheduleCard(schedule: schedule),
                    );
                  },
                ),
              ),
              Text(viewModel.students.length.toString()),



              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My Tasks',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const MyTasksScreen(title: 'tomainapppage'),
                            ),
                          ),
                      child: Row(
                        children: [
                          Text(
                            'View All',
                            style: TextStyle(
                              color: Colors.blue[600],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            size: 16,
                            color: Colors.blue[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),


              ),
              SizedBox(
                height: 160,
                child: viewModel.tasks.isEmpty
                    ? Center(
                  child: Text(
                    'No tasks yet',
                    style: TextStyle(
                      color: Colors.grey[500],
                    ),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: viewModel.tasks.length,
                  itemBuilder: (context, index) {
                    final task = viewModel.tasks[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 16.0),
                      child: TaskCard(tasks: task),
                    );
                  },
                ),
              ),




              SizedBox(height: 75,)





            ],
          ),
        ),

      ),

      floatingActionButton: FloatingActionButton(onPressed: () => _showJoinSheet(context),
      child: const Icon(Icons.add_circle_outline,color: Colors.black, ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        splashColor: Colors.transparent ,
        highlightElevation: 0,

        
          

      ), 



    );
  }
}

