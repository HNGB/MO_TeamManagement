import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:team_management/models/Course.dart';
import 'package:team_management/screens/list_courses.dart';

import '../services/course_service.dart';
import 'list_team.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CourseService courseService = CourseService();
  List<Course> listCourses = [];
  List<Course> listLastCourses = [];

  @override
  void initState() {
    super.initState();
    _getCourses().then((courses) {
      setState(() {
        listCourses = courses;
        if (courses.length > 4) {
          listLastCourses = courses.reversed.toList().sublist(0, 4);
        } else {
          listLastCourses = courses;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                            text: 'Welcome,\n',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 35),
                            children: [
                              TextSpan(
                                text: user.displayName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 25),
                              ),
                            ]),
                      ),
                    ),
                    const SizedBox(width: 10),
                    CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.network(
                          user.photoURL!,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Search Course',
                  ),
                ),
                const SizedBox(height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Courses',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ListCourses()),
                        );
                      },
                      child: const Text(
                        'All Courses>>',
                        style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 17),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    crossAxisCount: 2,
                    childAspectRatio: 1.08,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: List.generate(
                      listLastCourses.length,
                      (index) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ListTeams(course: listLastCourses[index]),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.9),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(4, 6),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                                child: Image.network(
                                  listLastCourses[index].image,
                                  fit: BoxFit.cover,
                                  width: 500,
                                  height: 120,
                                ),
                              ),
                              Column(
                                children: [
                                  const Expanded(child: SizedBox()),
                                  const SizedBox(height: 5),
                                  Center(
                                    child: Text(
                                      listLastCourses[index].courseName,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )));
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
