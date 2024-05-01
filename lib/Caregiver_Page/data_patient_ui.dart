import 'package:care_patient/Caregiver_Page/writedaily_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';

class DataPatientUI extends StatefulWidget {
  const DataPatientUI({Key? key});

  @override
  State<DataPatientUI> createState() => _DataPatientUIState();
}

//อักษร
class _DataPatientUIState extends State<DataPatientUI> {
  final TextStyle _textStyle = TextStyle(
    color: Colors.black, // สีอักษร
    fontSize: 16, // ขนาดอักษร
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ข้อมูลผู้ป่วย',
          style: TextStyle(color: Colors.white), // สีข้อความ
        ),
        centerTitle: true, // จัดข้อความตรงกลาง
        backgroundColor: AllColor.Primary, // สีพื้นหลังของ AppBar
        leading: IconButton(
          // ปุ่ม back
          icon: Icon(Icons.arrow_back, color: Colors.white), // ไอคอน back
          onPressed: () {
            Navigator.pop(context); // การกลับไปยังหน้าก่อนหน้านี้
          },
        ),
      ),
      body: SingleChildScrollView(
        // ใช้ SingleChildScrollView เพื่อให้สามารถเลื่อนได้หากข้อมูลมากเกินไป
        child: Padding(
          padding: const EdgeInsets.all(5.0), // ระยะห่างขอบ 5px
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // จัดวางเนื้อหาไปทางซ้าย
            children: [
              Center(
                // โชว์รูปผู้ป่วย อยู่ตรงกลางหน้าจอ
                child: Container(
                  width: 150, // ขนาดของรูป
                  height: 150, // ขนาดของรูป
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                          'path/to/your/image.jpg'), // เปลี่ยนเป็น path ของรูปภาพของผู้ป่วย
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // ระยะห่างระหว่างรูปและข้อมูล
              Center(
                // ชื่อผู้ป่วย : นาย พี อยู่ตรงกลางหน้าจอใต้รูปที่โชว์
                child: Text(
                  'ชื่อผู้ป่วย : นาย พี',
                  style: TextStyle(fontSize: 18), // ขนาดอักษร
                ),
              ),
              SizedBox(height: 20), // ระยะห่างระหว่างรูปและข้อมูล
              Padding(
                padding: const EdgeInsets.only(left: 10.0), // ระยะห่างจากซ้าย
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('อายุ :', style: _textStyle), // ข้อมูลอายุ
                    Text('เพศ :', style: _textStyle), // ข้อมูลเพศ
                    Text('เบอร์โทรศัพท์ :',
                        style: _textStyle), // ข้อมูลเบอร์โทรศัพท์
                    Text('โรคประจำตัว :',
                        style: _textStyle), // ข้อมูลโรคประจำตัว
                    Text('ความต้องการดูแลเป็นพิเศษ :',
                        style: _textStyle), // ข้อมูลความต้องการดูแลเป็นพิเศษ
                    Text('ข้อมูลยาที่ใช้ในปัจจุบัน :',
                        style: _textStyle), // ข้อมูลยาที่ใช้ในปัจจุบัน
                    Text('ข้อมูลการแพ้ยา :',
                        style: _textStyle), // ข้อมูลการแพ้ยา
                  ],
                ),
              ),
              SizedBox(height: 20), // ระยะห่างระหว่างข้อมูลและปุ่ม
              Row(
                // ปุ่มจดบันทึกประจำวัน + icon
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WriteDailyUI()), // เปลี่ยน WriteDaily() เป็นหน้าที่เราต้องการให้ไป
                      );
                    }, // การทำงานเมื่อปุ่มถูกกด
                    icon: Icon(Icons.edit_document), // ไอคอน icon
                    label: Text('จดบันทึกประจำวัน'), // ข้อความบนปุ่ม
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // สีของตัวอักษรบนปุ่ม
                      textStyle: TextStyle(fontSize: 18), // ขนาดอักษร
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10), // ระยะห่างระหว่างปุ่ม
              Row(
                // ปุ่มสำเร็จ และ ปุ่มยกเลิก
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {}, // การทำงานเมื่อปุ่มถูกกด
                    child: Text('สำเร็จ'), // ข้อความบนปุ่ม
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // สีของตัวอักษรบนปุ่ม
                      backgroundColor: Colors.blue, // สีพื้นหลัง
                      textStyle: TextStyle(fontSize: 18), // ขนาดอักษร
                    ),
                  ),
                  SizedBox(width: 10), // ระยะห่างระหว่างปุ่ม
                  ElevatedButton(
                    onPressed: () {}, // การทำงานเมื่อปุ่มถูกกด
                    child: Text('ยกเลิก'), // ข้อความบนปุ่ม
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, // สีของตัวอักษรบนปุ่ม
                      backgroundColor: Colors.red, // สีพื้นหลัง
                      textStyle: TextStyle(fontSize: 18), // ขนาดอักษร
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
