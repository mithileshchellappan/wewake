class Member {
  String? MemberGroupId;
  String? MemberId;
  String? GroupId;
  bool? IsAdmin;

  Member.fromJson(Map<String, dynamic> json) {
    MemberGroupId = json['MemberGroupId'];
    MemberId = json['MemberId'];
    GroupId = json['GroupId'];
    IsAdmin = json['IsAdmin'];
  }

  Map<String, dynamic> toJson() => {
        'MemberGroupId': MemberGroupId,
        'MemberId': MemberId,
        'GroupId': GroupId,
        'IsAdmin': IsAdmin,
      };
}
