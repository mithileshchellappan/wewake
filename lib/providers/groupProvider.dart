import 'package:alarm_test/models/Group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupProvider extends ChangeNotifier {
  List<Group>? _groups;
  List<Group>? get groups => _groups; // Fix here

  void setGroup(List<Group> groups) {
    _groups = groups;
    notifyListeners();
  }

  void removeGroup(Group group) {
    _groups?.remove(group);
    notifyListeners();
  }

  void appendGroup(Group group) {
    _groups?.add(group);
    notifyListeners();
  }

  void clearGroups() {
    _groups = [];
    notifyListeners();
  }

  Group getGroup(String groupId) {
    Group group = _groups!.firstWhere((element) => element.GroupId == groupId);
    return group;
  }
}
