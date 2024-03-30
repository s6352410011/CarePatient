import 'package:care_patient/Calendar_Page/calendar.dart';
import 'package:care_patient/Caregiver_Page/data_patient_ui.dart';
import 'package:care_patient/Pages/historywork_ui.dart';
import 'package:care_patient/Pages/map_ui.dart';
import 'package:care_patient/Pages/review_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/color.dart'; // นำเข้าไลบรารีที่เกี่ยวข้อง

class HomeCaregiverUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  buildRow(context,
                      ['ปฏิทิน', 'แผนที่', 'ประวัติการทำงาน', 'คะแนนรีวิว']),
                  //SizedBox(height: 20), // เพิ่มระยะห่างระหว่างแถว
                  //buildRow(context, ['ประวัติการทำงาน', 'คะแนนรีวิว']),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            buildRowTabBar(context, ['กำลังดำเนินการ']),
            buildCardWithContact(context), // ทำ if else เพิ่มหน้ากำลังดำเนินการ
            buildCardWithNoHire(context),
          ],
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, List<String> labels) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: labels.map((label) {
          IconData iconData;
          Color iconColor;

          switch (label) {
            case 'ปฏิทิน':
              iconData = Icons.calendar_today;
              iconColor = Colors.blue;
              break;
            case 'ประวัติการทำงาน':
              iconData = Icons.history;
              iconColor = Colors.green;
              break;
            case 'แผนที่':
              iconData = Icons.map;
              iconColor = Colors.red;
              break;
            case 'คะแนนรีวิว':
              iconData = Icons.star;
              iconColor = Colors.yellow;
              break;
            default:
              iconData = Icons.error;
              iconColor = Colors.grey;
              break;
          }
          return Container(
            margin: EdgeInsets.symmetric(
                horizontal: 15), // เพิ่มระยะห่างระหว่าง Icon
            child: InkWell(
              onTap: () {
                switch (label) {
                  case 'ปฏิทิน':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CalendarUI(),
                      ),
                    );
                    break;
                  case 'ประวัติการทำงาน':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HistoryWorkPage(),
                      ),
                    );

                    break;
                  case 'แผนที่':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MapPage(),
                      ),
                    );
                    break;
                  case 'คะแนนรีวิว':
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewPage(),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              },
              child: Column(
                children: [
                  Icon(iconData, color: iconColor, size: 50), // Icon ใหญ่
                  SizedBox(height: 5), // เพิ่มระยะห่างระหว่าง Icon กับชื่อ
                  Text(label), // ชื่อใต้ Icon
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildRowTabBar(BuildContext context, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AllColor.pr,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // ย้ายข้อความอยู่ตรงกลาง
              children: [
                SizedBox(width: 5),
                Text(
                  'กำลังดำเนินการ', // เปลี่ยนข้อความเป็น "กำลังดำเนินการ"
                  style: TextStyle(
                      color: Colors.white, // กำหนดสีข้อความ
                      fontSize: 25, // กำหนดขนาดตัวอักษร
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCardWithContact(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0), // ระยะห่าง 10 จากขอบหน้าจอ
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataPatientUI()),
            );
          },
          child: SizedBox(
            height: 80, // กำหนดความสูงของการ์ดเป็น 80
            child: Card(
              color: AllColor.sc, // สีพื้นหลังของการ์ด
              elevation: 20, // ระดับการยกขึ้นของการ์ด
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // ทำให้มีขอบโค้ง
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20), // กำหนดระยะห่างด้านข้าง
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // จัดวางชิดขอบ
                  children: [
                    Text(
                      'ชื่อผู้ป่วย',
                      style: TextStyle(
                        fontSize: 18, // ขนาดตัวอักษร
                        color: Colors.white, // สีข้อความ
                        fontWeight: FontWeight.bold, // ตัวหนา
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone,
                              color: Colors.white), // ไอคอนโทรศัพท์
                          onPressed: () {
                            // ใส่โค้ดเมื่อกดไอคอนโทรศัพท์
                          },
                        ),
                        SizedBox(width: 10), // ระยะห่างระหว่างไอคอน
                        IconButton(
                          icon:
                              Icon(Icons.chat, color: Colors.white), // ไอคอนแชท
                          onPressed: () {
                            // ใส่โค้ดเมื่อกดไอคอนแชท
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardWithNoHire(BuildContext context) {
    //ไม่ได้ จ้างใคร เลยให้ขึ้นสถานะนี้
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0), // ระยะห่าง 10 จากขอบหน้าจอ
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataPatientUI()),
            );
          },
          child: SizedBox(
            height: 80, // กำหนดความสูงของการ์ดเป็น 80
            child: Card(
              color: AllColor.sc, // สีพื้นหลังของการ์ด
              elevation: 20, // ระดับการยกขึ้นของการ์ด
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // ทำให้มีขอบโค้ง
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0), // ระยะห่าง 10 จากขอบหน้าจอ
                child: Center(
                  child: Text(
                    'ยังไม่มีการว่าจ้างในขณะนี้ <(＿　＿)>',
                    style: TextStyle(
                      fontSize: 18, // ขนาดตัวอักษร
                      color: Colors.white, // สีข้อความ
                      fontWeight: FontWeight.bold, // ตัวหนา
                    ),
                    //textAlign: TextAlign.center, // จัดวางข้อความตรงกลาง
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText(String labelText, String valueText) {
    return Text(
      '$labelText: $valueText',
      style: TextStyle(
        fontSize: 14, // ขนาดตัวอักษร
        color: Colors.white, // สีข้อความ
        //fontWeight: FontWeight.bold, // ตัวหนา
      ),
    );
  }
}
