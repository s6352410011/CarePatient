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
    Key? key,
    required this.receiverEmail,
    required this.receiverID,
  }) : super(key: key);

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
    String senderID = 'your_sender_id'; // Replace with your sender ID
    String receiverID = 'your_receiver_id'; // Replace with your receiver ID
    if (senderID == null) {
      // Handle the case when senderID is null (user not logged in)
      // You can show a message or redirect to the login page
      return Scaffold(
        body: Center(
          child: Text('User not logged in.'),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverEmail),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList(senderID,receiverID)),
          _buildUserInput(),
        ],
      ),
    );
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
        // Filter messages based on senderID (current user's ID) and receiverID
        List<QueryDocumentSnapshot> messages = snapshot.data!.docs.where((doc) {
          var data = doc.data()
              as Map<String, dynamic>?; // Cast to Map<String, dynamic>
          return data != null &&
              data['senderID'] == senderID &&
              data['receiverID'] == receiverID;
        }).toList();

        return ListView(
          children: messages.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    String? currentUserID = _authService.getCurrentUserID();
    bool isCurrentUser =
        currentUserID != null && data['senderID'] == currentUserID;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(data["message"]),
        ],
      ),
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
