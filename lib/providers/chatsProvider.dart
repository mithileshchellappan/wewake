import 'package:alarm_test/models/Chat.dart';
import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  Map<String, List<Chat>>? _chats = {};
  Map<String, List<Chat>>? get chats => _chats;
  int noOfChats = 0;

  void setGroupChat(String groupId, List<Chat> chats) {
    if (noOfChats == 5) {
      _chats!.remove(_chats!.keys.toList().first);
      _chats![groupId] = chats;
      noOfChats = 5;
    } else {
      if (_chats![groupId] == null) {
        ++noOfChats;
      }
      _chats![groupId] = chats;
    }
    print(_chats.toString() + noOfChats.toString());
  }
}
