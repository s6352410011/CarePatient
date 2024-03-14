import 'package:flutter/material.dart';

class CFormInfoUI extends StatefulWidget {
  const CFormInfoUI({super.key});

  @override
  State<CFormInfoUI> createState() => _CFormInfoUIState();
}

class _CFormInfoUIState extends State<CFormInfoUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลทั่วไป'),
      ),
    );
  }
}
