import 'package:flutter/material.dart';

class AllCareGiverUI extends StatefulWidget {
  const AllCareGiverUI({super.key});

  @override
  State<AllCareGiverUI> createState() => _AllCareGiverUIState();
}

class _AllCareGiverUIState extends State<AllCareGiverUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text('รายชื่อผู้ดูแลทั้งหมด'),
    ));
  }
}
