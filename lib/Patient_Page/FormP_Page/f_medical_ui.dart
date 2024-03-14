import 'package:flutter/material.dart';

class PFormMedicalUI extends StatefulWidget {
  const PFormMedicalUI({super.key});

  @override
  State<PFormMedicalUI> createState() => _PFormMedicalUIState();
}

class _PFormMedicalUIState extends State<PFormMedicalUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ประวัติการรักษา'),
      ),
    );
  }
}
