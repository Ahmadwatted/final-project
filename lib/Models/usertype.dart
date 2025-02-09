import 'dart:convert';


class UserType {

  UserType({
    this.userTypeID=0,
    this.userTypeName="",


  });
  int userTypeID;
  String userTypeName;

  factory UserType.fromJson(Map<String, dynamic> json) => UserType(
        userTypeID: json["userTypeID"],
        userTypeName: json["userTypeName"],


      );
  Map<String, dynamic> toJson() => {
        "userTypeID": userTypeID,
        "userTypeName": userTypeName,

      };
}
