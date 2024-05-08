// ignore_for_file: deprecated_member_use

import 'package:care_patient/chat/chat_home.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/navbar/Patient/Account_Page/account_ui.dart';
import 'package:care_patient/Caregiver_Page/home_caregiver_ui.dart';
import 'package:care_patient/navbar/Caregiver/notifications_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMainCareUI extends StatefulWidget {
  const HomeMainCareUI({Key? key}) : super(key: key);

  @override
  _HomeMainCareUIState createState() => _HomeMainCareUIState();
}

class _HomeMainCareUIState extends State<HomeMainCareUI> {
  int _selectedIndex = 0; // กำหนดค่าเริ่มต้นเป็น 1 เพื่อเลือกหน้า "Home"

  final List<Widget> _pages = [
    HomeCaregiverUI(),
    NotificationsUI_C(),
    ChatHome(),
    AccountUI(),
  ];
  final List<String> _titles = ['Home', 'Notifications', 'Messages', 'Account'];

  Color _backgroundColor = AllColor.Primary_C;
  Color _textColor = AllColor.TextPrimary;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> clearUserData() async {
    UserData.email = null;
    UserData.username = null;
    UserData.uid = null;
    UserData.imageUrl = null;
  }

  final AuthenticationService _authenticationService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ทำงานที่ต้องการเมื่อผู้ใช้กดปุ่มย้อนกลับ
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("ยืนยัน"),
              content: Text("คุณต้องการออกจากระบบหรือไม่?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // ปิดหน้าต่างยืนยัน
                  },
                  child: Text("ยกเลิก"),
                ),
                TextButton(
                  onPressed: () async {
                    // ทำการเคลียร์ข้อมูลใน UserData และล้าง SharedPreferences ตามต้องการ
                    clearUserData();
                    await _authenticationService.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    // โหลดหน้า LoginUI ใหม่
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUI()),
                      (route) =>
                          false, // predicate ที่ให้เป็นเท็จเพื่อลบทุกหน้าใน stack,
                    );
                  },
                  child: Text("ออกจากระบบ"),
                ),
              ],
            );
          },
        );

        return false; // ไม่อนุญาตให้กดปุ่มย้อนกลับได้โดยตรง
      },
      child: Scaffold(
        //backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // กำหนดให้ไม่แสดงปุ่ม back
          backgroundColor: _backgroundColor,
          title: Text(
            _titles[_selectedIndex],
            style: TextStyle(
              color: _textColor,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AllColor
                .Primary_C, // สีพื้นหลังของ Bottom Navigation Bar เป็นสีขาว
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black
                    .withOpacity(.1), // สีของเงาที่ปรากฏเมื่อมีการเลื่อน
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: GNav(
                rippleColor:
                    Colors.grey[300]!, // สีของเส้นสัมผัสเมื่อแตะที่แท็บ
                hoverColor: AllColor.Secondary_C!, // สีพื้นหลังเมื่อชี้ที่แท็บ
                gap: 8, // ระยะห่างระหว่างแท็บ
                activeColor:
                    Colors.white, // สีของ icon และข้อความเมื่อเลือกแท็บ
                iconSize: 24, // ขนาดของ icon
                padding: EdgeInsets.symmetric(
                    horizontal: 20, vertical: 12), // การขยายขนาดแท็บ
                duration: Duration(
                    milliseconds:
                        400), // ระยะเวลาในการแสดงเอฟเฟกต์ขณะเปลี่ยนแท็บ
                tabBackgroundColor: AllColor.Secondary_C, // สีพื้นหลังแท็บ
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  GButton(
                    icon: LineIcons.bell,
                    text: 'Notifications',
                  ),
                  GButton(
                    icon: LineIcons.facebookMessenger,
                    text: 'Messages',
                  ),
                  GButton(
                    icon: LineIcons.user,
                    text: 'Account',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
