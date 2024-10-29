import 'package:final_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class Utils{

  static void alert(String _txtEmail,String _txtPassword, BuildContext context, String _txtFirstName,String _txtSecondName) {

        showDialog<String>(
          context: context,
          builder: (BuildContext context) =>
              AlertDialog(
                title:  Text('$_txtFirstName,$_txtSecondName are u sure about this info?'),
                content:  Text('your Email:$_txtEmail,\n your PassWord:$_txtPassword ',),


                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: 'asdasd',))),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Yes'),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );

  }






  }











