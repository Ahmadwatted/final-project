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
      userID: json['userID'] ?? 0,  // Default to 0 if null
      userTypeID: json['usertypeID'] ?? 0,  // Default to 0 if null
      firstName: json['firstName'] ?? 'Unknown',  // Default to 'Unknown' if null
      secondName: json['secondName'] ?? 'Unknown',
      password: json['secondName'] ?? 'Unknown',
      phoneNumber: json['phoneNumber'] ?? 'N/A',
      email: json['email'] ?? 'N/A',
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
