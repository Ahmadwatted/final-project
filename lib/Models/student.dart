import 'user.dart';

class Student {
  final int studentID;
  final String firstName;
  final String secondName;
  final String phoneNumber;
  final String email;

  Student({
    required this.studentID,
    required this.firstName,
    required this.secondName,
    required this.phoneNumber,
    required this.email,
  });


  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      studentID: json['studentID'],
      firstName: json['firstName'],
      secondName: json['secondName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],

    );
  }

  Map<String, dynamic> toJson() {
    return {
      "studentID": studentID,
      "firstName": firstName,
      "secondName": secondName,
      "phoneNumber": phoneNumber,
      "email": email,


    };
  }
}
