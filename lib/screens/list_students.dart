import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:team_management/models/Course.dart';
import 'package:team_management/models/Student.dart';
import 'package:team_management/screens/topic.dart';
import 'package:team_management/services/student_service.dart';
import 'package:team_management/services/topic_service.dart';
import '../models/Team.dart';
import '../models/Topic.dart';

class ListStudents extends StatefulWidget {
  final Team team;
  final Course course;
  const ListStudents({Key? key, required this.team, required this.course})
      : super(key: key);
  @override
  _ListStudentsState createState() => _ListStudentsState();
}

class _ListStudentsState extends State<ListStudents> {
  final StudentService studentService = StudentService();
  final TopicService topicService = TopicService();
  List<Student> listStudent = [];
  List<Student> nonTeamStudents = [];
  List<bool> checkedStudents = [];
  List<int> selectedStudentIds = [];
  bool isEditing = false;
  String topic = '';
  Topic tp = Topic(
      topicId: 0,
      topicName: "",
      courseId: 0,
      status: 0,
      deadlineDate: DateTime(2022, 9, 9),
      requirement: "");
  final TextEditingController textController = TextEditingController();
  void updateTopicName(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicPage(topicO: tp, team: widget.team),
      ),
    );
    if (result != null) {
      getTopic().then((value) {
        setState(() {
          topic = result;
          tp = value;
        });
      });
    }
  }

  Future<void> deleteStudent(Student student, int teamId) async {
    var studentName = student.stuName;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$studentName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () {
                studentService
                    .deleteStudent(student.stuId, teamId)
                    .then((checkDelete) {
                  if (checkDelete) {
                    getStudent().then((students) {
                      setState(() {
                        listStudent = students;
                      });
                      Fluttertoast.showToast(
                          msg: "$studentName has been deleted!");
                    });
                  }
                });

                Navigator.of(context).pop();
              },
              child: const Text('DELETE'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getStudent().then((student) {
      setState(() {
        listStudent = student;
      });
    });
    getStudentNonTeam().then((student) {
      setState(() {
        nonTeamStudents = student;
        checkedStudents = List.filled(student.length, false);
      });
    });
    getTopic().then((value) {
      setState(() {
        topic = value.topicName;
        tp = value;
      });
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void updateStateListStudent(List<Student> students) {
    setState(() {
      listStudent = students;
    });
  }

  @override
  Widget build(BuildContext context) {
    void updateStateListStudentNonTeam(List<Student> students) {
      setState(() {
        nonTeamStudents = students;
        checkedStudents = List.filled(students.length, false);
      });
    }

    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              icon: const Icon(Icons.topic, color: Colors.white),
              label: Padding(
                padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Text(
                  topic.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
              onPressed: () {
                // setState(() {
                //   isEditing = true;
                // });
                updateTopicName(context);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            padding: const EdgeInsets.fromLTRB(120, 5, 120, 5),
            height: 50.0,
            child: SizedBox.expand(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, color: Colors.blue),
                label: const Text(
                  'Add Student',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () {
                  // Lấy danh sách sinh viên không thuộc nhóm
                  getStudentNonTeam().then((value) {
                    updateStateListStudentNonTeam(value);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Text('Add Student'),
                              content: Container(
                                width: double.maxFinite,
                                child: ListView(
                                  shrinkWrap: true,
                                  children: nonTeamStudents
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    Student student = entry.value;
                                    return CheckboxListTile(
                                      title: Text(student.stuName),
                                      subtitle: Text(student.stuCode),
                                      value: checkedStudents[index],
                                      onChanged: (value) {
                                        setState(() {
                                          checkedStudents[index] = value!;
                                          if (checkedStudents[index]) {
                                            selectedStudentIds
                                                .add(student.stuId);
                                          } else {
                                            selectedStudentIds
                                                .remove(student.stuId);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Cancel'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text('Add'),
                                  onPressed: () {
                                    studentService
                                        .addStudent(widget.team.teamId,
                                            selectedStudentIds)
                                        .then((checkAdd) {
                                      if (checkAdd) {
                                        getStudent().then((students) {
                                          updateStateListStudent(students);
                                        });
                                        Fluttertoast.showToast(
                                            msg: "Add Student successful!");
                                      }
                                    });

                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  });

                  // Hiển thị danh sách sinh viên không thuộc nhóm trên một popup
                },
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  for (var student in listStudent)
                    Card(
                      child: ListTile(
                        title: Text(student.stuName),
                        subtitle: Text(student.stuCode),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            deleteStudent(student, widget.team.teamId);
                          },
                        ),
                        leading: const Icon(
                          Icons.person_3,
                          size: 30,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(widget.team.teamName),
      ),
    );
  }

  Future<List<Student>> getStudent() async {
    final teamId = widget.team.teamId;
    List<Student> students = await studentService.getStudentsByTeamId(teamId);
    students.sort((a, b) {
      String aLastName = a.stuName.split(' ').last;
      String bLastName = b.stuName.split(' ').last;
      String aFirstLetter = aLastName.isNotEmpty ? aLastName[0] : '';
      String bFirstLetter = bLastName.isNotEmpty ? bLastName[0] : '';
      return aFirstLetter.compareTo(bFirstLetter);
    });
    return students;
  }

  Future<List<Student>> getStudentNonTeam() async {
    final courseId = widget.course.courseId;
    List<Student> students =
        await studentService.getStudentsNonTeamByCourseId(courseId);
    students.sort((a, b) {
      String aLastName = a.stuName.split(' ').last;
      String bLastName = b.stuName.split(' ').last;
      String aFirstLetter = aLastName.isNotEmpty ? aLastName[0] : '';
      String bFirstLetter = bLastName.isNotEmpty ? bLastName[0] : '';
      return aFirstLetter.compareTo(bFirstLetter);
    });
    return students;
  }

  Future<Topic> getTopic() async {
    final teamId = widget.team.teamId;
    Topic topic = await topicService.getTopicByTeamId(teamId);
    return topic;
  }
}
