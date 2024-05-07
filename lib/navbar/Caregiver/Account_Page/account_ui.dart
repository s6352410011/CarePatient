import 'dart:io';

import 'package:care_patient/navbar/Patient/Account_Page/account_setting_ui.dart';
import 'package:care_patient/Password_Page/reset_password.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart'; // Import for Firebase Storage

class AccountUI extends StatefulWidget {
  const AccountUI({Key? key}) : super(key: key);

  @override
  State<AccountUI> createState() => _AccountUIState();
}

final AuthenticationService _authenticationService = AuthenticationService();

class _AccountUIState extends State<AccountUI> {
  bool isActive = true;
  String userImageUrl = ''; // Variable to store user image URL

  @override
  void initState() {
    super.initState();
    _getUserImageUrl(); // Fetch user image URL on initialization
  }

  Future<void> _getUserImageUrl() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final storage = FirebaseStorage.instance;
        final reference = storage.ref().child('user_images/${user.uid}');
        final url = await reference.getDownloadURL();
        setState(() {
          userImageUrl = url;
        });
      }
    } catch (error) {
      print(error.toString()); // Handle potential errors
    }
  }

  // ... rest of your code (with minor adjustments)

  @override
  Widget build(BuildContext context) {
    // ... your existing build method

    return Scaffold(
      body: Center(
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: 30),
            userImageUrl.isNotEmpty
                ? CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userImageUrl),
                  )
                : Text('No profile picture'), // Display placeholder if no image
            SizedBox(height: 30),
            // ... rest of your list items

            // Add a button to change user image
            ElevatedButton(
              onPressed: () => _changeUserImage(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                fixedSize: Size(200, 50),
              ),
              child: Text(
                'Change Profile Picture',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      // ... rest of your code
    );
  }

  void _changeUserImage(BuildContext context) async {
    // Use ImagePicker to select image
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);

      // Upload image to Firebase Storage
      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final storage = FirebaseStorage.instance;
          final filename =
              '${user.uid}-${DateTime.now().millisecondsSinceEpoch}.jpg';
          final newImageRef = storage.ref().child('user_images/$filename');
          await newImageRef.putFile(imageFile);

          // Update userImageUrl and potentially user data if needed
          setState(() async {
            userImageUrl = await newImageRef.getDownloadURL();
          });
        }
      } catch (error) {
        print(error.toString()); // Handle potential upload errors
      }
    }
  }
}
