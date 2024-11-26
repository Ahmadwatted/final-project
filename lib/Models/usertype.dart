import 'dart:convert';


class usertype {

  usertype({
    this.userTypeID=0,
    this.userTypeName="",


  });
  int userTypeID;
  String userTypeName;

  factory usertype.fromJson(Map<String, dynamic> json) => usertype(
        userTypeID: json["userTypeID"],
        userTypeName: json["userTypeName"],


      );
  Map<String, dynamic> toJson() => {
        "userTypeID": userTypeID,
        "userTypeName": userTypeName,

      };
}
