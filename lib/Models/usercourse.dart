import 'dart:convert';
class UserCourse {

  UserCourse({
    this.rowID =0,
    this.courseID=0,
    this.userID=0,


  });
  int rowID=0;
  int courseID=0;
  int userID=0;

  factory UserCourse.fromJson(Map<String, dynamic> json) => UserCourse(
    rowID: json["rowID"],
    courseID: json["courseID"],
    userID: json["userID"]


  );
  Map<String, dynamic> toJson() => {
    "rowID": rowID,
    "courseID": courseID,
    "userID" : userID,

  };
}
