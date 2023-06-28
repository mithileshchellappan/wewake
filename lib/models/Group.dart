class Group {
  String? GroupId;
  String? GroupName;
  String? AdminId;
  DateTime? CreatedAt;
  bool? CanMemberCreateAlarm;

  Group.fromJson(Map<String, dynamic> json) {
    GroupId = json['groupId'];
    GroupName = json['groupName'];
    AdminId = json['adminId'];
    CreatedAt = json['createdAt'];
    CanMemberCreateAlarm = json['canMemberCreateAlarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.GroupId;
    data['groupName'] = this.GroupName;
    data['adminId'] = this.AdminId;
    data['createdAt'] = this.CreatedAt;
    data['canMemberCreateAlarm'] = this.CanMemberCreateAlarm;
    return data;
  }

  static List<Group> fromListJson(List<dynamic> arr) {
    List<Group> groups = [];
    for (var json in arr) {
      Group group = Group.fromJson(json);
      groups.add(group);
    }
    return groups;
  }
}
