import 'user.dart';

class Student {
  late int userID;
  late int usertypeID;
  late String firstName;
  late String secondName;
  late String password;
  late String phoneNumber;
  late String email;

  Student({
    required this.usertypeID,
    required this.userID,
    required this.firstName,
    required this.secondName,
    required this.password,
    required this.phoneNumber,
    required this.email,
  });

  void ConvertToStudent(User user) {
    this.userID = user.userID;
    this.usertypeID = user.userTypeID;
    this.firstName = user.firstName;
    this.secondName = user.secondName;
    this.password = user.password;
    this.phoneNumber = user.phoneNumber;
    this.email = user.email;
  }


  factory Student.fromJson(Map<String, dynamic> json) {

    return Student(
      userID: json['userID'],
      firstName: json['firstName'],
      secondName: json['secondName'],
      password: json['password'],
      phoneNumber: json['phoneNumber'],
      usertypeID: json['usertypeID'],
      email: json['email'],

    );
  }



}
