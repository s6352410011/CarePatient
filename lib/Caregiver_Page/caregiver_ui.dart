import 'package:care_patient/Pages/calendar.dart';
import 'package:care_patient/Pages/data_patient_ui.dart';
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
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 10,
              ),
              buildRow(context, ['ปฏิทิน', 'ประวัติการทำงาน']),
              const SizedBox(height: 10.0),
              buildRow(context, ['ข้อมูลผู้ป่วย', 'แผนที่', 'คะแนนรีวิว']),
              const SizedBox(height: 20.0),
              buildRowWithNames(context, ['รายชื่อผู้ป่วย', 'รายชื่อทั้งหมด']),
              buildRowWithCard(context),
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
                      case 'ข้อมูลผู้ป่วย':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PatientPage(),
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

  Widget buildRowWithNames(BuildContext context, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels.map((label) {
        IconData iconData;
        Color iconColor;

        switch (label) {
          case 'รายชื่อผู้ป่วย':
            iconData = Icons.recent_actors;
            iconColor = AllColor.sc;
            break;
          case 'รายชื่อทั้งหมด':
            iconData = Icons.list;
            iconColor = AllColor.sc;
            break;
          default:
            iconData = Icons.error;
            iconColor = Colors.grey;
            break;
        }

        return Expanded(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  switch (label) {
                    case 'รายชื่อทั้งหมด':
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewPage(),
                        ),
                      );
                      break;
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AllColor.pr,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: label == 'รายชื่อผู้ป่วย'
                          ? MainAxisAlignment.start
                          : MainAxisAlignment.end,
                      children: [
                        Icon(iconData, color: iconColor),
                        SizedBox(width: 5),
                        Text(
                          label,
                          style:
                              TextStyle(color: Colors.white), // กำหนดสีข้อความ
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget buildRowWithCard(BuildContext context) {
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
                      buildText('โรคประจำตัว ', 'Alzheimer'),
                      buildText('ความต้องการในการดูแล ', 'การดูแลสุขภาพ'),
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
