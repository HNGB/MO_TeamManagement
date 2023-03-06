import 'package:flutter/material.dart';
import 'package:team_management/models/Team.dart';
import 'package:team_management/models/Topic.dart';
import 'package:team_management/services/topic_service.dart';

class TopicPage extends StatefulWidget {
  final Topic topicO;
  final Team team;

  const TopicPage({super.key, required this.topicO, required this.team});
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final TopicService topicService = TopicService();
  String _topicName = 'No Have Topic Yet!';
  DateTime? _deadline;
  String _requirements = '';
  @override
  void initState() {
    super.initState();
    if (widget.topicO.topicId != 0) {
      _topicName = widget.topicO.topicName;
      _requirements = widget.topicO.requirement;
      if (widget.topicO.deadlineDate != DateTime(0, 0, 0)) {
        _deadline = widget.topicO.deadlineDate;
      }
    }
  }

  void _updateTopic(String name, DateTime? deadline, String requirements) {
    topicService.editTopicByTeamId(widget.team.teamId, widget.topicO.topicId,
        name, deadline!, requirements);
    setState(() {
      _topicName = name;
      _deadline = deadline;
      _requirements = requirements;
    });
  }

  void _editTopic(BuildContext context) async {
    String? name;
    DateTime? deadline;
    String requirements = _requirements;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Topic'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Topic Name',
                      ),
                      controller: TextEditingController(text: _topicName),
                      onChanged: (value) => name = value,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Deadline'),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      child: Text(
                        _deadline == null
                            ? 'No Deadline'
                            : '${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: _deadline ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          setState(() {
                            _deadline = picked;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Requirements',
                      ),
                      controller: TextEditingController(text: _requirements),
                      onChanged: (value) {
                        requirements = value;
                      },
                      maxLength: 400,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Save'),
                  onPressed: () {
                    if (name != null ||
                        deadline != null ||
                        requirements != _requirements) {
                      _updateTopic(name ?? _topicName, deadline ?? _deadline,
                          requirements);
                    }
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Topic'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Center(
            child: Text(
              _topicName.toUpperCase(),
              style: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            _deadline == null
                ? 'No Deadline'
                : 'Deadline: ${_deadline!.day}/${_deadline!.month}/${_deadline!.year}',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16.0),
          _requirements.isEmpty
              ? const Text(
                  'No requirements yet.',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Requirements:',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      _requirements,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ],
                ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            child: const Text('Edit Topic'),
            onPressed: () => _editTopic(context),
          ),
        ],
      ),
    );
  }
}
