import 'package:care_patient/Pages/calendar.dart';
import 'package:care_patient/color.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/navbar/account_ui.dart';
import 'package:care_patient/navbar/caregiver_ui.dart';
import 'package:care_patient/navbar/messenger_ui.dart';
import 'package:care_patient/navbar/notifications_ui.dart';
import 'package:care_patient/navbar/progressive_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:care_patient/class/AuthenticationService.dart';

// class HomeCaregiverUI extends StatelessWidget {
//   const HomeCaregiverUI({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final AuthenticationService _authenticationService =
//         AuthenticationService();
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(50.0),
//           child: CustomAppBar(), // CustomAppBar ได้จากตัวอย่างต่อไปนี้
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ListView(
//             children: [
//               buildRow(context, ['ปฏิทิน', 'ประวัติการทำงาน']),
//               const SizedBox(height: 10.0),
//               buildRow(context, ['ข้อมูลผู้ป่วย', 'แผนที่ ', 'คะแนนรีวิว']),
//               const SizedBox(height: 10.0),
//               UserProfileWidget(),
//               ElevatedButton(
//                 onPressed: () async {
//                   _showSignOutDialog(context);
//                   await _authenticationService.signOut();
//                 },
//                 child: Text('Sign out'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget buildRow(BuildContext context, List<String> labels) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: labels.map((label) {
//         return Expanded(
//           child: Container(
//             height: 60.0,
//             child: ElevatedButton(
//               onPressed: () {
//                 // ตรวจสอบว่าปุ่มที่ถูกกดคือ "ปฏิทิน" หรือไม่
//                 if (label == 'ปฏิทิน') {
//                   // เปิดหน้าปฏิทิน
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const CalendarUI()),
//                   );
//                 } else {
//                   // ทำอะไรเมื่อปุ่มอื่น ๆ ถูกกด
//                   if (kDebugMode) {
//                     print('Pressed $label');
//                   }
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 textStyle: const TextStyle(fontSize: 16.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(label),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }

class HomeMainCareUI extends StatefulWidget {
  const HomeMainCareUI({Key? key}) : super(key: key);

  @override
  _HomeMainCareUIState createState() => _HomeMainCareUIState();
}

class _HomeMainCareUIState extends State<HomeMainCareUI> {
  int _selectedIndex = 2; // กำหนดค่าเริ่มต้นเป็น 2 เพื่อเลือกหน้า "Home"

  final List<Widget> _pages = [
    ProgressiveUI(),
    NotificationsUI(),
    HomeCaregiverUI(),
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




void _showSignOutDialog(BuildContext context) {
  final AuthenticationService _authenticationService = AuthenticationService();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Sign Out"),
        content: Text("Are you sure you want to sign out?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await _authenticationService.signOut();
              Navigator.pop(context);
              // Navigate to login screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginUI(),
                ),
              );
            },
            child: Text("Sign Out"),
          ),
        ],
      );
    },
  );
}

// class CustomAppBar extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: Text('HOME'),
//       actions: [
//         UserProfileWidget(), // แสดงข้อมูลผู้ใช้ที่เราสร้างไว้
//         // สามารถเพิ่ม actions อื่น ๆ ตามต้องการ
//       ],
//     );
//   }
// }

// UserProfileWidget(),
// ElevatedButton(
//   onPressed: () async {
//     _showSignOutDialog(context);
//     await _authenticationService.signOut();
//   },
//   child: Text('Sign out'),
// ),

// class UserProfileWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<User?>(
//       future: FirebaseAuth.instance.authStateChanges().first,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else if (!snapshot.hasData || snapshot.data == null) {
//           return Text('User not authenticated');
//         } else {
//           final User user = snapshot.data!;
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CircleAvatar(
//                 radius: 50,
//                 backgroundImage: NetworkImage(user.photoURL ?? ''),
//               ),
//               SizedBox(height: 20),
//               Text('Email: ${user.email}'),
//               // อื่น ๆ ที่คุณต้องการแสดง
//             ],
//           );
//         }
//       },
//     );
//   }
// }
