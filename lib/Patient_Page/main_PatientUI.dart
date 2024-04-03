import 'package:care_patient/Patient_Page/home_patient_ui.dart';
import 'package:care_patient/chat/%E0%B8%B5user_tile.dart';
import 'package:care_patient/chat/chat_home.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/navbar/Account_Page/account_ui.dart';
import 'package:care_patient/navbar/messenger_ui.dart';
import 'package:care_patient/navbar/notifications_ui.dart';
import 'package:care_patient/Progressive_Page/progressive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeMainPatientUI extends StatefulWidget {
  const HomeMainPatientUI({Key? key}) : super(key: key);

  @override
  _HomeMainPatientUIState createState() => _HomeMainPatientUIState();
}

class _HomeMainPatientUIState extends State<HomeMainPatientUI> {
  int _selectedIndex = 1; // กำหนดค่าเริ่มต้นเป็น 1 เพื่อเลือกหน้า "Home"

  final List<Widget> _pages = [
    NotificationsUI(),
    HomePatientUI(),
    ChatHome(),
    AccountUI(),
  ];

  final List<String> _titles = ['Notifications', 'Home', 'Messages', 'Account'];

  Color _backgroundColor = AllColor.pr;
  Color _textColor = Colors.white;

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
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUI()),
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
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: AllColor.sc,
          unselectedItemColor: Colors.white,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
