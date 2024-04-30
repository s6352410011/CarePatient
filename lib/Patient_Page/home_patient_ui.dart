import 'package:care_patient/Caregiver_Page/data_patient_ui.dart';
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
import 'package:care_patient/class/database.dart';
import 'package:care_patient/test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care_patient/Patient_Page/ShowPage/page1.dart';
import 'package:care_patient/Patient_Page/ShowPage/page2.dart';
import 'package:care_patient/Patient_Page/ShowPage/page3.dart';
import 'package:care_patient/class/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePatientUI extends StatefulWidget {
  const HomePatientUI({super.key});

  @override
  State<HomePatientUI> createState() => _HomePatientUIState();
}

class _HomePatientUIState extends State<HomePatientUI> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startLoop();
  }

  void _startLoop() {
    Future.delayed(Duration(seconds: 5), () {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        controller.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        _startLoop();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ShowPage1(),
      ShowPage2(),
      ShowPage3(),
    ];

    final colors = <Color>[
      AllColor.DotsPrimary,
      AllColor.DotsSecondary,
      AllColor.DotsThird,
    ];

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: PageViewWithIndicator(
              controller: controller,
              pages: pages,
              colors: colors,
            ),
          ),
          buildRowTabBar(context, ['กำลังดำเนินการ']),
          buildCardWithNoHire(context),
          const SizedBox(height: 5),
          buildRowWithNames(context, ['รายชื่อผู้ดูแล', 'รายชื่อทั้งหมด']),
          const SizedBox(height: 10.0),
          UserDataWidget(),
        ],
      ),
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
                        builder: (context) => AllCareGiverUI(),
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

class UserDataWidget extends StatefulWidget {
  @override
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  late Future<List<String>> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
  }

  Future<List<String>> _loadUserData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('general').get();
    List<String> names = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      if (data != null) {
        final name = (data as Map<String, dynamic>)['Name'] as String?;
        if (name != null) {
          names.add(name);
        }
      }
    });
    return names;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userDataFuture,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        }
        List<String> names = snapshot.data!;
        return Expanded(
          child: ListView.builder(
            itemCount: names.length,
            itemBuilder: (context, index) {
              return Card(
                color: AllColor.sc,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: Icon(Icons.account_circle, color: AllColor.sc),
                  title: Text(
                    names[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Show Page 3 Page
class PageViewWithIndicator extends StatelessWidget {
  final PageController controller;
  final List<Widget> pages;
  final List<Color> colors;

  const PageViewWithIndicator({
    Key? key,
    required this.controller,
    required this.pages,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: controller,
            itemCount: pages.length,
            itemBuilder: (_, index) {
              return pages[index % pages.length];
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 100,
                  height: 12,
                  color: colors[0], // สี dots สถานะที่ 1
                  rotationAngle: 180,
                  verticalOffset: -10,
                  borderRadius: BorderRadius.circular(24),
                ),
                dotDecoration: DotDecoration(
                  width: 24,
                  height: 12,
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                  verticalOffset: 0,
                ),
                spacing: 10.0, // ระยะห่างระหว่าง dots
                inActiveColorOverride: (i) =>
                    colors[i], // เลือกสี dots ในสถานะที่ไม่ได้ active
              ),
            ),
          ),
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }
}
