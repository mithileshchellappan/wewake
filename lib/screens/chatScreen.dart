import 'dart:convert';

import 'package:alarm_test/api/chat.dart';
import 'package:alarm_test/models/Chat.dart';
import 'package:alarm_test/providers/chatsProvider.dart';
import 'package:alarm_test/providers/userProvider.dart';
import 'package:alarm_test/widgets/chatWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/api.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  const ChatScreen(this.groupId, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Chat> chatMessages = [];
  final senderTextController = TextEditingController();
  var channel;
  var userProvider;
  var chatsProvider;
  @override
  void dispose() {
    senderTextController.dispose();
    channel?.sink?.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // chatsProvider = Provider.of<ChatProvider>(context, listen: false);
    userProvider = Provider.of<UserProvider>(context, listen: false);
    getChatsFromDB();
    reconnectToWs();
  }

  void getChatsFromDB() async {
    var res = await getChatsCheckerId(widget.groupId);
    // print(res);
    String? lastMessageId = chatsProvider.getLastMessageId(widget.groupId);
    print(res.toString() + (lastMessageId ?? "nothing"));
    if (lastMessageId == null || res['messageId'] != lastMessageId) {
      print("getting from db");
      var ress = await getGroupChats(widget.groupId);
      List<Chat> chats = Chat.fromListJson(ress['chats']);
      // print(ress);
      chatsProvider.setGroupChat(widget.groupId, chats);
      setState(() {});
    } else {
      print('getting from provider');
    }
  }

  bool isWSConnected = false;
  void connectToWs() async {
    try {
      var url = Uri.parse(
          "${wsRoute}?group=${widget.groupId}&auth=${userProvider.user.JwtToken}");
      channel = WebSocketChannel.connect(url);
      print(channel?.ready);
      print("connected to ${url}");

      channel.stream.listen(addMessage, onDone: () {
        print("channel closed");
      }, onError: (error) {
        print(error);
      });
    } on Exception catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Error Connecting to Chat");
    }
  }

  void sendMessage() {
    if (senderTextController.text.isNotEmpty) {
      // print(json.toString());
      if (channel?.closeCode == null) {
        Chat message = Chat(widget.groupId, userProvider.user.UserId,
            userProvider.user.Name, senderTextController.text);

        var json = message.toJson();
        chatsProvider.addMessageToChat(widget.groupId, message);
        channel.sink.add(jsonEncode(json));
        setState(() {
          // chatMessages.add(message);
        });
        senderTextController.clear();
      } else {
        Fluttertoast.showToast(msg: "Chat disconnected. Reconnect");
      }
    }
  }

  void addMessage(dynamic jsonData) {
    var json = jsonDecode(jsonData);
    Chat message = Chat.fromJson(json);
    chatsProvider.addMessageToChat(widget.groupId, message);
    setState(() {});
  }

  void reconnectToWs() {
    if (channel != null && channel.closeCode == null) {
      channel.sink.close();
    }
    connectToWs();
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    chatsProvider = Provider.of<ChatProvider>(context, listen: true);
    chatMessages = chatsProvider.chats[widget.groupId] ?? [];
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: CupertinoNavigationBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).backgroundColor,
        transitionBetweenRoutes: true,
        automaticallyImplyLeading: true,
        middle: const Text(
          'Chat',
          style: TextStyle(color: Colors.white),
        ),
        trailing: Material(
          color: Colors.black,
          child: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reconnectToWs,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8.0),
                itemCount: chatMessages.length,
                itemBuilder: (context, index) {
                  final message = chatMessages[index];
                  if (message.SenderId == userProvider.user.UserId) {
                    return ChatSendBubble(text: message.Data);
                  } else {
                    return ChatReceiveBubble(
                      sender: message.SenderName,
                      text: message.Data,
                    );
                  }
                },
              ),
            ),
            // StreamBuilder(
            //     stream: stream,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         var jsonData = jsonDecode(snapshot.data.toString());
            //         print(jsonData);
            //         addMessage(jsonData);
            //         return ChatReceiveBubble(
            //             sender: jsonData['sender'], text: jsonData['text']);
            //       }
            //       return Container();
            //     }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                placeholder: 'wMessage',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.placeholderText,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(20.0),
                ),
                maxLines: null,
                minLines: 1,
                controller: senderTextController,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.send,
                suffix: Padding(
                  padding: EdgeInsets.only(right: 12.0, left: 8.0),
                  child: InkWell(
                    onTap: sendMessage,
                    child: const Icon(
                      CupertinoIcons.paperplane_fill,
                      color: Colors.white,
                      size: 28.0,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
