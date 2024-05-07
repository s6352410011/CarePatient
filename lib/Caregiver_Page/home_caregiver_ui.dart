import 'dart:async';
import 'package:care_patient/Caregiver_Page/writedaily_ui.dart';
import 'package:care_patient/Pages/historywork_ui.dart';
import 'package:care_patient/Pages/review_ui.dart';
import 'package:care_patient/Patient_Page/CalendarPatient_Page/calendarPatient.dart';
import 'package:care_patient/ShowPage/page1.dart';
import 'package:care_patient/ShowPage/page2.dart';
import 'package:care_patient/ShowPage/page3.dart';
import 'package:care_patient/test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:care_patient/class/AuthenticationService.dart';

// สร้างหน้าจอหลักของผู้ป่วย
class HomeCaregiverUI extends StatefulWidget {
  const HomeCaregiverUI({Key? key}) : super(key: key);

  @override
  State<HomeCaregiverUI> createState() => _HomePatientUIState();
}

class _HomePatientUIState extends State<HomeCaregiverUI> {
  final PageController controller =
      PageController(viewportFraction: 0.8, keepPage: true);
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _startLoop();
  }

// เริ่มการเลื่อนหน้าอัตโนมัติ
  void _startLoop() {
    Timer.periodic(Duration(seconds: 10), (_) {
      if (_currentPage < 2) {
        //จำนวนเพจ
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
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

//เรียก widget มาแสดงโชว์หน้าหลัก
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.Backgroud_C,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15.0),
          AppBarWidget(),
          PageViewWidget(controller: controller),
          buildIconButtonRow(context),
          buildRowWithNames(context, ['รายชื่อผู้ดูแล', 'รายชื่อทั้งหมด']),
          UserDataWidget(),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

// //ดึงชื่อผู้ใช้จาก Firebase
// Future<String> getName() async {
//   String email = FirebaseAuth.instance.currentUser!.email!;
//   DocumentSnapshot userDoc =
//       await FirebaseFirestore.instance.collection('caregiver').doc(email).get();
//   return userDoc['name'];
// }

//AppBar ที่แสดงชื่อผู้ใช้
class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
    return AppBar(
      automaticallyImplyLeading: false, // กำหนดให้ไม่แสดงปุ่ม back
      title: FutureBuilder(
        future: _authenticationService.getName(),
        builder: (context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('สวัสดี');
          } else {
            if (snapshot.hasError) {
              return Text('สวัสดี');
            } else {
              return Text('สวัสดีคุณ ${snapshot.data}' + ' (❁´◡`❁)');
            }
          }
        },
      ),
    );
  }
}

// PageView ที่แสดงหน้าต่าง ๆ
class PageViewWidget extends StatelessWidget {
  final PageController controller;

  const PageViewWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageViewWithIndicator(
      controller: controller,
      pages: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPatientUI()),
            );
          },
          child: ShowPage1(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryWorkPage()),
            );
          },
          child: ShowPage2(),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReviewPage()),
            );
          },
          child: ShowPage3(),
        ),
      ],
      // กำหนดสีของ Dots
      colors: [
        AllColor.DotsPrimary,
        AllColor.DotsSecondary,
        AllColor.DotsThird,
        AllColor.DotsFour,
      ],
    );
  }
}

// Widget ที่แสดงข้อมูลของผู้ดูแลทั้งหมด
class UserDataWidget extends StatefulWidget {
  const UserDataWidget({Key? key}) : super(key: key);

  @override
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  late Future<List<String>> _userDataFuture;
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: _currentPage);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

// เริ่มการเลื่อนอัตโนมัติของหน้า UserDataWidget
  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 20), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

// ดึงข้อมูลของผู้ดูแลทั้งหมดจาก Firebase
  Future<List<String>> _loadUserData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('caregiver').get();
    List<String> names = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      if (data != null) {
        final name = (data as Map<String, dynamic>)['name'] as String?;
        if (name != null) {
          names.add(name);
        }
      }
    });
    return names;
  }

// เมื่อคลิกที่ Card ไปหน้าข้อมูลของผู้ดูแล
  void _onCardClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataCaregiverUI(),
      ),
    );
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
          child: PageView.builder(
            controller: _pageController,
            itemCount: names.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _onCardClicked,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    color: AllColor.Secondary_C,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.account_circle,
                          color: AllColor.IconPrimary),
                      title: Text(
                        names[index],
                        style: TextStyle(
                          color: AllColor.TextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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

// สร้างแถวของไอคอนและข้อความ
Widget buildRowWithNames(BuildContext context, List<String> labels) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: labels.map((label) {
      IconData iconData;
      Color iconColor;
      double iconSize; // เพิ่มตัวแปรเก็บขนาดของไอคอน

      if (label == 'รายชื่อผู้ดูแล') {
        iconData = Icons.recent_actors;
        iconColor = AllColor.IconSix;
        iconSize = 30.0; // กำหนดขนาดของไอคอน
      } else if (label == 'รายชื่อทั้งหมด') {
        iconData = Icons.list;
        iconColor = AllColor.IconSix;
        iconSize = 30.0; // กำหนดขนาดของไอคอน
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllCareGiverUI(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Icon(
              iconData,
              color: iconColor,
              size: iconSize, // กำหนดขนาดของไอคอน
            ),
          ),
        );
      } else {
        iconData = Icons.error;
        iconColor = Colors.grey;
        iconSize = 20.0; // กำหนดขนาดของไอคอน
      }

      return InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(
                iconData,
                color: iconColor,
                size: iconSize, // กำหนดขนาดของไอคอน
              ),
              SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: AllColor.TextSecondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      );
    }).toList(),
  );
}

// สร้าง PageView ที่มีตัวบ่งชี้เป็น Dots
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
          height: 5,
        ),
        Container(
          child: Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 100, //ความยาว dots
                  height: 12,
                  color: AllColor.Primary_C, // สี dots สถานะที่ 1
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
        const SizedBox(height: 20.0),
      ],
    );
  }
}

// ฟังก์ชัน helper สำหรับสร้างแถวของปุ่ม IconButton
Widget buildIconButtonRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: IconButtonRow(
      buttonDataList: [
        IconButtonData(
          iconData: Icons.calendar_month,
          label: 'ปฏิทิน',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPatientUI()),
            );
          },
        ),
        IconButtonData(
          iconData: Icons.history_edu,
          label: 'ประวัติการว่าจ้าง',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HistoryWorkPage()),
            );
          },
        ),
        IconButtonData(
          iconData: Icons.edit_note,
          label: 'จดบันทึก',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WriteDailyUI()),
            );
          },
        ),
      ],
    ),
  );
}

class IconButtonRow extends StatelessWidget {
  final List<IconButtonData> buttonDataList;

  const IconButtonRow({Key? key, required this.buttonDataList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: buttonDataList.map((buttonData) {
        return InkWell(
          onTap: buttonData.onPressed,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              // แก้จาก Row เป็น Column
              children: [
                Icon(
                  buttonData.iconData, color: AllColor.IconSix,
                  size: 35, // กำหนดขนาดของไอคอน
                ),
                SizedBox(height: 5), // เพิ่มระยะห่างระหว่าง icon และข้อความ
                Text(
                  buttonData.label,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class IconButtonData {
  final IconData iconData;
  final String label;
  final VoidCallback onPressed;

  const IconButtonData({
    required this.iconData,
    required this.label,
    required this.onPressed,
  });
}
