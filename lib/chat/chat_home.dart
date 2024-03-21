import 'package:care_patient/chat/%E0%B8%B5user_tile.dart';
import 'package:care_patient/chat/chat_page.dart';
import 'package:care_patient/class/chat_service.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final ChatService _chatService = ChatService();
  final AuthenticationService _authService = AuthenticationService();

  // void logout() {
  //   final _auth = AuthService();
  //   _auth.singOut();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(""),
        toolbarHeight: 20,
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            children: snapshot.data!
                .map((userData) => _buildUserListItem(userData))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(Map<String, dynamic> userData) {
    if (userData["email"] != _authService.chat()!.email) {
      return UserTile(
          text: userData["email"],
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(receiverEmail: userData["email"] ?? '')),
            );
          });
    } else {
      return Container();
    }
  }
}
