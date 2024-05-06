import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';

class NotificationsUI extends StatelessWidget {
  static const Color appBarColor = AllColor.Primary_C;
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
