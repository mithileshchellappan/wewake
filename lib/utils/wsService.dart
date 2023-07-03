import 'dart:io';

import 'package:alarm_test/utils/sharedPref.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/api.dart';

class WSService {
  late WebSocketChannel channel;
  late String userName;
  WSService(String groupId, this.userName) {
    var url = Uri.parse("${wsRoute}?group=${groupId}");
    print("Connected to ${url}");
    this.channel = WebSocketChannel.connect(url);
  }

  void sendMessage(dynamic message) {
    // message['isSelf'] = false;
    print(message);
    channel.sink.add(message.toString());
  }

  void listenForMessage(void onMessageReceived(dynamic data)) {
    channel.stream.listen(onMessageReceived);
  }

  void disconnectFromServer() {
    channel.sink.close();
  }
}
