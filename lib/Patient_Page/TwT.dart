import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Title(color: AllColor.Backgroud, child: Text('data')),
    );
  }
}
