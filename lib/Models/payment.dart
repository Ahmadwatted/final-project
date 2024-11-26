import 'dart:convert';


class payment {

  payment({
    this.paymentID=0,
    this.paymentTypeID=0,
    this.date="",
    this.userID=0,
    this.quantity=0,


  });
  int paymentID;
  int paymentTypeID;
  String date;
  int userID;
  int quantity;

  factory payment.fromJson(Map<String, dynamic> json) => payment(
    paymentID: json["paymentID"],
    paymentTypeID: json["paymentTypeID"],
    date: json["date"],
    userID: json["userID"],
    quantity: json["quantity"],


  );
  Map<String, dynamic> toJson() => {
    "paymentID": paymentID,
    "paymentTypeID": paymentTypeID,
    "date": date,
    "userID": userID,
    "quantity": quantity,

  };
}
