import 'package:care_patient/Caregiver_Page/writedaily_ui.dart';
import 'package:care_patient/Patient_Page/main_PatientUI.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaregiverDetailPage extends StatefulWidget {
  final String uid;

  CaregiverDetailPage({required this.uid});

  @override
  _CaregiverDetailPageState createState() => _CaregiverDetailPageState();
}

class _CaregiverDetailPageState extends State<CaregiverDetailPage> {
  String? _userProfileImageUrl;

  bool isActive = true;
  String? _userEmail;
  @override
  void initState() {
    super.initState();
    // เรียกใช้ฟังก์ชันเมื่อ Widget ถูกสร้าง
    _fetchUserProfileImage(widget.uid);
  }

  Future<void> _fetchUserProfileImage(String uid) async {
    String? userProfileImage = await getUserProfileImage();
    if (userProfileImage != null) {
      setState(() {
        _userProfileImageUrl = userProfileImage;
      });
    }
  }

// String storagePath = 'images/${uid}_Patient.jpg';
  // เมื่อทำการโหลดข้อมูลผู้ดูแลเสร็จสิ้น ให้โหลดรูปภาพโปรไฟล์ของผู้ดูแล
  Future<String?> getUserProfileImage() async {
    // ระบุ path ใน Firebase Storage ที่เก็บรูปโปรไฟล์
    // String storagePath = 'images/${widget.uid}_Patient.jpg';
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
                          // รับข้อมูล email จากการเข้าสู่ระบบ
                          String userEmail =
                              FirebaseAuth.instance.currentUser!.email!;

                          // บันทึกข้อมูลลงใน Firestore
                          await FirebaseFirestore.instance
                              .collection('caregiver')
                              .doc(widget.uid)
                              .collection('sendProgress')
                              .doc(userEmail) // ใช้ email เป็นเอกสาร ID
                              .set({'status': 'True'});

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
                        // โค้ดที่เหมือนเดิม
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
