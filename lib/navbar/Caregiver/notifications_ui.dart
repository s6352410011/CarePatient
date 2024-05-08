import 'package:care_patient/class/color.dart';
import 'package:care_patient/navbar/Caregiver/employment_ct.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationsUI_C extends StatefulWidget {
  const NotificationsUI_C({super.key});

  @override
  State<NotificationsUI_C> createState() => _NotificationsUI_CState();
}

class _NotificationsUI_CState extends State<NotificationsUI_C> {
  static const Color appBarColor = AllColor.Primary_C;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Noti(),
            ],
          ),
        ),
      ),
    );
  }
}

class Noti extends StatefulWidget {
  @override
  _NotiState createState() => _NotiState();
}

class _NotiState extends State<Noti> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('patient').get(),
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

        return ListView(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(),
          children: users.map((userDoc) {
            final userData = userDoc.data() as Map<String, dynamic>;
            final name = userData['name'];
            final email = userData['email']; //
            final gender = userData['gender'];
            final phonenumber = userData['phoneNumber'];
            final imagePath = userData['imagePath'];

            if (email != currentUserEmail) {
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ข้อมูลเพิ่มเติม'),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('คุณ: $name'),
                            Text('ต้องการว่าจ้างกับคุณ'),
                            Text('คุณสามากดดูรายละเอียดผู้ว่าจ้างได้'),
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EMP_CT(),
                                ),
                              );
                            },
                            child: Text('รายละเอียด'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Card(
                  color: AllColor.Primary,
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: imagePath != null
                          ? NetworkImage(imagePath)
                          : null, // ตรวจสอบว่า imagePath ไม่เป็น Null ก่อนใช้งาน
                    ),
                    title: Text(
                      'ผู้ที่ต้องการว่าจ้าง : $name',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'เพศ : $gender',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'เบอร์ติดต่อ : $phonenumber',
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
          }).toList(),
        );
      },
    );
  }
}
