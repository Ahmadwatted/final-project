import 'package:final_project/Views/StudentViews/MyTasksScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/StudentMain_VM.dart';
import '../../utils/Widgets/Course_Card.dart';
import '../../utils/Widgets/Schedule_Card.dart';
import '../../utils/Widgets/Task_Card.dart';
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
              TextButton(
                onPressed: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const Mycoursesscreen(title: 'tomainapppage'),
                      ),
                    ),
                child: const Text(
                  'My Courses',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.courses.length,
                  itemBuilder: (context, index) =>
                      CourseCard(
                        course: viewModel.courses[index],
                      ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const MyScheduleScreen(title: 'tomainapppage'),
                      ),
                    ),
                child: const Text(
                  'My schedule',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: viewModel.schedule
                        .map((schedule) => ScheduleCard(schedule: schedule))
                        .toList(),
                  ),
                ),
              ),
              TextButton(
                onPressed: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                        const Mytasksscreen(title: 'tomainapppage'),
                      ),
                    ),
                child: const Text(
                  'My tasks',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                child: Padding(

                  padding:EdgeInsets.symmetric(horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: viewModel.task.map((task)=> TaskCard(task: task)).toList(),


                    ),
                  ),






                ),








              )




            ],
          ),
        ),





      ),
    );
  }
}