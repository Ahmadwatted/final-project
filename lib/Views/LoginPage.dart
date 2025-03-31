import 'dart:convert';
import 'dart:io';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../Models/checkLoginModel.dart';
import '../Models/user.dart';
import '../Models/clientConfig.dart';
import '../utils/Utils.dart';
import '../utils/Widgets/Custom_Text_Field.dart';
import 'RegisterPage.dart';
import 'TeacherViews/MainTeacherScreen.dart';
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
      home:  LoginPage(),
      // routes: {
      //   '/MainAppPage': (context) => LoginPage(),
      // },
    );
  }
}


class LoginPage extends StatelessWidget {


  LoginPage({Key? key}) : super(key: key);
  final TextEditingController _txtemail = TextEditingController();
  final TextEditingController _txtpassword = TextEditingController();



  checkConction(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected to internet');// print(result);// return 1;
      }
    } on SocketException catch (_) {
      print('not connected to internet');// print(result);
      var uti = new Utils();
      uti.showMyDialog2(context, "אין אינטרנט", "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה");
      // return;
    }
  }

  @override
  Widget build(BuildContext context) {

    checkConction(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  children: [
                    Icon(Icons.arrow_back, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      'Home Page',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Main Content
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Email Field
                    CustomTextField(
                      controller: _txtemail,
                      label: 'Email',
                      hint: 'Enter your email',
                      keyboardType: TextInputType.emailAddress,

                    ),
                    const SizedBox(height: 24),

                    // Password Field
                    CustomTextField(
                      controller: _txtpassword,
                      label: 'Password',
                      hint: 'Enter your password',
                      isPassword: true,
                    ),
                    const SizedBox(height: 32),

                    // Sign In Button
                    Container(
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.blue, Colors.blueAccent],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          // Call the checkLogin function
                          bool isLoginSuccessful = await checkLogin(context, _txtemail.text, _txtpassword.text);

                          if (isLoginSuccessful) {
                            // Get the userTypeID from the login response
                            try {
                              var url = "checkLogins/checkLogin.php?email=${_txtemail.text}&password=${_txtpassword.text}";
                              final response = await http.get(Uri.parse(serverPath + url));

                              if (response.statusCode == 200) {
                                final decodedData = jsonDecode(response.body);

                                if (decodedData is Map<String, dynamic>) {
                                  String userTypeID = decodedData['usertypeID'].toString();
                                  String userID = decodedData['userID'].toString();

                                  if (userTypeID == "1") {
                                    // Navigate to Teacher Main Screen with userID
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainTeacherScreen(
                                          title: 'pepo',
                                          userID: userID,
                                        ),
                                      ),
                                    );
                                  } else if (userTypeID == "2") {
                                    // Navigate to Student Main Screen with userID
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => MainStudentScreen(
                                          title: 'pepo',
                                          userID: userID,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                            } catch (e) {
                              print("Error routing user: $e");
                              // Fallback to original behavior
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage()
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid email or password. Please try again.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> checkLogin(BuildContext context, String email, String password) async {
  var url = "checkLogins/checkLogin.php?email=$email&password=$password";
  final response = await http.get(Uri.parse(serverPath + url));

  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final decodedData = jsonDecode(response.body);

    if (decodedData is bool) {
      print("Error: Server returned a boolean instead of JSON.");
      return decodedData;
    }

    if (decodedData is Map<String, dynamic>) {
      var user = checkLoginModel.fromJson(decodedData);
      if (user.userID == 0) {
        return false;
      } else {
        return true;
      }
    } else {
      print("Unexpected response format.");
      return false;
    }
  }

  return false;
}