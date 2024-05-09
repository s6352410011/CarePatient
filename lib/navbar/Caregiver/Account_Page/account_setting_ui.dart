import 'dart:io';

import 'package:care_patient/Caregiver_Page/home_caregiver_ui.dart';
import 'package:care_patient/Caregiver_Page/main_caregiverUI.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/navbar/Patient/Account_Page/account_ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountSettingCaregiverUI extends StatefulWidget {
  const AccountSettingCaregiverUI({Key? key}) : super(key: key);

  @override
  State<AccountSettingCaregiverUI> createState() =>
      _AccountSettingCaregiverUIState();
}

class _AccountSettingCaregiverUIState extends State<AccountSettingCaregiverUI> {
  String? _name = '';
  String? _address = '';
  String? _phoneNumber = '';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedFile;
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
        Map<String, dynamic> updatedData = {};

        // Check if name is updated
        if (_name != _nameController.text) {
          updatedData['name'] = _nameController.text;
        }

        // Check if phone number is updated
        if (_phoneNumber != _phoneController.text) {
          updatedData['phoneNumber'] = _phoneController.text;
        }

        // Check if address is updated
        if (_address != _addressController.text) {
          updatedData['address'] = _addressController.text;
        }

        // Only update Firestore if there's any change
        if (updatedData.isNotEmpty) {
          // อัปเดตข้อมูลใน Firestore
          await FirebaseFirestore.instance
              .collection('patient')
              .doc(user.email) // ใช้ email เป็น Document ID
              .update(updatedData);
          // await FirebaseFirestore.instance
          //     .collection('users')
          //     .doc(user.email) // ใช้ email เป็น Document ID
          //     .update(updatedData);
        }

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
    // Call _updateUserProfileImage() to update profile image immediately after upload
    _updateUserProfileImage();
  }

  Future<String?> getUserProfileImage() async {
    String storagePath =
        'images/${FirebaseAuth.instance.currentUser!.email!.substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'))}_Patient.jpg';

    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child(storagePath);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error fetching user profile image: $e');
      return null;
    }
  }

  Future<void> _updateUserProfileImage() async {
    try {
      if (_selectedFile != null) {
        File file = File(_selectedFile!);
        await _uploadImage(file);
        setState(() {
          _fetchUserProfileImage();
        });
      }
    } catch (e) {
      print('Error updating profile image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllColor.Primary_C,
        title: const Text(
          'Account Setting',
          style: TextStyle(color: AllColor.TextPrimary),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeMainCareUI()),
              ModalRoute.withName('/'),
            );
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await _pickImage();
                  if (_selectedFile != null) {
                    await _updateUserProfileImage();
                  }
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 2),
                      ),
                      child: _userProfileImageUrl != null
                          ? CircleAvatar(
                              radius: 70,
                              backgroundImage:
                                  NetworkImage(_userProfileImageUrl!),
                            )
                          : Icon(Icons.person, size: 150),
                    ),
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black54,
                      ),
                      child: Icon(Icons.edit, color: AllColor.TextPrimary),
                    ),
                  ],
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
                bool isGoogleSignIn = user.providerData
                    .any((provider) => provider.providerId == 'google.com');
                if (isGoogleSignIn) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Update Successful'),
                        content: Text('Your data has been updated.'),
                        actions: [
                          TextButton(
                            onPressed: () async {
                              _updateUserData();
                              // Refresh the profile image
                              await _fetchUserProfileImage();
                              setState(() {}); // Refresh UI
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
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
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              try {
                                final String password =
                                    _passwordController.text;
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                  email: user.email!,
                                  password: password,
                                );
                                _updateUserData();
                                // Close dialog
                                Navigator.of(context).pop();
                              } catch (e) {
                                print('Error verifying password: $e');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error verifying password'),
                                  ),
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
              backgroundColor: AllColor.Secondary_C,
              fixedSize: Size(200, 50),
            ),
            child: Text(
              'Save',
              style: TextStyle(color: AllColor.TextPrimary),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              deleteUserAccount();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AllColor.Third,
              fixedSize: Size(200, 50),
            ),
            child: Text('Delete Account',
                style: TextStyle(color: AllColor.TextPrimary)),
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
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
