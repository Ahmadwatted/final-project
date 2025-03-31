import 'package:final_project/Models/user.dart';
import 'package:final_project/Views/LoginPage.dart';
import 'package:final_project/Views/StudentViews/MainStudentScreen.dart';
import 'package:final_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Utils{

  // static void alert(String _txtEmail,String _txtPassword, BuildContext context, String _txtFirstName,String _txtSecondName) {
  //
  //       showDialog<String>(
  //         context: context,
  //         builder: (BuildContext context) =>
  //             AlertDialog(
  //               title:  Text('$_txtFirstName,$_txtSecondName are u sure about this info?'),
  //               content:  Text('your Email:$_txtEmail,\n your Password:$_txtPassword ',),
  //
  //
  //               actions: <Widget>[
  //                 TextButton(
  //                   onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: 'asdasd',))),
  //                   child: const Text('Cancel'),
  //                 ),
  //                 TextButton(
  //                   onPressed: () => Navigator.pop(context, 'Yes'),
  //                   child: const Text('OK'),
  //                 ),
  //               ],
  //             ),
  //       );
  //
  // }


  Future<void> showMyDialog(User us, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('$us._txtfirstName,$us._txtsecondName are u sure about the info you have  entered'),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email:$us._txtEmail,\n your Password:$us._txtPassword'),
                Text('Would you like to approve these info?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MainStudentScreen(title: 'asdasd', userID: '2',))),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                insertUser(us);
                Navigator.pop(context, 'Yes');


              },
              child: const Text('OK'),
            ),
          ],


        );
      },
    );
  }

  void insertUser(User us) {}



  Future<void> showMyDialog2(BuildContext context, String title, String content ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text(title),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage())),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Yes');

              },
              child: const Text('OK'),
            ),
          ],


        );
      },
    );
  }




}











