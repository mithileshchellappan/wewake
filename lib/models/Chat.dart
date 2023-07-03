class Chat {
  late String MessageId;
  late String GroupId;
  late String SenderId;
  late String SenderName;
  late DateTime CreatedAt;
  late String Data;

  Chat(this.GroupId, this.SenderId, this.SenderName, this.CreatedAt, this.Data);

  Chat.fromJson(Map<String, dynamic> json) {
    MessageId = json['messageId'];
    GroupId = json['groupId'];
    SenderId = json['senderId'];
    SenderName = json['senderName'];
    Data = json['data'];
  }

  Chat.empty() {
    MessageId = "";
    GroupId = "";
    SenderId = "";
    SenderName = "";
    Data = "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['groupId'] = this.GroupId;
    data['senderId'] = this.SenderId;
    data['senderName'] = this.SenderName;
    data['data'] = this.Data;
    return data;
  }

  static List<Chat> fromListJson(List<dynamic> arr) {
    List<Chat> chats = [];
    for (var json in arr) {
      Chat chat = Chat.fromJson(json);
      chats.add(chat);
    }
    return chats;
  }
}
