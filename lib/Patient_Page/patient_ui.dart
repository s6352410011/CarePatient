import 'package:care_patient/Calendar_Page/calendar.dart';
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
import 'package:care_patient/Pages/historywork_ui.dart';
import 'package:care_patient/Pages/map_ui.dart';
import 'package:care_patient/Pages/review_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// นำเข้าไลบรารีที่เกี่ยวข้อง

class HomePatientUI extends StatelessWidget {
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
              buildRow(context, ['ปฏิทิน', 'ประวัติการว่าจ้าง']),
              const SizedBox(height: 10.0),
              buildRow(context, ['ข้อมูลผู้ดูแล', 'แผนที่', 'คะแนนรีวิว']),
              const SizedBox(height: 20.0),
              buildRowWithNames(context, ['รายชื่อผู้ดูแล', 'รายชื่อทั้งหมด']),
              const SizedBox(height: 10.0),
              RegisterUsersList(),
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
              case 'ประวัติการว่าจ้าง':
                iconData = Icons.history;
                iconColor = Colors.green;
                break;
              case 'ข้อมูลผู้ดูแล':
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
                      case 'ประวัติการว่าจ้าง':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HistoryWorkPage(),
                          ),
                        );
                        break;
                      case 'ข้อมูลผู้ดูแล':
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
                SizedBox(
                  width: 0,
                )
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
          case 'รายชื่อผู้ดูแล':
            iconData = Icons.recent_actors;
            iconColor = AllColor.pr;
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
                      mainAxisAlignment: label == 'รายชื่อผู้ดูแล'
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
                    'ชื่อผู้ดูแล',
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
                      buildText('อายุ ', '25' + ' ปี'),
                      buildText('คุณสมบัติ ', 'ประสบการณ์ในการดูแลผู้สูงอายุ'),
                      buildText('ความเชี่ยวชาญ ', 'การดูแลสุขภาพ'),
                      buildText('สถานที่ที่ไปดูแลได้ ', 'บ้านของผู้ป่วย'),
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

class RegisterUsersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('registerusers').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final users = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(), // ทำให้ไม่สามารถเลื่อนได้
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final email = userData['email'];
            final password = userData['password'];

            return GestureDetector( // หรือใช้ InkWell ก็ได้
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReviewPage(), // นำทางไปยังหน้า ReviewPage
                  ),
                );
              },
              child: Card(
                color: AllColor.sc,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.account_circle, color: AllColor.sc),
                  title: Text(
                    'Email: $email',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Password: $password',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}