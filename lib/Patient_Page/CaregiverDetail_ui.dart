import 'package:care_patient/Caregiver_Page/writedaily_ui.dart';
import 'package:care_patient/Patient_Page/main_PatientUI.dart';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaregiverDetailPage extends StatefulWidget {
  final String uid;
  String? _userProfileImageUrl;

  CaregiverDetailPage({required this.uid});

  @override
  _CaregiverDetailPageState createState() => _CaregiverDetailPageState();
}

class _CaregiverDetailPageState extends State<CaregiverDetailPage> {
  String? _userProfileImageUrl;

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
  void initState() {
    super.initState();
    // เรียกใช้ getUserProfileImage() เมื่อเริ่มต้นการแสดงผล
    _loadUserProfileImage();
  }

  void _loadUserProfileImage() async {
    String? url = await getUserProfileImage();
    setState(() {
      _userProfileImageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดผู้ดูแล'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('caregiver')
            .doc(widget.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('ไม่พบข้อมูลผู้ดูแล'));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final name = userData['name'] ?? '';
          final careExperience = userData['careExperience'] ?? '';
          final relatedSkills = userData['relatedSkills'] ?? '';
          final rateMoney = userData['rateMoney'] ?? '';
          final gender = userData['gender'];
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _userProfileImageUrl != null
                    ? Padding(
                        padding: EdgeInsets.all(16),
                        child: CircleAvatar(
                          radius: 70,
                          backgroundImage: NetworkImage(_userProfileImageUrl!),
                        ),
                      )
                    : Icon(Icons.person, size: 150),
                Text(
                  'ชื่อ: $name',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'เพศ: $gender',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'ประสบการณ์ด้านการดูแล: $careExperience',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'ทักษะที่เกี่ยวข้อง: $relatedSkills',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  'เรทเงิน: $rateMoney',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          await FirebaseFirestore.instance
                              .collection('caregiver')
                              .doc(widget.uid)
                              .collection('sendProgress')
                              .add({'status': 'good'});

                          // นับจำนวนเอกสารทั้งหมดที่อยู่ในคอลเล็กชัน 'sendProgress'
                          QuerySnapshot querySnapshot = await FirebaseFirestore
                              .instance
                              .collection('caregiver')
                              .doc(widget.uid)
                              .collection('sendProgress')
                              .get();
                          int work = querySnapshot.size; // จำนวนเอกสารทั้งหมด

                          // แสดง Pop-up และให้ยืนยัน
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("ยืนยันการจ้างงาน"),
                                content:
                                    Text("คุณต้องการยืนยันการจ้างงานหรือไม่?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomeMainPatientUI()));
                                    },
                                    child: Text("ยืนยัน"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("ยกเลิก"),
                                  ),
                                ],
                              );
                            },
                          );
                        } catch (e) {
                          print('Error: $e');
                        }
                      },
                      child: Text('จ้างงาน'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // เมื่อปุ่มถูกกด
                        Navigator.pop(context); // ย้อนกลับไปยังหน้าก่อนหน้านี้
                      },
                      child: Text('ยกเลิก'),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

    // final name = userData['name'];
    // final careExperience = userData['careExperience'];
    // final relatedSkills = userData['relatedSkills'];
    // final imagePath = userData['imagePath'];
    // final phonenumber = userData['phoneNumber'];
    // final gender = userData['gender'];
    // final address = userData['address'];
    // final ratemoney = userData['rateMoney'];

// // ดึงข้อมูลของผู้ดูแลทั้งหมดจาก Firebase
//     Future<List<Map<String, dynamic>>> _loadUserDataWithImages() async {
//       QuerySnapshot querySnapshot =
//           await FirebaseFirestore.instance.collection('caregiver').get();
//       List<Map<String, dynamic>> userDataWithImages = [];
//       for (var doc in querySnapshot.docs) {
//         final data = doc.data();
//         if (data != null) {
//           final name = (data as Map<String, dynamic>)['name'] as String?;
//           final email = (data as Map<String, dynamic>)['email'] as String?;
//           final relatedSkills =
//               (data as Map<String, dynamic>)['relatedSkills'] as String?;
//           final careExperience =
//               (data as Map<String, dynamic>)['careExperience'] as String?;
//           final rateMoney =
//               (data as Map<String, dynamic>)['rateMoney'] as String?;
//           final status = (data as Map<String, dynamic>)['Status'] as bool? ??
//               false; // กำหนดค่าเริ่มต้นเป็น false

//           if (status &&
//               name != null &&
//               email != null &&
//               relatedSkills != null &&
//               careExperience != null &&
//               rateMoney != null) {
//             String storagePath =
//                 'images/${email.substring(0, email.indexOf('@'))}_Patient.jpg';
//             final imageUrl = await _getUserProfileImageUrl(storagePath);
//             userDataWithImages.add({
//               'name': name,
//               'imageUrl': imageUrl,
//               'relatedSkills': relatedSkills,
//               'careExperience': careExperience,
//               'rateMoney': rateMoney,
//             });
//           }
//         }
//       }
//       return userDataWithImages;
//     }

    // Future<String?> _getUserProfileImageUrl(String storagePath) async {
    //   try {
    //     final Reference storageReference =
    //         FirebaseStorage.instance.ref().child(storagePath);
    //     return await storageReference.getDownloadURL();
    //   } catch (e) {
    //     print('เกิดข้อผิดพลาดในการดึงรูปโปรไฟล์: $e');
    //     return null;
    //   }
    // }

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('รายละเอียดผู้ดูแล'),
    //   ),
    //   body: SingleChildScrollView(
    //     padding: EdgeInsets.all(20),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         if (imagePath != null)
    //           Center(
    //             child: CircleAvatar(
    //               backgroundImage: NetworkImage(imagePath),
    //               radius: 80,
    //             ),
    //           ),
    //         SizedBox(height: 20),
    //         Text(
    //           'ชื่อ: $name',
    //           style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    //         ),
    //         SizedBox(height: 10),
    //         Text(
    //           'ประสบการณ์ด้านการดูแล: $careExperience',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         SizedBox(height: 10),
    //         Text(
    //           'ทักษะที่เกี่ยวข้อง: $relatedSkills',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         SizedBox(height: 10),
    //         Text(
    //           'เบอร์ติดต่อ: $phonenumber',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         SizedBox(height: 10),
    //         Text(
    //           'เพศ: $gender',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         SizedBox(height: 10),
    //         Text(
    //           'ที่อยู่: $address',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         SizedBox(height: 10),
    //         Text(
    //           'เรทเงินที่ต้องการ: $ratemoney',
    //           style: TextStyle(fontSize: 18),
    //         ),
    //         SizedBox(height: 20),
    //         // ปุ่ม "จ้างงาน"
    //         ElevatedButton(
    //           onPressed: () async {
    //             try {
    //               final email = userData['email']; // email ของคนที่เราจ้างงาน
    //               await FirebaseFirestore.instance
    //                   .collection('caregiver')
    //                   .doc(
    //                       email) // ใช้ email เป็น document ID เพื่อเข้าถึงเอกสารของผู้ดูแลที่เราจ้างงาน
    //                   .collection('sendprogress')
    //                   .add({'status': 'good'});
    //               // โค้ดเพิ่ม collection และเก็บข้อมูล "good" ในเอกสารของคนที่เราจ้างงาน
    //             } catch (e) {
    //               print('Error: $e');
    //               // จัดการข้อผิดพลาดที่เกิดขึ้น
    //             }
    //           },
    //           child: Text('จ้างงาน'),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

