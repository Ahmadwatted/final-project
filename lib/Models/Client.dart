import 'dart:convert';

class Client {
  Client({
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

  factory Client.fromJson(Map<String, dynamic> json) => Client(
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
