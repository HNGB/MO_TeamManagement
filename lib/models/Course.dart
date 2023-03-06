class Course {
  final int courseId;
  final String courseName;
  final String keyEnroll;
  final int subId;
  final int semId;
  final String image;
  final int status;

  Course(
      {required this.courseId,
      required this.courseName,
      required this.keyEnroll,
      required this.subId,
      required this.semId,
      required this.image,
      required this.status});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      courseId: json['courseId'],
      courseName: json['courseName'],
      keyEnroll: json['keyEnroll'],
      subId: json['subId'],
      semId: json['semId'],
      image: json['image'],
      status: json['status'],
    );
  }
}
