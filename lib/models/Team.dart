class Team {
  final int teamId;
  final String teamName;
  final int teamCount;
  final int status;

  Team({
    required this.teamId,
    required this.teamName,
    required this.teamCount,
    required this.status,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['teamId'],
      teamName: json['teamName'],
      teamCount: json['teamCount'],
      status: json['status'],
    );
  }
}
