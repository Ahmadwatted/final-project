import 'package:final_project/Models/user.dart';
import 'package:final_project/utils/DB.dart';
import 'package:flutter/material.dart';
import 'package:final_project/Views/MainAppPage.dart';

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
        '/MainAppPage': (context) => MainAppPage(
              title: 'MainAppPage',
            ),
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
  bool _isVisible = false;
  bool _noAccount = false;

  final TextEditingController _txtemail = TextEditingController();
  final TextEditingController _txtfirstName = TextEditingController();
  final TextEditingController _txtsecondName = TextEditingController();
  final TextEditingController _txtpassword = TextEditingController();
  final TextEditingController _txtphoneNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.deepOrange[100],
        child: Column(
          children: [
            // Container(
            //   width: screenWidth,
            //   height: screenHeight * 0.1,
            //   child: Align(
            //     alignment: Alignment.center,
            //     // child: Image.asset('images and icons/log in icon.png'),
            //   ),
            // ),
            Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: Colors.brown[900]),
              child: Center(
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
                            Text("E-mail:",
                                style: TextStyle(
                                    color: Colors.deepOrange[100],
                                    fontSize: 20)),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 500,
                              child: TextField(
                                controller: _txtemail,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // Border radius
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 120,
                                        )),
                                    hintText: "Enter your E-mail",
                                    hintStyle: TextStyle(
                                        color: Colors.deepOrange[100],
                                        fontSize: 20)),
                              ),
                            ),
                            SizedBox(
                              height: 45,
                            ),
                            Visibility(
                              visible: _isVisible,
                              child: Column(
                                children: [
                                  Text("First Name:",
                                      style: TextStyle(
                                          color: Colors.deepOrange[100],
                                          fontSize: 20)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 500,
                                    child: TextField(
                                      controller: _txtfirstName,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Border radius
                                              borderSide: BorderSide(
                                                color: Colors.blue,
                                                width: 120,
                                              )),
                                          hintText: "Enter your First Name",
                                          hintStyle: TextStyle(
                                              color: Colors.deepOrange[100],
                                              fontSize: 20)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  Text("Second Name:",
                                      style: TextStyle(
                                          color: Colors.deepOrange[100],
                                          fontSize: 20)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: 500,
                                    child: TextField(
                                      controller: _txtsecondName,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Border radius
                                              borderSide: BorderSide(
                                                color: Colors.deepOrange,
                                                width: 120,
                                              )),
                                          hintText: "Enter your Second Name",
                                          hintStyle: TextStyle(
                                              color: Colors.deepOrange[100],
                                              fontSize: 20)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 45,
                                  ),
                                  Text("Phone Number:",
                                      style: TextStyle(
                                          color: Colors.deepOrange[100],
                                          fontSize: 20)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 500,
                                    child: TextField(
                                      controller: _txtphoneNumber,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Border radius
                                              borderSide: BorderSide(
                                                color: Colors.deepOrange,
                                                width: 120,
                                              )),
                                          hintText: "Enter your Phone Number",
                                          hintStyle: TextStyle(
                                              color: Colors.deepOrange[100],
                                              fontSize: 20)),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 45,
                            ),
                            Text("Password:",
                                style: TextStyle(
                                    color: Colors.deepOrange[100],
                                    fontSize: 20)),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: 500,
                              child: TextField(
                                controller: _txtpassword,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            20), // Border radius
                                        borderSide: BorderSide(
                                          color: Colors.blue,
                                          width: 120,
                                        )),
                                    hintText: "Enter your Password",
                                    hintStyle: TextStyle(
                                        color: Colors.deepOrange[100],
                                        fontSize: 20)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Visibility(
                          visible: !_isVisible,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainAppPage(
                                        title: 'tomainapppage')),
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
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Visibility(
                          visible: !_noAccount,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                                _noAccount = !_noAccount;
                              });
                              // Code to execute when the button is pressed
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text("Register",
                                  style: TextStyle(
                                    color: Colors.deepOrange[200],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Visibility(
                          visible: _noAccount,
                          child: ElevatedButton(
                            onPressed: () {
                              user us = new user();
                              us.firstName = _txtfirstName.text;
                              us.secondName = _txtsecondName.text;
                              us.phoneNumber = _txtphoneNumber.text;
                              us.email = _txtemail.text;
                              us.password = _txtpassword.text;
                              us.userTypeID=2;

                              insertUser(us);
/*
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainAppPage(
                                        title: 'tomainapppage')),
                              );
                         */
                            },
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Text('Create an account',
                                  style: TextStyle(
                                    color: Colors.deepOrange[200],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
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
