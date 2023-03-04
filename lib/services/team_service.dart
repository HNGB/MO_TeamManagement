import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/Team.dart';

class TeamService {
  Future<List<Team>> getTeamByCourseId(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(
          'https://befuprojectteammanagementdemo.azurewebsites.net/api/Course/$courseId/Team'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as List<dynamic>;
      final teams = jsonData.map((team) => Team.fromJson(team)).toList();
      return teams;
    } else if (response.statusCode == 204) {
      return [];
    } else {
      throw Exception('Failed to load teams');
    }
  }

  Future<bool> deleteTeam(int teamId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.delete(
        Uri.parse(
            'https://befuprojectteammanagementdemo.azurewebsites.net/api/Team/$teamId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }

  Future<bool> addTeam(int courseId, String teamName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse(
            'https://befuprojectteammanagementdemo.azurewebsites.net/api/Team?courseId=$courseId'),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'teamName': teamName,
        }),
      );
      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      print(e.toString());
    }
    return false;
  }
}
