import 'dart:convert';

import 'package:alarm_test/providers/userProvider.dart';
import 'package:alarm_test/widgets/chatWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../constants/api.dart';

class ChatScreen extends StatefulWidget {
  String groupId;
  ChatScreen(this.groupId, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> chatMessages = [
    {"senderName": "text1", "data": "Hello There", "senderId": "not me"},
    {"senderName": "text1", "data": "Hello There", "senderId": "not me"},
    {"senderName": "text1", "data": "Hello There", "senderId": "not me"},
    {"senderName": "text1", "data": "Hello There", "senderId": "not me"},
  ];

  final senderTextController = TextEditingController();
  var channel;
  var userProvider;
  @override
  void dispose() {
    senderTextController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    var url = Uri.parse("${wsRoute}?group=${widget.groupId}");
    channel = WebSocketChannel.connect(url);
    print("connected to ${url}");
    // stream = channel.stream;
    channel.stream.listen(addMessage);
  }

  void sendMessage() {
    if (senderTextController.text.isNotEmpty) {
      var json = {
        "senderId": userProvider.user.UserId,
        "senderName": userProvider.user.Name,
        "data": senderTextController.text
      };
      print(json.toString());
      setState(() {
        chatMessages.insert(0, json);
      });
      senderTextController.clear();
      channel.sink.add(jsonEncode(json));
    }
  }

  void addMessage(dynamic jsonData) {
    var json = jsonDecode(jsonData);
    print(jsonData);
    setState(() {
      chatMessages.insert(0, json);
    });
  }

  @override
  Widget build(BuildContext context) {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
      appBar: CupertinoNavigationBar(
        brightness: Theme.of(context).brightness,
        backgroundColor: Theme.of(context).backgroundColor,
        transitionBetweenRoutes: true,
        automaticallyImplyLeading: true,
        middle: Text(
          'Chat',
          style: TextStyle(color: Colors.white),
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
                  if (message['senderId'] == userProvider.user.UserId) {
                    return ChatSendBubble(text: message['data']);
                  } else {
                    return ChatReceiveBubble(
                      sender: message['senderName'],
                      text: message['data'],
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

class ChatSendBubble extends StatelessWidget {
  String text;
  ChatSendBubble({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ChatBubble(
      clipper: ChatBubbleClipper3(type: BubbleType.sendBubble),
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(bottom: 20),
      backGroundColor: Colors.blue,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
