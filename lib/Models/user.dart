import 'dart:convert';


class User {
  User({
    this.userTypeID=2,
    this.userID=0,
    this.firstName = "",
    this.secondName = "",
    this.password = "",
    this.phoneNumber="",
    this.email="",


  });
  int userID;
  int userTypeID;
  String firstName;
  String secondName;
  String email;
  String password;
  String phoneNumber;

  factory User.fromJson(Map<String, dynamic> json) => User(
    firstName: json["firstName"],
    secondName: json["secondName"],
    password: json["password"],
    phoneNumber: json["phoneNumber"],
    userID: json["userID"],
    userTypeID: json["userTypeID"],
    email: json["email"],


  );
  Map<String, dynamic> toJson() => {
    "firstName": firstName,
    "secondName": secondName,
    "email": email,
    "password": password,
    "phoneNumber": phoneNumber,
    "userID": userID,
    "userTypeID": userTypeID,

  };
}
