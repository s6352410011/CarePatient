import 'package:care_patient/Pages/account_setting_ui.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/Pages/reset_password_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/color.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 30),
            // CircleAvatar(
            //   radius: 100,
            //   backgroundImage: AssetImage('assets/user_image.jpg'),
            // ),
            UserProfileWidget(),
            SizedBox(height: 30),
            // Text(
            //   'ชื่อผู้ใช้',
            //   style: TextStyle(
            //     fontSize: 30,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(height: 20),
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
                  MaterialPageRoute(builder: (context) => ResetPassword()),
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
                await _authenticationService.signOut();
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
            // ElevatedButton(
            //   onPressed: () {
            //     showDialog(
            //       context: context,
            //       builder: (BuildContext context) {
            //         return AlertDialog(
            //           title: Text('ต้องการออกจากระบบหรือไม่?'),
            //           actions: [
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.of(context).pop();
            //               },
            //               child: Text('Cancel'),
            //             ),
            //             TextButton(
            //               onPressed: () {
            //                 Navigator.pushReplacement(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => LoginUI(),
            //                   ),
            //                 );
            //               },
            //               child: Text('OK'),
            //             ),
            //           ],
            //         );
            //       },
            //     );
            //   },
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     fixedSize: Size(200, 50),
            //   ),
            //   child: Row(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       Icon(
            //         Icons.logout,
            //         color: Colors.white,
            //       ),
            //       SizedBox(width: 5),
            //       Text('Logout', style: TextStyle(color: Colors.white)),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class UserProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: FirebaseAuth.instance.authStateChanges().first,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Text('User not authenticated');
        } else {
          final User user = snapshot.data!;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL ?? ''),
              ),
              SizedBox(height: 20),
              Text('Email: ${user.email}'),
              // อื่น ๆ ที่คุณต้องการแสดง
            ],
          );
        }
      },
    );
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
