import 'package:care_patient/chat/chat_bubble.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:care_patient/class/chat_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class ChatPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();
  final AuthenticationService _authService = AuthenticationService();




  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      String message = _messageController.text;
      Stream<String> receiverIDStream = Stream.value(receiverID);
      await _chatService.sendMessage(receiverIDStream, message);
      _messageController.clear();
    }
  }

@override
Widget build(BuildContext context) {
  final String? currentUserID = _authService.getCurrentUserID();
  final String senderID = currentUserID ?? ''; // Use an empty string if currentUserID is null

  if (senderID != null) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(senderID, receiverID)),
          _buildUserInput(),
        ],
      ),
    );
  } else {
    return Scaffold(
      body: Center(
        child: Text('User not logged in.'),
      ),
    );
  }
}


Widget _buildMessageList(String senderID, String receiverID) {
  return StreamBuilder(
    stream: _chatService.getMessage(senderID, receiverID),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: CircularProgressIndicator());
      }
      
      // Filter messages based on senderID and receiverID
      List<QueryDocumentSnapshot> messages = snapshot.data!.docs.where((doc) {
        var data = doc.data() as Map<String, dynamic>?; // Cast to Map<String, dynamic>
        return data != null &&
            data['senderID'] == senderID &&
            data['receiverID'] == receiverID;
      }).toList();

      // Map each document snapshot to a message widget
      List<Widget> messageWidgets = messages.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return _buildMessageItem(data);
      }).toList();

      return ListView(
        children: messageWidgets,
      );
    },
  );
}


Widget _buildMessageItem(Map<String, dynamic> data) {
  String message = data["message"];
  return FutureBuilder<User?>(
    future: _authService.getCurrentUser(),
    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // แสดงโหลดเมื่อกำลังโหลดข้อมูล
        return CircularProgressIndicator();
      }
      if (snapshot.hasError) {
        // แสดงข้อผิดพลาดหากเกิดข้อผิดพลาด
        return Text('Error: ${snapshot.error}');
      }
      
      // เช็คว่าผู้ใช้ปัจจุบันมีการเข้าสู่ระบบหรือไม่
      bool isCurrentUser = data['senderID'] == snapshot.data?.uid;

      // Adjust styling and alignment based on sender or receiver
      return Container(
        alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            ChatBubble(message: message, isCurrentUser: isCurrentUser),
          ],
        ),
      );
    },
  );
}





  Widget _buildUserInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            obscureText: false,
          ),
        ),
        IconButton(
          onPressed: () => sendMessage(),
          icon: Icon(Icons.arrow_upward),
        )
      ],
    );
  }
}
