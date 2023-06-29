class Group {
  String? GroupId;
  String? GroupName;
  String? AdminId;
  DateTime CreatedAt = DateTime.now();
  bool? CanMemberCreateAlarm;
  int? MemberCount = 1;
  bool IsAdmin = false;

  Group.fromJson(Map<String, dynamic> json) {
    GroupId = json['groupId'];
    GroupName = json['groupName'];
    AdminId = json['adminId'];
    CreatedAt = DateTime.parse(json['createdAt']);
    CanMemberCreateAlarm = json['canMemberCreateAlarm'];
    MemberCount = json['memberCount'];
    IsAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.GroupId;
    data['groupName'] = this.GroupName;
    data['adminId'] = this.AdminId;
    data['createdAt'] = this.CreatedAt;
    data['canMemberCreateAlarm'] = this.CanMemberCreateAlarm;
    data['memberCount'] = this.MemberCount;
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
