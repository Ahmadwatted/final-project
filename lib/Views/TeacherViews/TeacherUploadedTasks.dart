import 'package:final_project/utils/Widgets/Schedule_Screen_Design.dart';
import 'package:final_project/utils/Widgets/Tasks_Screen_design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/StudentMain_VM.dart';

class TeacherUploadedTasks extends StatelessWidget {
  final String title;


  const TeacherUploadedTasks({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _TeacherUploadedTasks(title: title),
    );
  }
}
class _TeacherUploadedTasks extends StatelessWidget {

  final String title;

  const _TeacherUploadedTasks({required this.title});


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3DFD6),

      appBar: AppBar(
        title: const Text('Uploaded tasks'),
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
                itemCount: viewModel.tasks.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TasksScreenDesign(tasks: viewModel.tasks[index],isStudent: false,),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


