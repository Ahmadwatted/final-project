import 'dart:convert';
import '../Models/user.dart';
import 'package:final_project/Views/TeacherViews/MainTeacherScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Views/EditProfile.dart';
import 'package:final_project/Views/ListPage.dart';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';
import 'package:http/http.dart' as http;

import '../Models/clientConfig.dart';
import '../Models/user.dart';

class MainAppPage extends StatefulWidget {

  const MainAppPage({super.key, required this.title});

  final String title;


  @override
  State<MainAppPage> createState() => _MainAppPage();
}
class _MainAppPage extends State<MainAppPage> {

  @override
  Widget build(BuildContext context) {
    var dd = '';


    // Future<String> getUsers() async {
    //
    //   var url = "users/getUsers.php";
    //   final response = await http.get(Uri.parse(serverPath + url));
    //
    //   // Decode the response and create a list of User objects
    //   List<User> arr = [];
    //   for (Map<String, dynamic> i in json.decode(response.body)) {
    //     arr.add(User.fromJson(i));
    //   }
    //
    //   // Convert the list of User objects to a string with the specified format
    //   String usersString = arr.map((user) =>
    //   '${user.firstName}, ${user.secondName}, ${user.email}, ${user.phoneNumber}'
    //   ).join(', ');
    //
    //   setState(() {
    //     dd = usersString;
    //   });
    //   return usersString; // Return the formatted string
    // }



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
            Text(dd),
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
