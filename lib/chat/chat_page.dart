// chat_page.dart
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;

  const ChatPage(userData, userDataUid,
      {super.key, required this.receiverEmail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $receiverEmail'),
      ),
      body: Center(
        child: Text('Chat with $receiverEmail'),
      ),
    );
  }
}
