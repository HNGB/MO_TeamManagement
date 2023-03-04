import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Course.dart';

class CourseService {
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse(
        'https://befuprojectteammanagementdemo.azurewebsites.net/api/Course'));

    if (response.statusCode == 200) {
      var coursesJson = jsonDecode(response.body) as List;
      return coursesJson
          .map((courseJson) => Course.fromJson(courseJson))
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  Future<List<Course>> getCoursesByTeacherId(int teacherId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(
          'https://befuprojectteammanagementdemo.azurewebsites.net/api/Teacher/$teacherId/Course'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var coursesJson = jsonDecode(response.body) as List;
      return coursesJson
          .map((courseJson) => Course.fromJson(courseJson))
          .toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }
}
