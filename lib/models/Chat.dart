import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class Chat {
  late String MessageId;
  late String GroupId;
  late String SenderId;
  late String SenderName;
  late DateTime CreatedAt;
  late String Data;
  var uuid = Uuid();
  Chat(groupId, senderId, senderName, data) {
    MessageId = uuid.v4();
    GroupId = groupId;
    SenderId = senderId;
    SenderName = senderName;
    CreatedAt = DateTime.now();
    Data = data;
  }

  Chat.fromJson(Map<String, dynamic> json) {
    MessageId = json['messageId'];
    GroupId = json['groupId'];
    SenderId = json['senderId'];
    SenderName = json['senderName'];
    CreatedAt = DateTime.now();
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
    data['messageId'] = this.MessageId;
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
