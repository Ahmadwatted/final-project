class UserType {
   final int userTypeID;
  final String userTypeName;
  UserType({
    required this.userTypeID,
    required this.userTypeName,
  });
  factory UserType.fromJson(Map<String, dynamic> json) {
    return UserType(
      userTypeID: json["userTypeID"],
      userTypeName: json["userTypeName"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "userTypeID": userTypeID,
      "userTypeName": userTypeName,
    };
  }
}
