class Topic {
  final int topicId;
  final String topicName;
  final int courseId;
  final int status;
  final DateTime deadlineDate;
  final String requirement;
  Topic({
    required this.topicId,
    required this.topicName,
    required this.courseId,
    required this.deadlineDate,
    required this.requirement,
    required this.status,
  });
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      topicName: json['topicName'],
      courseId: json['courseId'],
      deadlineDate: DateTime.parse(json['deadlineDate']),
      requirement: json['requirement'],
      status: json['status'],
    );
  }
}
