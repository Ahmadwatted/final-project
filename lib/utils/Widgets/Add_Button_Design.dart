import 'package:flutter/material.dart';

class AddButtonDesign extends StatelessWidget {
  final Function(String) onJoinCourse;

  const AddButtonDesign({
    super.key,
    required this.onJoinCourse,
  });

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title
          const Text(
            'Join a Course',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          // Input field
          TextField(
            controller: codeController,
            decoration: const InputDecoration(
              labelText: 'Enter Course Code',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (codeController.text.isNotEmpty) {
                  onJoinCourse(codeController.text);
                  Navigator.pop(context);
                }
              },
              child: const Padding(
                padding: EdgeInsets.all(12),
                child: Text('Join'),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}