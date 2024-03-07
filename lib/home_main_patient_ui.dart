import 'package:care_patient/navbar/patient_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/color.dart';
import 'package:care_patient/navbar/account_ui.dart';
import 'package:care_patient/navbar/messenger_ui.dart';
import 'package:care_patient/navbar/notifications_ui.dart';
import 'package:care_patient/navbar/progressive_ui.dart';

class HomeMainPatientUI extends StatefulWidget {
  const HomeMainPatientUI({Key? key}) : super(key: key);

  @override
  _HomeMainPatientUIState createState() => _HomeMainPatientUIState();
}

class _HomeMainPatientUIState extends State<HomeMainPatientUI> {
  int _selectedIndex = 2; // กำหนดค่าเริ่มต้นเป็น 2 เพื่อเลือกหน้า "Home"

  final List<Widget> _pages = [
    ProgressiveUI(),
    NotificationsUI(),
    HomePatientUI(),
    MessengerUI(),
    AccountUI(),
  ];

  final List<String> _titles = [
    'Working',
    'Notifications',
    'Home',
    'Messages',
    'Account',
  ];

  Color _backgroundColor = AllColor.pr;
  Color _textColor = Colors.white;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            icon: Icon(Icons.business_center),
            label: 'Working',
          ),
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
    );
  }
}
