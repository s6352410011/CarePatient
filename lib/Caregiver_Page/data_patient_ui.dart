import 'package:flutter/material.dart';

class DataPatientUI extends StatefulWidget {
  const DataPatientUI({super.key});

  @override
  State<DataPatientUI> createState() => _DataPatientUIState();
}

class _DataPatientUIState extends State<DataPatientUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูลผู้ป่วย'),
      ),
    );
  }
}
