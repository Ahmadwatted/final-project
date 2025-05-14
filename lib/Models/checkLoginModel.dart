class checkLoginModel {
  String? result;
  int userID;
  String? userTypeID;
  String? firstName;
  String? secondName;
  String? phoneNumber;
  String? email;
  checkLoginModel({
    this.result,
    required this.userID,
    this.userTypeID,
    this.phoneNumber,
    this.email,
    this.secondName,
    this.firstName,
  });
  factory checkLoginModel.fromJson(Map<String, dynamic> json) {
    return checkLoginModel(
      result: json['result'],
      userID: json['userID'],
      userTypeID: json['userTypeID'],
      firstName: json['firstName'],
      secondName: json['secondName'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
    );
  }
}