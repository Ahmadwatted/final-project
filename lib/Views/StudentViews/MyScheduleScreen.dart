import 'package:final_project/utils/Widgets/Schedule_Screen_Design.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../ViewModels/StudentMain_VM.dart';

class MyScheduleScreen extends StatelessWidget {
  final String title;


  const MyScheduleScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StudentDashboardViewModel(),
      child: _MyScheduleScreen(title: title),
    );
  }
}
class _MyScheduleScreen extends StatelessWidget {

  final String title;

  const _MyScheduleScreen({required this.title});


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<StudentDashboardViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE3DFD6),

      appBar: AppBar(
        title: const Text('My Schedule'),
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
                itemCount: viewModel.schedule.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ScheduleScreenDesign(schedule: viewModel.schedule[index],),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


