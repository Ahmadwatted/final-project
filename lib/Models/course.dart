class Course {
  final String name;
  final String instructor;
  final String time;
  final int colorValue;

  Course({
    required this.name,
    required this.instructor,
    required this.time,
    required this.colorValue,
  });

  factory Course.fromJson(Map<String, dynamic> map) {
    return Course(
      name: map['name'] as String,
      instructor: map['instructor'] as String,
      time: map['time'] as String,
      colorValue: map['color']?.value ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'instructor': instructor,
      'time': time,
      'colorValue': colorValue,
    };
  }
}