import 'dart:convert';


class paymenttype {

  paymenttype({
    this.paymentTypeID=0,
    this.paymentTypeName="",


  });
  int paymentTypeID;
  String paymentTypeName;

  factory paymenttype.fromJson(Map<String, dynamic> json) => paymenttype(
    paymentTypeID: json["paymentTypeID"],
    paymentTypeName: json["paymentTypeName"],


  );
  Map<String, dynamic> toJson() => {
    "paymentTypeID": paymentTypeID,
    "paymentTypeName": paymentTypeName,

  };
}
