import 'package:care_patient/navbar/Account_Page/account_setting_ui.dart';
import 'package:care_patient/Password_Page/reset_password.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountUI extends StatefulWidget {
  const AccountUI({Key? key}) : super(key: key);

  @override
  State<AccountUI> createState() => _AccountUIState();
}

final AuthenticationService _authenticationService = AuthenticationService();

class _AccountUIState extends State<AccountUI> {
  bool isActive = true;
  late User? _currentUser;

  @override
  void initState() {
    super.initState();
    // ดึงข้อมูลผู้ใช้ปัจจุบันทันทีเมื่อ State ถูกสร้าง
    _currentUser = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 30),
            UserProfileWidget(
                user: _currentUser), // ส่งข้อมูลผู้ใช้ไปยัง Widget
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                setState(() {
                  isActive = !isActive;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(75, 158, 158, 158),
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                  border: Border.all(
                    color: Colors.black, // Color of the border
                    width: 1.0, // Width of the border
                  ),
                ), // Set background color
                child: ListTile(
                  leading: Icon(
                    Icons.work,
                    color: Colors.brown,
                  ),
                  title: Text(
                    'Activetion',
                    style: TextStyle(
                      fontSize: 20,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                  ),
                  trailing: Switch(
                    value: isActive,
                    onChanged: (value) {
                      setState(() {
                        isActive = value;
                      });
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(75, 158, 158, 158),
                borderRadius:
                    BorderRadius.circular(10.0), // Adjust the radius as needed
                border: Border.all(
                  color: Colors.black, // Color of the border
                  width: 1.0, // Width of the border
                ),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AccountSettingUI(),
                    ),
                  );
                },
                leading: Icon(
                  Icons.settings,
                  color: Colors.blue,
                ),
                title: Text(
                  'Account Setting',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
                trailing: Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordUI()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: Size(200, 50),
              ),
              child:
                  Text('Reset Password', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _showSignOutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                fixedSize: Size(200, 50),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  SizedBox(width: 5),
                  Text('Logout', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  final User? user;

  const UserProfileWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user!.photoURL ?? ''),
              ),
              SizedBox(height: 20),
              Text('Email: ${user!.email}'),
              // อื่น ๆ ที่คุณต้องการแสดง
            ],
          )
        : CircularProgressIndicator();
  }
}

void _showSignOutDialog(BuildContext context) {
  final AuthenticationService _authenticationService = AuthenticationService();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Log Out"),
        content: Text("Are you sure you want to Log Out?"),
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
            child: Text("Log Out"),
          ),
        ],
      );
    },
  );
}
