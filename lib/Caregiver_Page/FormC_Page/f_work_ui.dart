import 'package:flutter/material.dart';

class CFormWorkUI extends StatefulWidget {
  const CFormWorkUI({super.key});

  @override
  State<CFormWorkUI> createState() => _CFormWorkUIState();
}

class _CFormWorkUIState extends State<CFormWorkUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ปนะวัติการทำงาน'),
      ),
    );
  }
}
