import 'package:flutter/material.dart';

class SecondScreen extends StatelessWidget {
  final String message;

  // Constructor to receive message
  SecondScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    final TextStyle styler = TextStyle(
        color:Colors.brown[100], fontSize: 20
    );
    final TextField textfieldstyler=TextField(decoration: InputDecoration(
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Border radius
          borderSide: BorderSide(
            color: Colors.blue,width:120,


          )
      ),));
    return Scaffold(

      body: Center(
        child: Column(

          children: <Widget>[

            Container(
              height: 20,
            ),

         Text("Register page",style: styler,),














             // Display the passed message
            Container(
              child:ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: Text('Go Back'),
              ),
            )

          ],
        ),
      ),
    );
  }
}
