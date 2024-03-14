import 'package:care_patient/Calendar_Page/calendar.dart';
<<<<<<< HEAD
<<<<<<< HEAD
=======
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
>>>>>>> 188cc23b9a66c3add5d4964704ee47d95f826196
=======
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
>>>>>>> 188cc23b9a66c3add5d4964704ee47d95f826196
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
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    buildRow(context, ['ปฏิทิน', 'แผนที่']),
                    const SizedBox(height: 10.0),
                    buildRow(context, ['ประวัติการทำงาน', 'คะแนนรีวิว']),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              buildRowTabBar(context, ['กำลังดำเนินการ']),
              buildCardWithContact(
                  context), // ทำ if else เพิ่มหน้ากำลังดำเนินการ
              buildCardWithNoHire(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRow(BuildContext context, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels
          .map((label) {
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
              case 'ข้อมูลผู้ป่วย':
                iconData = Icons.person;
                iconColor = Colors.orange;
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
            return Expanded(
              child: Container(
                height: 60.0,
                child: ElevatedButton.icon(
                  onPressed: () {
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
                  icon: Icon(iconData, color: iconColor),
                  label: Text(label),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    // primary: AllColor.sc,
                  ),
                ),
              ),
            );
          })
          .expand((widget) => [
                widget,
              ])
          .toList(),
    );
  }

  Widget buildRowTabBar(BuildContext context, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        IconData iconData;
        Color iconColor;
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
                    fontSize: 20, // กำหนดขนาดตัวอักษร
                  ),
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
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
          child: Card(
            color: AllColor.sc, // สีพื้นหลังของการ์ด
            elevation: 20, // ระดับการยกขึ้นของการ์ด
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // ทำให้มีขอบโค้ง
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(
                    'ชื่อผู้ป่วย',
                    style: TextStyle(
                      fontSize: 20, // ขนาดตัวอักษร
                      color: Colors.white, // สีข้อความ
                      fontWeight: FontWeight.bold, // ตัวหนา
                    ),
                    textAlign: TextAlign.center, // จัดวางข้อความตรงกลาง
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText('อายุ ', '85' + 'ปี'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardWithNoHire(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0), // ระยะห่าง 10 จากขอบหน้าจอ
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
          child: Card(
            color: AllColor.sc, // สีพื้นหลังของการ์ด
            elevation: 20, // ระดับการยกขึ้นของการ์ด
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15), // ทำให้มีขอบโค้ง
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.album),
                  title: Text(
                    'ชื่อผู้ป่วย',
                    style: TextStyle(
                      fontSize: 20, // ขนาดตัวอักษร
                      color: Colors.white, // สีข้อความ
                      fontWeight: FontWeight.bold, // ตัวหนา
                    ),
                    textAlign: TextAlign.center, // จัดวางข้อความตรงกลาง
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildText('อายุ ', '85' + 'ปี'),
                    ],
                  ),
                ),
              ],
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
