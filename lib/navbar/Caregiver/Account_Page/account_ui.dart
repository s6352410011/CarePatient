import 'dart:io';

import 'package:care_patient/Patient_Page/home_patient_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/navbar/Caregiver/Account_Page/account_setting_ui.dart';
import 'package:care_patient/navbar/Patient/Account_Page/account_setting_ui.dart';
import 'package:care_patient/Password_Page/reset_password.dart';
import 'package:care_patient/login_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountCaregiverUI extends StatefulWidget {
  const AccountCaregiverUI({Key? key}) : super(key: key);

  @override
  State<AccountCaregiverUI> createState() => _AccountCaregiverUIState();
}

final AuthenticationService _authenticationService = AuthenticationService();
final AuthenticationService _sharedPreferencesService = AuthenticationService();

class _AccountCaregiverUIState extends State<AccountCaregiverUI> {
  String? _selectedFile; // Define selected file variable
  String? _userProfileImageUrl;
  bool isActive = false;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันเมื่อ Widget ถูกสร้าง
    _selectedFile = null;
    checkActivationStatus();
    _getUserEmail();
    _fetchUserProfileImage();
  }

  // Define _pickImage method
  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.path!;
      });
    }
  }

  Future<void> _uploadImage(File file) async {
    String storagePath =
        'images/${FirebaseAuth.instance.currentUser!.email!.substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'))}_Patient.jpg';

    final Reference storageReference =
        FirebaseStorage.instance.ref().child(storagePath);

    try {
      await storageReference.putFile(file);
      String downloadURL = await storageReference.getDownloadURL();

      // Perform actions with downloadURL if needed
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> _fetchUserProfileImage() async {
    String? userProfileImage = await getUserProfileImage();
    if (userProfileImage != null) {
      setState(() {
        _userProfileImageUrl = userProfileImage;
      });
    }
  }

  Future<String?> getUserProfileImage() async {
    // ระบุ path ใน Firebase Storage ที่เก็บรูปโปรไฟล์
    String storagePath =
        'images/${FirebaseAuth.instance.currentUser!.email!.substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'))}_Patient.jpg';

    try {
      // อ้างอิง Firebase Storage instance
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);

      // ดึง URL ของรูปโปรไฟล์จาก Firebase Storage
      String downloadURL = await storageReference.getDownloadURL();

      return downloadURL;
    } catch (e) {
      print('เกิดข้อผิดพลาดในการดึงรูปโปรไฟล์: $e');
      return null;
    }
  }

  void checkActivationStatus() async {
    try {
      // Get current user email
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        // Query Firestore for document with matching email
        var querySnapshot = await FirebaseFirestore.instance
            .collection('caregiver')
            .where('email', isEqualTo: userEmail)
            .get();

        // Check if there is a document with the user's email
        if (querySnapshot.docs.isNotEmpty) {
          // Get the document data
          var userData = querySnapshot.docs[0].data();

          // Check the "Status" field in Firestore
          if (userData.containsKey('Status')) {
            // Get the value of "Status" field
            bool status = userData['Status'];

            // Update the local isActive state accordingly
            setState(() {
              isActive = status;
            });
          } else {
            print('No "Status" field found in Firestore document');
          }
        } else {
          print('No document found for the user email: $userEmail');
        }
      }
    } catch (e) {
      print('Error checking activation status: $e');
    }
  }

  void updateStatus(bool isActive) async {
    try {
      // Get current user email
      String? userEmail = FirebaseAuth.instance.currentUser?.email;
      if (userEmail != null) {
        // Query Firestore for document with matching email
        var querySnapshot = await FirebaseFirestore.instance
            .collection('caregiver')
            .where('email', isEqualTo: userEmail)
            .get();

        // Check if there is a document with the user's email
        if (querySnapshot.docs.isNotEmpty) {
          // Get the document ID
          String docId = querySnapshot.docs[0].id;

          // Update the "Status" field in Firestore
          await FirebaseFirestore.instance
              .collection('caregiver')
              .doc(docId)
              .set({'Status': isActive}, SetOptions(merge: true));

          print('Status updated successfully!');
        } else {
          print('No document found for the user email: $userEmail');
        }
      }
    } catch (e) {
      print('Error updating status: $e');
    }
  }

  Future<void> _getUserEmail() async {
    String? email = await _sharedPreferencesService.getEmail();
    setState(() {
      _userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                FutureBuilder(
                  future: Future.value(
                      _userProfileImageUrl), // ใช้ Future.value เพื่อให้ FutureBuilder รอค่าเดียวเท่านั้น
                  builder:
                      (BuildContext context, AsyncSnapshot<String?> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      if (snapshot.hasData && snapshot.data != null) {
                        return Padding(
                          padding: EdgeInsets.all(16),
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(snapshot.data!),
                          ),
                        );
                      } else {
                        return Icon(Icons.person, size: 150);
                      }
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Email: ${_userEmail ?? "Loading..."}',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isActive = !isActive;
                      updateStatus(isActive);
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AllColor.Backgroud_C,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: AllColor.DotsSecondary,
                        width: 1.0,
                      ),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.work,
                        color: Colors.brown,
                      ),
                      title: Text(
                        'Activation',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isActive ? AllColor.Secondary_C : AllColor.Third,
                        ),
                      ),
                      trailing: Switch(
                        value: isActive,
                        onChanged: (value) {
                          setState(() {
                            isActive = value;
                            updateStatus(isActive);
                          });
                        },
                        activeColor: AllColor
                            .Secondary_C, // กำหนดสีของ Switch เมื่อถูกเลือก
                        inactiveTrackColor: AllColor
                            .Third, // กำหนดสีของ Track เมื่อ Switch ไม่ได้ถูกเลือก
                        inactiveThumbColor: AllColor
                            .IconFive, // กำหนดสีของ Thumb เมื่อ Switch ไม่ได้ถูกเลือก
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: AllColor.Backgroud_C,
                    borderRadius: BorderRadius.circular(
                        20.0), // Adjust the radius as needed
                    border: Border.all(
                      color: AllColor.DotsSecondary, // Color of the border
                      width: 1.0, // Width of the border
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AccountSettingCaregiverUI(),
                        ),
                      );
                    },
                    leading: Icon(Icons.settings, color: AllColor.IconEight),
                    title: Text(
                      'Account Setting',
                      style: TextStyle(
                          fontSize: 20, color: AllColor.IconSecondary),
                    ),
                    trailing: Icon(Icons.arrow_forward,
                        color: AllColor.IconSecondary),
                  ),
                ),
              ],
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
                backgroundColor: AllColor.Secondary_C,
                fixedSize: Size(200, 50),
              ),
              child: Text('Reset Password',
                  style: TextStyle(color: AllColor.TextPrimary)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                _showSignOutDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AllColor.Third,
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

  void _showSignOutDialog(BuildContext context) {
    final AuthenticationService _authenticationService =
        AuthenticationService();
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
}
