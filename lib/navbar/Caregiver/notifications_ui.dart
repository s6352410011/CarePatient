import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsUI_C extends StatefulWidget {
  const NotificationsUI_C({super.key});

  @override
  State<NotificationsUI_C> createState() => _NotificationsUI_CState();
}

class _NotificationsUI_CState extends State<NotificationsUI_C> {
  List<String> sendProgressData = [];
  List<String> sendProgressUid = [];

  @override
  void initState() {
    super.initState();
    _checkSendProgress();
  }

  Future<void> _checkSendProgress() async {
    // รับอีเมลของผู้ใช้ปัจจุบันจาก Firebase Authentication
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    // ตรวจสอบว่าอีเมลของผู้ใช้ปัจจุบันไม่ใช่ค่าว่าง
    if (currentUserEmail != null) {
      // หากมีอีเมลไม่ใช่ค่าว่าง จะดึงข้อมูลจาก Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('caregiver')
          .doc(currentUserEmail)
          .collection('sendProgress')
          .get();

      // ตรวจสอบว่ามีข้อมูลสถานะการส่งข้อมูลหรือไม่
      if (querySnapshot.docs.isNotEmpty) {
        // วนลูปเพื่อดึงข้อมูลและเก็บไว้ใน sendProgressData และ sendProgressUid
        setState(() {
          sendProgressData =
              querySnapshot.docs.map((doc) => doc['status'] as String).toList();
          sendProgressUid = querySnapshot.docs
              .map((doc) => doc.id)
              .toList(); // ดึง UID ของเอกสาร
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: sendProgressData.isNotEmpty
            ? ListView.builder(
                itemCount: sendProgressData.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('caregiver')
                        .doc(sendProgressUid[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("เกิดข้อผิดพลาด: ${snapshot.error}");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        var userData = snapshot.data!.data();
                        if (userData != null &&
                            userData is Map<String, dynamic>) {
                          var name = userData['name']; // ชื่อของ caregiver
                          var gender = userData['gender'];
                          var phoneNumber = userData['phoneNumber'];

                          return GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Caregiver Details'),
                                    content: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'UID: ${sendProgressUid[index]}', // แสดง UID ที่ตรงกับข้อมูล
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'ชื่อ: $name', // แสดงชื่อของ caregiver
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'เพศ: $gender', // แสดงเพศของ caregiver
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HiringDetailsPage(
                                                    name: name,
                                                    gender: gender,
                                                    phoneNumber: phoneNumber,

                                                  ), // Replace HiringDetailsPage() with the page you want to navigate to
                                            ),
                                          );
                                        },
                                        child: Text('รายละเอียดการว่าจ้าง'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Card(
                              margin: EdgeInsets.all(10),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'UID: ${sendProgressUid[index]}', // แสดง UID ที่ตรงกับข้อมูล
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'ชื่อ: $name', // แสดงชื่อของ caregiver
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'เพศ: $gender', // แสดงเพศของ caregiver
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Text('ข้อมูลไม่ถูกต้อง');
                        }
                      }

                      return Text('ไม่พบข้อมูล');
                    },
                  );
                },
              )
            : Text(
                'ไม่มีข้อความเพื่อแสดง',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }
}

class HiringDetailsPage extends StatelessWidget {
  final String name;
  final String gender;
  final String phoneNumber;

  HiringDetailsPage({required this.name,required this.gender ,required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดการว่าจ้าง'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'รายละเอียดการว่าจ้าง',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display hiring details
            Text('ชื่อผู้ว่าจ้าง: $name'),
            Text('เพศ: $gender'),
            Text('โทรศัพท์: $phoneNumber'),
          ],
        ),
      ),
    );
  }
}
