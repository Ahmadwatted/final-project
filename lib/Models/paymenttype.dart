import 'dart:convert';


class PaymentType {

  PaymentType({
    this.paymentTypeID=0,
    this.paymentTypeName="",


  });
  int paymentTypeID;
  String paymentTypeName;

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
    paymentTypeID: json["paymentTypeID"],
    paymentTypeName: json["paymentTypeName"],


  );
  Map<String, dynamic> toJson() => {
    "paymentTypeID": paymentTypeID,
    "paymentTypeName": paymentTypeName,

  };
}
