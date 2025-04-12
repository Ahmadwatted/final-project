class Tutor {
  final int tutorID;
  final String firstName;
  final String secondName;
  final String email;
  final String phoneNumber;

  Tutor({
    required this.tutorID,
    required this.firstName,
    required this.secondName,
    required this.email,
    required this.phoneNumber,
  });

  factory Tutor.fromJson(Map<String, dynamic> json) {
    return Tutor(
      tutorID: json['tutorID'] as int,
      firstName: json['firstName'],
      secondName: json['secondName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "tutorID": tutorID,
      "firstName": firstName,
      "secondName": secondName,
      "phoneNumber": phoneNumber,
      "email": email,
    };
  }


}
