import 'package:final_project/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DB.dart';
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


  Future<void> showMyDialog(String _txtEmail,String _txtPassword, BuildContext context, String _txtFirstName,String _txtSecondName) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title:  Text('$_txtFirstName,$_txtSecondName are u sure about the info you have  entered'),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Email:$_txtEmail,\n your Password:$_txtPassword'),
                Text('Would you like to approve these info?'),
              ],
            ),
          ),
          actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.push(context,MaterialPageRoute(builder: (context) => MyHomePage(title: 'asdasd',))),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              insertUser("asd",'sad','asd');
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











