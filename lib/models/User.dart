class User {
  String? UserId;
  String? Email;
  String? Name;

  User.fromJson(Map<String, dynamic> json) {
    UserId = json['UserId'];
    Email = json['Email'];
    Name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.UserId;
    data['Email'] = this.Email;
    data['Name'] = this.Name;
    return data;
  }
}
