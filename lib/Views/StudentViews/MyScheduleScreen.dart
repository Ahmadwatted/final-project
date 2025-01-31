import 'package:flutter/material.dart';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';

class MyTimeTableScreen extends StatelessWidget {
  final String title;

  const MyTimeTableScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFE3DFD6),
      appBar: AppBar(
        title: Text('My Schedule'),
      ),

    );
  }
}
