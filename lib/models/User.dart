class User {
  String? UserId;
  String? Name;
  String? JwtToken;
  String? Email;

  User(
    this.UserId,
    this.Name,
    this.JwtToken,
    this.Email,
  );

  User.fromJson(Map<String, dynamic> json) {
    UserId = json['userId'];
    Email = json['email'];
    Name = json['name'];
    JwtToken = json['jwtToken'];
  }

  User.empty() {
    UserId = "";
    Email = "";
    Name = "";
    JwtToken = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['UserId'] = this.UserId;
    data['Email'] = this.Email;
    data['Name'] = this.Name;
    return data;
  }
}
