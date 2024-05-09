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

      if (status &&
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
            final email = userData['email'];
            final careExperience = userData['careExperience'];
            final relatedSkills = userData['relatedSkills'];
            final imageUrl = userData['imageUrl']; // เพิ่มการดึง URL ของรูปภาพ

            if (email != currentUserEmail) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CaregiverDetailPage(userData: userData)),
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

class CaregiverDetailPage extends StatelessWidget {
  final Map<String, dynamic> userData;

  const CaregiverDetailPage({Key? key, required this.userData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final name = userData['name'];
    final careExperience = userData['careExperience'];
    final relatedSkills = userData['relatedSkills'];
    final imagePath = userData['imagePath'];
    final phonenumber = userData['phoneNumber'];
    final gender = userData['gender'];
    final address = userData['address'];
    final ratemoney = userData['rateMoney'];

    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดผู้ดูแล'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              Center(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(imagePath),
                  radius: 80,
                ),
              ),
            SizedBox(height: 20),
            Text(
              'ชื่อ: $name',
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
              'เบอร์ติดต่อ: $phonenumber',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'เพศ: $gender',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'ที่อยู่: $address',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'เรทเงินที่ต้องการ: $ratemoney',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // ปุ่ม "จ้างงาน"
            ElevatedButton(
              onPressed: () async {
                try {
                  final email = userData['email']; // email ของคนที่เราจ้างงาน
                  await FirebaseFirestore.instance
                      .collection('caregiver')
                      .doc(
                          email) // ใช้ email เป็น document ID เพื่อเข้าถึงเอกสารของผู้ดูแลที่เราจ้างงาน
                      .collection('sendprogress')
                      .add({'status': 'good'});
                  // โค้ดเพิ่ม collection และเก็บข้อมูล "good" ในเอกสารของคนที่เราจ้างงาน
                } catch (e) {
                  print('Error: $e');
                  // จัดการข้อผิดพลาดที่เกิดขึ้น
                }
              },
              child: Text('จ้างงาน'),
            ),
          ],
        ),
      ),
    );
  }
}
