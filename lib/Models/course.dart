import 'dart:convert';


class course {

  course({
    this.courseID=0,
    this.teacherName="",
    this.courseName="",
    this.subject="",
    this.price_Per_Month=0,
    this.duration_In_Months=0,


  });
  int courseID;
  String teacherName;
  String courseName;
  String subject;
  int price_Per_Month;
  int duration_In_Months;

  factory course.fromJson(Map<String, dynamic> json) => course(

    courseID: json["courseID"],
    teacherName: json["teacherName"],
    courseName: json["courseName"],
    subject: json["subject"],
    price_Per_Month: json["price_Per_Month"],
    duration_In_Months: json["duration_In_Months"]



  );
  Map<String, dynamic> toJson() => {
    "courseID": courseID,
    "teacherName": teacherName,
    "courseName": courseName,
    "subject": subject,
    "price_Per_Month": price_Per_Month,
    "duration_In.Months" :duration_In_Months,

  };
}
