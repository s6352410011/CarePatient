import 'package:care_patient/Calendar_Page/calendar.dart';
import 'package:care_patient/Caregiver_Page/data_patient_ui.dart';
import 'package:care_patient/Pages/historywork_ui.dart';
import 'package:care_patient/Pages/map_ui.dart';
import 'package:care_patient/Pages/review_ui.dart';
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomePatientUI extends StatefulWidget {
  const HomePatientUI({super.key});

  @override
  State<HomePatientUI> createState() => _HomePatientUIState();
}

class _HomePatientUIState extends State<HomePatientUI> {
  int _currentCarouselIndex = 0; // ตั้งค่าเริ่มต้นของ index ปัจจุบัน

  final List<String> labels = [
    'ปฏิทิน',
    'ประวัติการว่าจ้าง',
    'ข้อมูลผู้ดูแล',
    'แผนที่',
    'คะแนนรีวิว'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 30,
            ),
            buildCarouselSlider(),
            const SizedBox(height: 20.0),
            buildRowTabBar(context, ['กำลังดำเนินการ']),
            buildCardWithContact(context), // ทำ if else เพิ่มหน้ากำลังดำเนินการ
            buildCardWithNoHire(context),
            buildCardWithWait(context),
            const SizedBox(height: 20.0),
            buildRowWithNames(context, ['รายชื่อผู้ดูแล', 'รายชื่อทั้งหมด']),
            const SizedBox(height: 10.0),
            RegisterUsersList(),
          ],
        ),
      ),
    );
  }

  Widget buildCarouselSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: 150,
            enableInfiniteScroll: false,
            viewportFraction: 0.4,
            aspectRatio: 16 / 9,
            autoPlay: false,
            onPageChanged: (index, reason) {
              // อัปเดต index ปัจจุบันเมื่อมีการ slide
              setState(() {
                _currentCarouselIndex = index;
              });
            },
          ),
          itemCount: labels.length,
          itemBuilder: (BuildContext context, int index, int realIndex) {
            String label = labels[index];
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
                iconColor = Colors.amber;
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

            return GestureDetector(
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
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    Icon(iconData, color: iconColor, size: 100),
                    SizedBox(height: 5),
                    Text(label),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            labels.length,
            (index) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent.withOpacity(
                    index == _currentCarouselIndex ? 1 : 0.4,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
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
                        style: TextStyle(color: Colors.white), // กำหนดสีข้อความ
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
                        icon: Icon(Icons.chat, color: Colors.white), // ไอคอนแชท
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

Widget buildCardWithWait(BuildContext context) {
  //รอยืนยันการจ้าง ให้ขึ้นสถานะนี้
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
                  'มีการจ้างผู้ดูแล (รอยืนยันการจ้าง)',
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
            //final password = userData['password'];

            return GestureDetector(
              // หรือใช้ InkWell ก็ได้
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ReviewPage(), // นำทางไปยังหน้า ReviewPage
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
                  // subtitle: Text(
                  //   'Password: $password',
                  //   style: TextStyle(color: Colors.white),
                  // ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
