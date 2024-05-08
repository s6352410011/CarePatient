import 'dart:io';

import 'package:care_patient/class/color.dart';
import 'package:care_patient/login_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountSettingUI extends StatefulWidget {
  const AccountSettingUI({Key? key}) : super(key: key);

  @override
  State<AccountSettingUI> createState() => _AccountSettingUIState();
}

class _AccountSettingUIState extends State<AccountSettingUI> {
  String? _name = '';
  String? _address = '';
  String? _phoneNumber = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedFile; // Define selected file variable
  String? _userProfileImageUrl;
  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันเมื่อ Widget ถูกสร้าง
    _loadUserData();
    _selectedFile = null;
    _fetchUserProfileImage();
  }

  Future<void> _loadUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // โหลดข้อมูลผู้ใช้จาก Firestore และกำหนดค่าให้กับตัวแปร state
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        setState(() {
          _name = userData['name'];
          _phoneNumber = userData['phoneNumber'];
          _address = userData['address'];
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  void _updateUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // อัปเดตข้อมูลใน Firestore
        await FirebaseFirestore.instance
            .collection('caregiver')
            .doc(user.email) // ใช้ email เป็น Document ID
            .update({
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
        });
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email) // ใช้ email เป็น Document ID
            .update({
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'address': _addressController.text,
        });

        // แสดงข้อความแจ้งเตือนเมื่ออัปเดตข้อมูลสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data updated successfully')),
        );
      } catch (e) {
        print('Error updating data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating data')),
        );
      }
    }
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
      setState(() {
        _userProfileImageUrl = downloadURL;
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllColor.Primary,
        title: const Text('Account Setting'),
      ),
      body: ListView(
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
              GestureDetector(
                onTap: () async {
                  await _pickImage();
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      'Change Profile Picture',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'ชื่อ-นามสกุล',
                  hintText: 'กรุณาใส่ชื่อและนามสกุล',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  hintText: 'กรุณาใส่เบอร์โทรศัพท์',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: 'ที่อยู่',
                  hintText: 'กรุณาใส่ที่อยู่',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType: TextInputType.streetAddress,
              ),
            ],
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              final User? user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                // Check if user signed in with Google
                bool isGoogleSignIn = user.providerData
                    .any((provider) => provider.providerId == 'google.com');
                if (isGoogleSignIn) {
                  // Show pop-up for successful update
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Update Successful'),
                        content: Text('Your data has been updated.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              _updateUserData();
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  // Show pop-up to confirm identity with password
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Identity'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Please enter your password to confirm your identity.'),
                            TextFormField(
                              obscureText: true,
                              // Add controller and decoration as needed
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                // Verify password and update data if successful
                                final String password =
                                    _passwordController.text;
                                // Add your logic to verify password
                                // For example, you can use FirebaseAuth signInWithEmailAndPassword
                                // to sign in with email and password
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: user.email!,
                                  password: password,
                                );
                                // If sign in successful, update user data
                                _updateUserData();
                                // Close dialog
                                Navigator.of(context).pop();
                              } catch (e) {
                                print('Error verifying password: $e');
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Error verifying password')),
                                );
                              }
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              fixedSize: Size(200, 50),
            ),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              // เรียกใช้งานเมธอดสำหรับลบบัญชีผู้ใช้
              deleteUserAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              fixedSize: Size(200, 50),
            ),
            child:
                Text('Delete Account', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void deleteUserAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete Account'),
          content: Text('Are you sure you want to delete your account?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // ลบบัญชีผู้ใช้
                    await user.delete();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Account deleted successfully')),
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUI()),
                    );
                  }
                } catch (e) {
                  print('Error deleting user account: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting user account')),
                  );
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
