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

class UserDataWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('caregiver').get(),
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
        final users = snapshot.data!.docs;
        final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final name = userData['name'];
            final email = userData['email'];
            final careExperience = userData['careExperience'];
            final relatedSkills = userData['relatedSkills'];
            final imagePath = userData['imagePath'];

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
                  color: Colors.blue, // Change color as needed
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          imagePath != null ? NetworkImage(imagePath) : null,
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
