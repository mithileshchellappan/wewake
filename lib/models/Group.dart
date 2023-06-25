class Group {
  String? GroupId;
  String? GroupName;
  String? AdminId;
  DateTime? CreatedAt;
  bool? CanMemberCreateAlarm;

  Group.fromJson(Map<String, dynamic> json) {
    GroupId = json['GroupId'];
    GroupName = json['GroupName'];
    AdminId = json['AdminId'];
    CreatedAt = json['CreatedAt'];
    CanMemberCreateAlarm = json['CanMemberCreateAlarm'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['GroupId'] = this.GroupId;
    data['GroupName'] = this.GroupName;
    data['AdminId'] = this.AdminId;
    data['CreatedAt'] = this.CreatedAt;
    data['CanMemberCreateAlarm'] = this.CanMemberCreateAlarm;
    return data;
  }
}
