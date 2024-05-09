import 'dart:async';
import 'package:care_patient/Caregiver_Page/writedaily_ui.dart';
import 'package:care_patient/Pages/historywork_ui.dart';
import 'package:care_patient/Patient_Page/CalendarPatient_Page/calendarPatient.dart';
import 'package:care_patient/ShowPage/page1.dart';
import 'package:care_patient/ShowPage/page2.dart';
import 'package:care_patient/ShowPage/page4.dart';
import 'package:care_patient/Patient_Page/dataCaregiver_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// สร้างหน้าจอหลักของผู้ป่วย
class HomePatientUI extends StatefulWidget {
  const HomePatientUI({Key? key}) : super(key: key);

  @override
  State<HomePatientUI> createState() => _HomePatientUIState();
}

String currentUserEmail = 'example@example.com';

class _HomePatientUIState extends State<HomePatientUI> {
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
    Timer.periodic(Duration(seconds: 2), (_) {
      if (_currentPage < 2) {
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
      backgroundColor: AllColor.Backgroud,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //const SizedBox(height: 15.0),
          AppBarWidget(),
          PageViewWidget(controller: controller),
          buildIconButtonRow(context),
          buildRowWithNames(context, ['รายชื่อผู้ดูแล', 'รายชื่อทั้งหมด']),
          //const SizedBox(height: 15.0),
          UserDataWidget(),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
}

//ดึงชื่อผู้ใช้จาก Firebase
Future<String> getName() async {
  String email = FirebaseAuth.instance.currentUser!.email!;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('patient').doc(email).get();
  return userDoc['name'];
}

//AppBar ที่แสดงชื่อผู้ใช้
class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // กำหนดให้ไม่แสดงปุ่ม back
      title: FutureBuilder(
        future: getName(),
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
              MaterialPageRoute(builder: (context) => HistoryWorkPage()),
            );
          },
          child: ShowPage4(),
        ),
      ],
      // กำหนดสีของ Dots
      colors: [
        AllColor.DotsPrimary,
        AllColor.DotsSecondary,
        AllColor.DotsThird,
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
  // late final PageController _pageController;
  // int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
    // _pageController =
    //     PageController(viewportFraction: 0.8, initialPage: _currentPage);
    // _startAutoScroll();
  }

  @override
  void dispose() {
    // _pageController.dispose();
    super.dispose();
  }

// เริ่มการเลื่อนอัตโนมัติของหน้า UserDataWidget
  // void _startAutoScroll() {
  //   Timer.periodic(Duration(seconds: 20), (timer) {
  //     if (_currentPage < 3) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }
  //     if (mounted) {
  //       _pageController.animateToPage(
  //         _currentPage,
  //         duration: Duration(milliseconds: 2000),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

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
  void _onCardClicked(
      Map<String, dynamic> caregiverData, String currentUserEmail) {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => DataCaregiverUI(
    //       caregiverData: caregiverData,
    //       currentUserEmail: currentUserEmail, // ส่ง currentUserEmail ไปยัง DataCaregiverUI
    //     ),
    //   ),
    // );
  }

  Future<List<Map<String, dynamic>>> _loadUserDataWithImages() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('caregiver').get();
    List<Map<String, dynamic>> userDataWithImages = [];
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      if (data != null) {
        final name = (data as Map<String, dynamic>)['name'] as String?;
        final email = (data as Map<String, dynamic>)['email'] as String?;
        final relatedSkills =
            (data as Map<String, dynamic>)['relatedSkills'] as String?;
        final careExperience =
            (data as Map<String, dynamic>)['careExperience'] as String?;
        final rateMoney =
            (data as Map<String, dynamic>)['rateMoney'] as String?;
        final status = (data as Map<String, dynamic>)['Status'] as bool? ??
            false; // กำหนดค่าเริ่มต้นเป็น false

        if (status &&
            name != null &&
            email != null &&
            relatedSkills != null &&
            careExperience != null &&
            rateMoney != null) {
          String storagePath =
              'images/${email.substring(0, email.indexOf('@'))}_Patient.jpg';
          final imageUrl = await _getUserProfileImageUrl(storagePath);
          userDataWithImages.add({
            'name': name,
            'imageUrl': imageUrl,
            'relatedSkills': relatedSkills,
            'careExperience': careExperience,
            'rateMoney': rateMoney,
          });
        }
      }
    }
    return userDataWithImages;
  }

  Future<List<String>> _loadUserImages() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('caregiver').get();
    List<String> imageUrls = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      if (data != null) {
        final imageUrl = (data as Map<String, dynamic>)['imageUrl'] as String?;
        if (imageUrl != null) {
          imageUrls.add(imageUrl);
        }
      }
    });
    return imageUrls;
  }

  Future<String?> _getUserProfileImageUrl(String storagePath) async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);
      return await storageReference.getDownloadURL();
    } catch (e) {
      print('เกิดข้อผิดพลาดในการดึงรูปโปรไฟล์: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUserDataWithImages(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        }
        List<Map<String, dynamic>> userDataWithImages = snapshot.data!;
        return Expanded(
          child: PageView.builder(
            // controller: _pageController,
            itemCount: userDataWithImages.length,
            itemBuilder: (context, index) {
              final userData = userDataWithImages[index];
              return GestureDetector(
                onTap: () => _onCardClicked(userData, currentUserEmail),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    color: AllColor.Secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Stack(
                      children: [
                        // รูปภาพด้านบนซ้าย
                        Positioned(
                          top: 20,
                          left: 25,
                          child: Container(
                            padding: EdgeInsets.only(),
                            width: 70,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: userData['imageUrl'] != null
                                    ? NetworkImage(userData['imageUrl'])
                                    : AssetImage(
                                            'assets/default_profile_image.jpg')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ),
                        // ข้อมูล
                        Positioned(
                          left: 120, // ระยะห่างระหว่างข้อมูลและรูป
                          top: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${userData['name']}',
                                style: TextStyle(
                                  color: AllColor.TextPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Related Skills: ${userData['relatedSkills']}',
                                style: TextStyle(
                                  color: AllColor.TextPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Care Experience: ${userData['careExperience']}',
                                style: TextStyle(
                                  color: AllColor.TextPrimary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rate Money: ${userData['rateMoney']}',
                                style: TextStyle(
                                  color: AllColor.TextPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
        iconColor = AllColor.IconSeven;
        iconSize = 30.0; // กำหนดขนาดของไอคอน
      } else if (label == 'รายชื่อทั้งหมด') {
        iconData = Icons.list;
        iconColor = AllColor.IconSeven;
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
        //SizedBox(height: 5),
        SizedBox(
          height: 200,
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
                  color: AllColor.Primary, // สี dots สถานะที่ 1
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
        //const SizedBox(height: 20.0),
      ],
    );
  }
}

// ฟังก์ชัน helper สำหรับสร้างแถวของปุ่ม IconButton
Widget buildIconButtonRow(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 5, right: 20, left: 20, top: 10),
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
          iconData: Icons.article,
          label: 'อ่านบันทึก',
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
                  buttonData.iconData, color: AllColor.IconSeven,
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
