import 'dart:convert';

class User {

  User({
    this.Email="",
    this.FirstName="",
    this.SecondName="",
    this.PassWord="",











});

  String FirstName;
  String SecondName;
  String Email;
  String PassWord;

  factory User.fromJson(Map<String, dynamic> json) =>User(

  Email: json["Email"],
  FirstName: json["FirstName"],
  SecondName: json["SecondName"],
  PassWord: json["PassWord"],



  );
  Map<String,dynamic> toJson() => {

    "FirstName": FirstName,
    "SecondName": SecondName,
    "Email": Email,
    "PassWord":PassWord


  };




}