import 'package:care_patient/class/color.dart';
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
        automaticallyImplyLeading: false, // กำหนดให้ไม่แสดงปุ่ม back
        title: Text(
          'แบบฟอร์มลงทะเบียน',
          style: TextStyle(
            color: AllColor.bg,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: AllColor.pr, // กำหนดสีพื้นหลังของ AppBar เป็นสีเขียว
      ),
    );
  }
}
