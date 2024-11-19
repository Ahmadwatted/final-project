import 'dart:convert';

import 'package:final_project/Models/User.dart';

class UserType {

  UserType({
    this.UserTypeID="",
    this.UserTypeName="",


  });
  String UserTypeID;
  String UserTypeName;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
        UserTypeID: json["UserTypeID"],
        UserTypeName: json["UserTypeName"],


      );
  Map<String, dynamic> toJson() => {
        "UserTypeID": UserTypeID,
        "UserTypeName": UserTypeName,

      };
}
