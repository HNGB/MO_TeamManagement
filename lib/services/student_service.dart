import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/Student.dart';
import '../models/Team.dart';

class StudentService {
  Future<List<Student>> getStudentsByTeamId(int teamId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(
          'https://befuprojectteammanagementdemo.azurewebsites.net/api/Team/$teamId/Student'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final students =
          jsonData.map((student) => Student.fromJson(student)).toList();
      return students;
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<List<Student>> getStudentsNonTeamByCourseId(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(
          'https://befuprojectteammanagementdemo.azurewebsites.net/api/Course/$courseId/StudentNonTeam'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final students =
          jsonData.map((student) => Student.fromJson(student)).toList();
      return students;
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<bool> deleteStudent(int studentId, int teamId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.put(
        Uri.parse(
            'https://befuprojectteammanagementdemo.azurewebsites.net/api/Team/$teamId/Remove/$studentId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return false;
  }

  Future<bool> addStudent(int teamId, List<int> studentIds) async {
    try {
      var body = jsonEncode({'studentIds': studentIds});
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.put(
        Uri.parse(
            'https://befuprojectteammanagementdemo.azurewebsites.net/api/Team/$teamId/Add-Students'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body,
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return false;
  }
}
