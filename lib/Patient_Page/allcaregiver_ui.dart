import 'package:care_patient/Patient_Page/CaregiverDetail_ui.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AllCareGiverUI extends StatefulWidget {
  const AllCareGiverUI({Key? key});

  @override
  State<AllCareGiverUI> createState() => _AllCareGiverUIState();
}

class _AllCareGiverUIState extends State<AllCareGiverUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายชื่อผู้ดูแลทั้งหมด'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            UserDataWidget(),
          ],
        ),
      ),
    );
  }
}

// ดึงข้อมูลของผู้ดูแลทั้งหมดจาก Firebase
Future<List<Map<String, dynamic>>> _loadUserDataWithImages() async {
  String? currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  if (currentUserEmail == null) {
    return []; // Return empty list if user is not logged in
  }

  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('caregiver').get();
  List<Map<String, dynamic>> userDataWithImages = [];
  for (var doc in querySnapshot.docs) {
    final data = doc.data();
    if (data != null) {
      final name = (data as Map<String, dynamic>)['name'] as String?;
      final email = (data as Map<String, dynamic>)['email'] as String?;
      final relatedSkills =
          (data as Map<String, dynamic>)['relatedSkills'] as String?;
      final careExperience =
          (data as Map<String, dynamic>)['careExperience'] as String?;
      final rateMoney = (data as Map<String, dynamic>)['rateMoney'] as String?;
      final status = (data as Map<String, dynamic>)['Status'] as bool? ??
          false; // กำหนดค่าเริ่มต้นเป็น false

      // เช็คว่า email ไม่เท่ากับอีเมลของผู้ใช้ที่เข้าสู่ระบบ
      if (email != currentUserEmail &&
          status &&
          name != null &&
          email != null &&
          relatedSkills != null &&
          careExperience != null &&
          rateMoney != null) {
        String storagePath =
            'images/${email.substring(0, email.indexOf('@'))}_Patient.jpg';
        final imageUrl = await _getUserProfileImageUrl(storagePath);
        userDataWithImages.add({
          'name': name,
          'imageUrl': imageUrl,
          'relatedSkills': relatedSkills,
          'careExperience': careExperience,
          'rateMoney': rateMoney,
        });
      }
    }
  }
  return userDataWithImages;
}

Future<List<String>> _loadUserImages() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('caregiver').get();
  List<String> imageUrls = [];
  querySnapshot.docs.forEach((doc) {
    final data = doc.data();
    if (data != null) {
      final imageUrl = (data as Map<String, dynamic>)['imageUrl'] as String?;
      if (imageUrl != null) {
        imageUrls.add(imageUrl);
      }
    }
  });
  return imageUrls;
}

Future<String?> _getUserProfileImageUrl(String storagePath) async {
  try {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(storagePath);
    return await storageReference.getDownloadURL();
  } catch (e) {
    print('เกิดข้อผิดพลาดในการดึงรูปโปรไฟล์: $e');
    return null;
  }
}

class UserDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _loadUserDataWithImages(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        final users = snapshot.data ?? [];
        final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index];
            final name = userData['name'];
            final uid = userData['uid'];
            final email = userData['email'];
            final careExperience = userData['careExperience'];
            final relatedSkills = userData['relatedSkills'];
            final rateMoney = userData['rateMoney'];
            final imageUrl = userData['imageUrl']; // เพิ่มการดึง URL ของรูปภาพ

            if (email != currentUserEmail) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CaregiverDetailPage(uid: uid)),
                  );
                },
                child: Card(
                  color: Colors.blue,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl) : null,
                    ),
                    title: Text(
                      'ชื่อ: $name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ประสบการณ์ด้านการดูแล: $careExperience',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'ทักษะที่เกี่ยวข้อง: $relatedSkills',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'เรทเงิน: $rateMoney',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        );
      },
    );
  }
}
