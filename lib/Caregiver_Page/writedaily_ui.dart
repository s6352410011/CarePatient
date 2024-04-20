import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // เพิ่มนี้เข้ามา

class WriteDailyUI extends StatefulWidget {
  const WriteDailyUI({Key? key});

  @override
  State<WriteDailyUI> createState() => _WriteDailyUIState();
}

class _WriteDailyUIState extends State<WriteDailyUI> {
  late String _selectedDate = DateFormat('วันที่ : dd MMMM yyyy', 'th')
      .format(DateTime.now()); // แปลงวันที่เป็นรูปแบบไทย

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'เขียนบันทึก',
          style: TextStyle(color: Colors.white), // สีข้อความ
        ),
        centerTitle: true, // จัดข้อความตรงกลาง
        backgroundColor: Colors.blue, // สีพื้นหลังของ AppBar
        leading: IconButton(
          // ปุ่ม back
          icon: Icon(Icons.arrow_back, color: Colors.white), // ไอคอน back
          onPressed: () {
            Navigator.pop(context); // การกลับไปยังหน้าก่อนหน้านี้
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(5.0), // ระยะห่างขอบ 5px
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$_selectedDate', // วันที่ปัจจุบัน
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18), // ขนาดอักษร
            ),
            SizedBox(height: 20), // ระยะห่างระหว่างข้อความและช่องเขียนบันทึก
            Text(
              'เขียนบันทึก :', // ข้อความช่องเขียนบันทึก
              style: TextStyle(fontSize: 18), // ขนาดอักษร
            ),
            SizedBox(height: 10), // ระยะห่างระหว่างข้อความและช่องเขียนบันทึก
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey), // เส้นขอบสีเทา
                  borderRadius: BorderRadius.circular(5), // มุมโค้ง
                ),
                padding: EdgeInsets.symmetric(horizontal: 10), // ระยะห่างข้างใน
                child: TextField(
                  maxLines: null, // ให้สามารถพิมพ์หลายบรรทัดได้
                  decoration: InputDecoration(
                    border: InputBorder.none, // ไม่มีเส้นขอบ
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // ระยะห่างระหว่างช่องเขียนบันทึกและปุ่ม
            Row(
              // ปุ่มบันทึกและยกเลิก
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // การทำงานเมื่อปุ่มถูกกด
                  },
                  child: Text('บันทึก'), // ข้อความบนปุ่ม
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // สีปุ่ม
                      foregroundColor: Colors.white, // สีอักษร
                      textStyle: TextStyle(fontSize: 18) // ขนาดอักษร
                      ),
                ),
                SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
                ElevatedButton(
                  onPressed: () {
                    // การทำงานเมื่อปุ่มถูกกด
                  },
                  child: Text('ยกเลิก'), // ข้อความบนปุ่ม
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // สีปุ่ม
                      foregroundColor: Colors.white, // สีอักษร
                      textStyle: TextStyle(fontSize: 18) // ขนาดอักษร
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}