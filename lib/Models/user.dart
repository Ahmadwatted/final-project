import 'dart:convert';

class User {
  final int userID;
  final int userTypeID;
  final String firstName;
  final String secondName;
  final String email;
  final String password;
  final String phoneNumber;

  User({
    required this.userTypeID,
    required this.userID,
    required this.firstName,
    required this.secondName,
    required this.password,
    required this.phoneNumber,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'] ?? 0,
      userTypeID: json['usertypeID'] ?? 0,
      firstName: json['firstName'] ?? '',
      secondName: json['secondName'] ?? '',
      password: json['secondName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "firstName": firstName,
      "secondName": secondName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
      "userID": userID,
      "userTypeID": userTypeID,
    };
  }
}
