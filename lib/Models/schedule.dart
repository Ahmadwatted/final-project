class DaySchedule {
  final String day;
  final List<String> classes;

  DaySchedule({
    required this.day,
    required this.classes,
  });

  factory DaySchedule.fromJson(Map<String, dynamic> map) {
    return DaySchedule(
      day: map['day'] as String,
      classes: List<String>.from(map['classes'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'classes': classes,
    };
  }
}