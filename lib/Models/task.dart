class DayTask {
  final String day;
  final List<String> name;


  DayTask ({
    required this.day,
    required this.name,
  });

  factory DayTask.fromJson(Map<String, dynamic> map) {
    return DayTask(
      day: map['day'] as String,
      name: List<String>.from(map['name'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'name': name,
    };
  }
}