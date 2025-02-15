import 'package:final_project/Views/TeacherViews/MainTeacherScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Views/EditProfile.dart';
import 'package:final_project/Views/ListPage.dart';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';

class MainAppPage extends StatefulWidget {
  const MainAppPage({super.key, required this.title});

  final String title;

  @override
  State<MainAppPage> createState() => _MainAppPage();
}

class _MainAppPage extends State<MainAppPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE3DFD6),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MainStudentScreen(title: 'tomainapppage')),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sign-in',
                        style: TextStyle(
                          color: Colors.deepOrange[200],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const Mainteacherscreen(title: 'tomainapppage')),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('Sign-in2',
                        style: TextStyle(
                          color: Colors.deepOrange[200],
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        width: screenWidth,
        height: 50,
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const MainAppPage(title: 'tomainpage')),
                    );
                  },
                  child: Icon(Icons.home)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const ListPage(title: 'toprofilepage')),
                    );
                  },
                  child: Icon(CupertinoIcons.list_bullet_indent)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const EditProfile(title: 'toprofilepage')),
                    );
                  },
                  child: Icon(CupertinoIcons.profile_circled))
            ],
          ),
        ),
      ),
    );
  }
}
