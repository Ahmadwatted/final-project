class UserCourses {
  final int rowID;
  final int courseID;
  final int userID;
  UserCourses({
    required this.rowID,
    required this.courseID,
    required this.userID,
  });
  factory UserCourses.fromJson(Map<String, dynamic> json){ return UserCourses(
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