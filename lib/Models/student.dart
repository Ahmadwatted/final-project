import 'user.dart';

class Student {
  late int userID;
  late String firstName;
  late String secondName;
  late String phoneNumber;
  late String email;

  Student({
    required this.userID,
    required this.firstName,
    required this.secondName,
    required this.phoneNumber,
    required this.email,
  });

  void ConvertToStudent(User user) {
    this.userID = user.userID;
    this.firstName = user.firstName;
    this.secondName = user.secondName;
    this.phoneNumber = user.phoneNumber;
    this.email = user.email;
  }


  factory Student.fromJson(Map<String, dynamic> json) {

    return Student(
      userID: json['userID'],
      firstName: json['firstName'],
      secondName: json['secondName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],

    );
  }



}
