class Student {
  final int stuId;
  final String stuCode;
  final String stuName;
  final String stuEmail;
  final String stuPhone;
  final DateTime dateOfBirth;
  final String stuGender;
  final int status;

  Student({
    required this.stuId,
    required this.stuCode,
    required this.stuName,
    required this.stuEmail,
    required this.stuPhone,
    required this.dateOfBirth,
    required this.stuGender,
    required this.status,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      stuId: json['stuId'],
      stuCode: json['stuCode'],
      stuName: json['stuName'],
      stuEmail: json['stuEmail'],
      stuPhone: json['stuPhone'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      stuGender: json['stuGender'],
      status: json['status'],
    );
  }
}
