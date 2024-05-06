import 'package:flutter/material.dart';

class NotificationsUI extends StatelessWidget {
  static const Color appBarColor = Color.fromARGB(255, 116, 209, 147);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text('This is the Notifications UI'),
      ),
    );
  }
}
