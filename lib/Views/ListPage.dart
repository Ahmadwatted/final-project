import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Views/EditProfile.dart';
import 'package:final_project/Views/MainAppPage.dart';



class ListPage extends StatefulWidget {
  const ListPage({super.key, required this.title});

  final String title;

  @override
  State<ListPage> createState() => _MainAppPage();
}

class _MainAppPage extends State<ListPage> {
  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE3DFD6),
      body: Container(


        child: Column(
          children: [
            SizedBox(height:20),
            Row(

              children: [









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
              ElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MainAppPage(
                          title: 'tomainpage')),
                );
              }, child: Icon(Icons.home)),
              ElevatedButton(onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ListPage(
                          title: 'toprofilepage')),
                );
              }, child: Icon(CupertinoIcons.list_bullet_indent)),
              ElevatedButton(onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfile(
                          title: 'toprofilepage')),
                );
              },
                  child: Icon(CupertinoIcons.profile_circled))



            ],


          ) ,
        ),
      ),

    );
  }
}
