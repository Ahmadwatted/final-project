import 'dart:convert';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Models/clientConfig.dart';
import '../utils/Widgets/Custom_Text_Field.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _txtfirstName = TextEditingController();
  final TextEditingController _txtsecondName = TextEditingController();
  final TextEditingController _txtpassword = TextEditingController();
  final TextEditingController _txtphoneNumber = TextEditingController();
  final TextEditingController _txtemail = TextEditingController();
  bool isLoading = false;

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Registration Failed'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 400),
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
                        'Create Account',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 32),

                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _txtfirstName,
                              label: 'First Name',
                              hint: 'Enter first name',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: CustomTextField(
                              controller: _txtsecondName,
                              label: 'Second Name',
                              hint: 'Enter Second name',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _txtemail,
                        label: 'Email',
                        hint: 'Enter your email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _txtphoneNumber,
                        label: 'Phone Number',
                        hint: 'Enter phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 24),

                      CustomTextField(
                        controller: _txtpassword,
                        label: 'Password',
                        hint: 'Create a password',
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
                          onPressed: isLoading
                              ? null
                              : () async {
                                  // Validate inputs first
                                  if (_txtfirstName.text.isEmpty ||
                                      _txtsecondName.text.isEmpty ||
                                      _txtemail.text.isEmpty ||
                                      _txtpassword.text.isEmpty ||
                                      _txtphoneNumber.text.isEmpty) {
                                    showErrorDialog(
                                        'Please fill in all required fields.');
                                    return;
                                  }

                                  setState(() {
                                    isLoading = true;
                                  });

                                  try {
                                    final result = await insertUser(
                                        context,
                                        2,
                                        _txtfirstName.text,
                                        _txtsecondName.text,
                                        _txtemail.text,
                                        _txtpassword.text,
                                        _txtphoneNumber.text);

                                    setState(() {
                                      isLoading = false;
                                    });

                                    if (result['success']) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Account created successfully!'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );

                                      await Future.delayed(
                                          Duration(milliseconds: 500));

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MainStudentScreen(
                                            title: 'Student Dashboard',
                                            userID: result['userID'],
                                          ),
                                        ),
                                      );
                                    } else {
                                      showErrorDialog(result['message']);
                                    }
                                  } catch (e) {
                                    print(
                                        "Exception in registration button: $e");
                                    setState(() {
                                      isLoading = false;
                                    });
                                    showErrorDialog(
                                        'An unexpected error occurred: ${e.toString()}');
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Create Account',
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
                            'Already have an account? ',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Teacher Contact Section
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.school,
                              color: Colors.blue,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Are you a teacher?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue.shade800,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Contact us via this email: ahmad2015watted@gmail.com',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
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

  Future<Map<String, dynamic>> insertUser(
      BuildContext context,
      int userTypeID,
      String firstName,
      String secondName,
      String email,
      String password,
      String phoneNumber) async {
    var url = "users/insertUser.php?"
        "firstName=$firstName"
        "&secondName=$secondName"
        "&email=$email"
        "&password=$password"
        "&phoneNumber=$phoneNumber"
        "&userTypeID=$userTypeID";

    final response = await http.get(Uri.parse(serverPath + url));
    final data = json.decode(response.body);

    if (data['message'] == 'Email already registered') {
      return {
        'success': false,
        'message':
            'An account with this email already exists. Please use a different email.'
      };
    }

    if (data['result'] == '1' && data['userID'] != null) {
      return {'success': true, 'userID': data['userID'].toString()};
    } else {
      return {
        'success': false,
        'message':
            data['message'] ?? 'Failed to create account. Please try again.'
      };
    }
  }
}
