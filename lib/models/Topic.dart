class Topic {
  final int topicId;
  final String topicName;
  final int courseId;
  final int status;
  Topic(
      {required this.topicId,
      required this.topicName,
      required this.courseId,
      required this.status});
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      topicId: json['topicId'],
      topicName: json['topicName'],
      courseId: json['courseId'],
      status: json['status'],
    );
  }
}
