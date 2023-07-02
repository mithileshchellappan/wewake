import 'package:alarm_test/widgets/chatWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> chatMessages = [
    {"sender": "text1", "text": "Hello There", "isSelf": true},
    {"sender": "text1", "text": "Hello There", "isSelf": false},
    {"sender": "text1", "text": "Hello There", "isSelf": true},
    {"sender": "text1", "text": "Hello There", "isSelf": false},
  ];

  final senderTextController = TextEditingController();

  @override
  void dispose() {
    senderTextController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (senderTextController.text.isNotEmpty) {
      setState(() {
        chatMessages.insert(0, {
          "sender": "ivan dhaan",
          "text": senderTextController.text,
          "isSelf": true
        });
      });
      senderTextController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (message['isSelf']) {
                    return ChatSendBubble(text: message['text']);
                  } else {
                    return ChatReceiveBubble(
                      sender: message['sender'],
                      text: message['text'],
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoTextField(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                placeholder: 'iMessage',
                placeholderStyle: const TextStyle(
                  color: CupertinoColors.placeholderText,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                cursorColor: Colors.white,
                decoration: BoxDecoration(
                  color: Colors.grey[
                      700], // Set your desired text field background color here
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
