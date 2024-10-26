import 'dart:convert';

class User {
  User({
    this.Email = "",
    this.FirstName = "",
    this.SecondName = "",
    this.PassWord = "",
    this.Address="",
  });

  String FirstName;
  String SecondName;
  String Email;
  String PassWord;
  String Address;

  factory User.fromJson(Map<String, dynamic> json) => User(
        Email: json["Email"],
        FirstName: json["FirstName"],
        SecondName: json["SecondName"],
        PassWord: json["PassWord"],
        Address: json["Address"],
      );
  Map<String, dynamic> toJson() => {
        "FirstName": FirstName,
        "SecondName": SecondName,
        "Email": Email,
        "PassWord": PassWord,
        "Address": Address,
      };
}
