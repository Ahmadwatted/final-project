class UserCourse {
  final int rowID;
  final int courseID;
  final int userID;

  UserCourse({
    required this.rowID,
    required this.courseID,
    required this.userID,


  });


  factory UserCourse.fromJson(Map<String, dynamic> json){ return UserCourse(
      rowID: json["rowID"],
      courseID: json["courseID"],
      userID: json["userID"]
  );
  }



  Map<String, dynamic> toJson() {
    return {
      "rowID": rowID,
      "courseID": courseID,
      "userID" : userID,



    };


  }
}
