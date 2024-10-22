import 'package:final_project/Views/MainAppPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:final_project/Views/ListPage.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key, required this.title});

  final String title;

  @override
  State<EditProfile> createState() => _EditProfile();
}

class _EditProfile extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0xFFE3DFD6),
      body: Container(

        child: Column(
          children: [
            Container(
              child: Column(
                children: [

                ],
              ),
            ),

            Container(

              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(CupertinoIcons.profile_circled,size: 200,),
                  Column(
                    children: [
                      Container(



                      ),


                    ],
                  )












                     ],
              )



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
