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

  Widget _buildUserListItem(Map<String, dynamic>? userData) {
    if (userData == null) {
      return Container(); // หรือวิดเจ็ตเริ่มต้นอื่น ๆ เพื่อแสดงข้อความที่ข้อมูลขาดหายไป
    }

    String? currentUserEmail = _authService.chat()?.email;
    if (userData.containsKey("name") && userData["name"] != currentUserEmail) {
      return UserTile(
        text: userData["name"] ??
            '', // ใช้สตริงว่างเป็นค่าเริ่มต้นหาก email เป็น null
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData["name"] ??
                    '', // ใช้สตริงว่างเป็นค่าเริ่มต้นหาก name เป็น null
                receiverID: userData["email"] ??
                    '', // ใช้สตริงว่างเป็นค่าเริ่มต้นหาก email เป็น null
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
