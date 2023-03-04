import 'package:flutter/material.dart';
import 'package:team_management/models/Course.dart';
import 'package:team_management/screens/list_students.dart';
import 'package:team_management/services/team_service.dart';

import '../models/Team.dart';

class ListTeams extends StatefulWidget {
  final Course course;

  const ListTeams({Key? key, required this.course}) : super(key: key);
  @override
  ListTeamsState createState() => ListTeamsState();
}

class ListTeamsState extends State<ListTeams> {
  final TeamService teamService = TeamService();
  List<Team> listTeam = [];
  Future<void> _deleteTeam(String teamName, int teamId) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: Text('Are you sure you want to delete "$teamName"?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CANCEL'),
            ),
            TextButton(
              onPressed: () async {
                final deleted = await teamService.deleteTeam(teamId);
                if (deleted) {
                  final teams = await getTeam();
                  setState(() {
                    listTeam = teams;
                  });
                }
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
    getTeam().then((teams) {
      setState(() {
        listTeam = teams;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            padding: const EdgeInsets.fromLTRB(100, 0, 100, 0),
            height: 50.0,
            child: SizedBox.expand(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add, color: Colors.blue),
                label: const Text(
                  'New Team',
                  style: TextStyle(color: Colors.blue),
                ),
                onPressed: () async {
                  String? name;
                  name = await showDialog<String>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Add New Team'),
                        content: TextField(
                          onChanged: (value) => name = value,
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text('ADD'),
                            onPressed: () async {
                              if (name != null &&
                                  name!.isNotEmpty &&
                                  !listTeam
                                      .any((team) => team.teamName == name)) {
                                final newTeam = await teamService.addTeam(
                                    widget.course.courseId, name!);
                                if (newTeam) {
                                  final teams = await getTeam();
                                  setState(() {
                                    listTeam = teams;
                                  });
                                }
                                Navigator.pop(context, name);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (name != null &&
                      name!.isNotEmpty &&
                      !listTeam.any((team) => team.teamName == name)) {
                    final newTeam = await teamService.addTeam(
                        widget.course.courseId, name!);
                    if (newTeam) {
                      final teams = await getTeam();
                      setState(() {
                        listTeam = teams;
                      });
                    }
                  }
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
                  for (var team in listTeam)
                    Card(
                      child: ListTile(
                        title: Text(team.teamName),
                        subtitle:
                            Text("Team member: ${team.teamCount.toString()}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () =>
                              _deleteTeam(team.teamName, team.teamId),
                        ),
                        leading: const Icon(
                          Icons.groups_2,
                          size: 30,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListStudents(
                                  team: team, course: widget.course),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(widget.course.courseName),
      ),
    );
  }

  Future<List<Team>> getTeam() async {
    final courseId = widget.course.courseId;
    return teamService.getTeamByCourseId(courseId);
  }
}
