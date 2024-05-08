// import 'dart:io';

// import 'package:care_patient/navbar/Patient/Account_Page/account_setting_ui.dart';
// import 'package:care_patient/Password_Page/reset_password.dart';
// import 'package:care_patient/login_ui.dart';
// import 'package:flutter/material.dart';
// import 'package:care_patient/class/AuthenticationService.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';

// import 'package:file_picker/file_picker.dart';

// class AccountUI extends StatefulWidget {
//   const AccountUI({Key? key}) : super(key: key);

//   @override
//   State<AccountUI> createState() => _AccountUIState();
// }
// final AuthenticationService _authenticationService = AuthenticationService();

// class _AccountUIState extends State<AccountUI> {
//   bool isActive = true;
//   String? _selectedFile; // Define selected file variable
//   String? _userProfileImageUrl;
//   @override
//   void initState() {
//     super.initState();
//     // ดึงข้อมูลผู้ใช้ปัจจุบันทันทีเมื่อ State ถูกสร้าง
//     _selectedFile = null;
//   }

//   // Define _pickImage method
//   Future<void> _pickImage() async {
//     FilePickerResult? result = await FilePicker.platform.pickFiles(
//       type: FileType.image,
//     );

//     if (result != null) {
//       setState(() {
//         _selectedFile = result.files.single.path!;
//       });
//     }
//   }

//   Future<void> _uploadImage(File file) async {
//     String storagePath =
//         'images/${FirebaseAuth.instance.currentUser!.email!.substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'))}_Patient.jpg';

//     final Reference storageReference =
//         FirebaseStorage.instance.ref().child(storagePath);

//     try {
//       await storageReference.putFile(file);
//       String downloadURL = await storageReference.getDownloadURL();

//       // Perform actions with downloadURL if needed
//     } catch (e) {
//       print('Error uploading image: $e');
//     }
//   }

//   Future<void> _fetchUserProfileImage() async {
//     String? userProfileImage = await getUserProfileImage();
//     if (userProfileImage != null) {
//       setState(() {
//         _userProfileImageUrl = userProfileImage;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: ListView(
//           padding: EdgeInsets.all(16),
//           children: [
//             SizedBox(height: 30),
//             FutureBuilder(
//               future: Future.value(
//                   _userProfileImageUrl), // ใช้ Future.value เพื่อให้ FutureBuilder รอค่าเดียวเท่านั้น
//               builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return CircularProgressIndicator();
//                 } else {
//                   if (snapshot.hasData && snapshot.data != null) {
//                     return Padding(
//                       padding: EdgeInsets.all(16),
//                       child: CircleAvatar(
//                         radius: 70,
//                         backgroundImage: NetworkImage(snapshot.data!),
//                       ),
//                     );
//                   } else {
//                     return Icon(Icons.person, size: 150);
//                   }
//                 }
//               },
//             ),
//             GestureDetector(
//               onTap: () async {
//                 await _pickImage();
//                 if (_selectedFile != null) {
//                   await _uploadImage(File(_selectedFile!));
//                   setState(() {});
//                 }
//               },
//               child: Container(
//                 width: double.infinity,
//                 padding: EdgeInsets.symmetric(vertical: 10),
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Center(
//                   child: Text(
//                     'Change Profile Picture',
//                     style: TextStyle(color: Colors.white, fontSize: 18),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 30),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   isActive = !isActive;
//                 });
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(75, 158, 158, 158),
//                   borderRadius: BorderRadius.circular(
//                       10.0), // Adjust the radius as needed
//                   border: Border.all(
//                     color: Colors.black, // Color of the border
//                     width: 1.0, // Width of the border
//                   ),
//                 ), // Set background color
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.work,
//                     color: Colors.brown,
//                   ),
//                   title: Text(
//                     'Activetion',
//                     style: TextStyle(
//                       fontSize: 20,
//                       color: isActive ? Colors.green : Colors.red,
//                     ),
//                   ),
//                   trailing: Switch(
//                     value: isActive,
//                     onChanged: (value) {
//                       setState(() {
//                         isActive = value;
//                       });
//                     },
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 10),
//             Container(
//               decoration: BoxDecoration(
//                 color: const Color.fromARGB(75, 158, 158, 158),
//                 borderRadius:
//                     BorderRadius.circular(10.0), // Adjust the radius as needed
//                 border: Border.all(
//                   color: Colors.black, // Color of the border
//                   width: 1.0, // Width of the border
//                 ),
//               ),
//               child: ListTile(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AccountSettingUI(),
//                     ),
//                   );
//                 },
//                 leading: Icon(
//                   Icons.settings,
//                   color: Colors.blue,
//                 ),
//                 title: Text(
//                   'Account Setting',
//                   style: TextStyle(fontSize: 20, color: Colors.blue),
//                 ),
//                 trailing: Icon(Icons.arrow_forward),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => ResetPasswordUI()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 fixedSize: Size(200, 50),
//               ),
//               child:
//                   Text('Reset Password', style: TextStyle(color: Colors.white)),
//             ),
//             SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () async {
//                 _showSignOutDialog(context);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 fixedSize: Size(200, 50),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.logout,
//                     color: Colors.white,
//                   ),
//                   SizedBox(width: 5),
//                   Text('Logout', style: TextStyle(color: Colors.white)),
//                 ],
//               ),
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<String?> getUserProfileImage() async {
//     // ระบุ path ใน Firebase Storage ที่เก็บรูปโปรไฟล์
//     String storagePath =
//         'images/${FirebaseAuth.instance.currentUser!.email!.substring(0, FirebaseAuth.instance.currentUser!.email!.indexOf('@'))}_Patient.jpg';

//     try {
//       // อ้างอิง Firebase Storage instance
//       final Reference storageReference =
//           FirebaseStorage.instance.ref().child(storagePath);

//       // ดึง URL ของรูปโปรไฟล์จาก Firebase Storage
//       String downloadURL = await storageReference.getDownloadURL();

//       return downloadURL;
//     } catch (e) {
//       print('เกิดข้อผิดพลาดในการดึงรูปโปรไฟล์: $e');
//       return null;
//     }
//   }
// }

// void _showSignOutDialog(BuildContext context) {
//   final AuthenticationService _authenticationService = AuthenticationService();
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text("Confirm Log Out"),
//         content: Text("Are you sure you want to Log Out?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () async {
//               await _authenticationService.signOut();
//               Navigator.pop(context);
//               // Navigate to login screen
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => LoginUI(),
//                 ),
//               );
//             },
//             child: Text("Log Out"),
//           ),
//         ],
//       );
//     },
//   );
// }
