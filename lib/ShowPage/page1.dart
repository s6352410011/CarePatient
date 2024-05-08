import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';

class ShowPage1 extends StatelessWidget {
  const ShowPage1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AllColor.Backgroud,
        image: DecorationImage(
          image: AssetImage(
              'assets/images/event.png'), // เพิ่มรูป event.png ที่ต้องการแสดง
          fit: BoxFit.fill, // ให้รูปครอบคลุมพื้นที่ทั้งหมด
        ),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        height: 280,
      ),
    );
  }
}