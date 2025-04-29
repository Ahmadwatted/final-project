import 'dart:convert';
import 'dart:io';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/checkLoginModel.dart';
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
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _txtemail = TextEditingController();
  final TextEditingController _txtpassword = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fillSavedPars();
  }

  Future<void> fillSavedPars() async {
    setState(() {
      _isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    _txtemail.text = prefs.getString("Email") ?? "";
    _txtpassword.text = prefs.getString("password") ?? "";

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> processLogin(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    bool isLoginSuccessful = await checkLogin(context, _txtemail.text, _txtpassword.text);

    if (isLoginSuccessful) {
      try {
        var url = "checkLogins/checkLogin.php?email=${_txtemail.text}&password=${_txtpassword.text}";
        final response = await http.get(Uri.parse(serverPath + url));

        if (response.statusCode == 200) {
          final decodedData = jsonDecode(response.body);

          if (decodedData is Map<String, dynamic>) {
            String userTypeID = decodedData['usertypeID'].toString();
            String userID = decodedData['userID'].toString();

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString("Email", _txtemail.text);
            await prefs.setString("password", _txtpassword.text);

            if (userTypeID == "1") {
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
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const LoginPage()
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

    setState(() {
      _isLoading = false;
    });
  }

  checkConnection(BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected to internet');
      }
    } on SocketException catch (_) {
      print('not connected to internet');
      var uti = new Utils();
      uti.showMyDialog2(context, "אין אינטרנט", "האפליקציה דורשת חיבור לאינטרנט, נא להתחבר בבקשה");
    }
  }

  @override
  Widget build(BuildContext context) {
    checkConnection(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: _isLoading
              ? const CircularProgressIndicator()
              : SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
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

                      CustomTextField(
                        controller: _txtemail,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _txtpassword,
                        label: 'Password',
                        hint: 'Enter your password',
                        isPassword: true,
                      ),
                      const SizedBox(height: 32),

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
                            await processLogin(context);
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
                                  builder: (context) => RegisterPage(),
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