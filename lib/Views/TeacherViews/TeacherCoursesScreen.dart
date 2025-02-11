import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/StudentMain_VM.dart';
import '../../utils/Widgets/Courses_Screen_Design.dart';

class TeacherCoursesScreen extends StatelessWidget {
  final String title;


  const TeacherCoursesScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _TeacherCoursesScreen(title: title),
    );
  }
}
class _TeacherCoursesScreen extends StatelessWidget {

  final String title;

  const _TeacherCoursesScreen({required this.title});


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3DFD6),

      appBar: AppBar(
        title: const Text('My Courses'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.courses.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CoursesScreenDesign(courses: viewModel.courses[index], isStudent: false,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


