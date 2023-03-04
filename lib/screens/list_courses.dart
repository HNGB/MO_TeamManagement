import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Course.dart';
import '../services/course_service.dart';
import 'list_team.dart';

class ListCourses extends StatelessWidget {
  ListCourses({super.key});
  final CourseService courseService = CourseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
      ),
      body: FutureBuilder<List<Course>>(
        future: _getCourses(),
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.hasData) {
            final List<Course> courses = snapshot.data!;
            return Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: courses.map((course) {
                  return Card(
                    child: ListTile(
                      title: Text(course.courseName),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      leading: const Icon(
                        Icons.folder_copy,
                        size: 30,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListTeams(course: course),
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Future<List<Course>> _getCourses() async {
    final prefs = await SharedPreferences.getInstance();
    final teacherId = prefs.getInt('teacherId');
    if (teacherId == null) {
      throw Exception('teacherId not found in SharedPreferences');
    }
    return courseService.getCoursesByTeacherId(teacherId);
  }
}
