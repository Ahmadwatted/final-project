import 'package:flutter/material.dart';
import 'Views/RegisterPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Ahmad'),
      routes: {
        '/Register' : (context) => SecondScreen(message: 'ahmad'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(

      body: Container(
        child: Column(
          children: [
            Container(
              width: screenWidth,
              height: screenHeight *0.3,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset('images and icons/log in icon.png'),
              ),
            ),
            Container(
              height: screenHeight * 0.7,
              width: screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
                  color: Colors.brown[400]
              ),
              child:  Center(

                child: Column(


                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[


                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          children: [
                            Text("Email:",
                                style: TextStyle(
                                    color:Colors.brown[100], fontSize: 20)
                            ),
                            Container(

                              width: 500,
                              child:TextField(

                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20), // Border radius
                                        borderSide: BorderSide(
                                          color: Colors.blue,width:120,


                                        )
                                    ),
                                    hintText: "enter your Email",
                                    hintStyle: TextStyle(
                                        color: Color(0xFFD2B48C),fontSize: 20

                                    )


                                ),

                              ) ,
                            ),


                            Text("Password:",

                                style: TextStyle(
                                    color:Colors.brown[100], fontSize: 20)
                            ),
                            Container(
                              width: 500,
                              child: TextField(

                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20), // Border radius
                                        borderSide: BorderSide(
                                          color: Colors.blue,width:120,


                                        )
                                    ),
                                    hintText: "Enter your Password",
                                    hintStyle: TextStyle(
                                        color: Color(0xFFD2B48C),fontSize: 20

                                    )



                                ),

                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [


                        ElevatedButton(

                          onPressed: () {
                            // Code to execute when the button is pressed
                            print('Sign in');

                          },
                          child: Text('Sign in'),
                        ),
                        SizedBox(width: 10,),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/Register',
                            );
                            // Code to execute when the button is pressed
                            print('Sign in');
                          },
                          child: Text("Register"),
                        ),
                      ],
                    ),


                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
