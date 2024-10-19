import 'package:flutter/material.dart';



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

      body:
        Container(
          color: Colors.deepOrange[100],
          width: screenWidth,
          height: screenHeight *0.1,
          child: Column(
            children: [
              Container(
                child:





                ),

          )


            ],
          ),
        )
    );
  }
}
