import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';

class ChatReceiveBubble extends StatelessWidget {
  String sender;
  String text;
  ChatReceiveBubble({
    required this.sender,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Text(
            sender,
            style: TextStyle(color: CupertinoColors.inactiveGray),
          ),
        ),
        SizedBox(height: 5),
        ChatBubble(
          clipper: ChatBubbleClipper3(type: BubbleType.receiverBubble),
          backGroundColor: CupertinoColors.systemGrey,
          margin: EdgeInsets.only(bottom: 20),
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
            ),
            child: Text(
              text,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

class ChatSendBubble extends StatelessWidget {
  final String text;
  const ChatSendBubble({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {},
      child: ChatBubble(
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
      ),
    );
  }
}
