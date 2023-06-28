class Member {
  String? MemberName;
  String? MemberId;
  bool IsAdmin = false;

  Member.fromJson(Map<String, dynamic> json) {
    MemberName = json['memberName'];
    MemberId = json['meberId'];
    IsAdmin = json['isAdmin'];
  }

  Map<String, dynamic> toJson() => {
        'MemberName': MemberName,
        'MemberId': MemberId,
        'IsAdmin': IsAdmin,
      };
  static List<Member> fromListJson(List<dynamic> arr) {
    List<Member> members = [];
    for (var json in arr) {
      Member member = Member.fromJson(json);
      members.add(member);
    }
    members.sort((a, b) => b.IsAdmin ? 1 : -1);
    return members;
  }
}
