import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/Topic.dart';

class TopicService {
  Future<Topic> getTopicByTeamId(int teamId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse(
          'https://befuprojectteammanagementdemo.azurewebsites.net/api/Team/$teamId/Get-a-topic'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      var topicJson = jsonDecode(response.body);
      Topic t = Topic.fromJson(topicJson);
      return t;
    } else if (response.statusCode == 204) {
      return Topic(
          courseId: 0,
          topicId: 0,
          topicName: "No Topic Yet",
          status: 1,
          deadlineDate: DateTime(0, 0, 0),
          requirement: '');
    } else {
      throw Exception('Failed to load topic');
    }
  }

  Future<bool> createTopicByTeamId(int teamId, String topicName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      var body = jsonEncode({'topicName': topicName});
      final response = await http.post(
          Uri.parse(
              'https://befuprojectteammanagementdemo.azurewebsites.net/api/Topic?teamId=$teamId'),
          body: body,
          headers: {
            'Authorization': 'Bearer $token',
            "Accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 200) return true;
    } catch (e) {
      throw Exception("Failed to create topic");
    }
    return false;
  }

  Future<bool> editTopicByTeamId(int teamId, int topicId, String topicName,
      DateTime deadlineDate, String requirements) async {
    final f = DateFormat('yyyy-MM-dd');
    String deadlineD = f.format(deadlineDate);
    try {
      var body = jsonEncode({
        'topicId': topicId,
        'topicName': topicName,
        'deadlineDate': deadlineD,
        'requirement': requirements,
      });
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
          Uri.parse(
              'https://befuprojectteammanagementdemo.azurewebsites.net/api/Topic?teamId=$teamId'),
          body: body,
          headers: {
            'Authorization': 'Bearer $token',
            "Accept": "application/json",
            "content-type": "application/json"
          });
      if (response.statusCode == 200) return true;
    } catch (e) {
      throw Exception("Failed to edit topic");
    }
    return false;
  }
}
