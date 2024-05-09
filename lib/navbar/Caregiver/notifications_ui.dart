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
            final name = userData['name'] ?? '';
            final email = userData['email'] ?? '';
            final gender = userData['gender'] ?? '';
            final phonenumber = userData['phoneNumber'] ?? '';
            final phonefamily = userData['phone_number'] ?? '';
            final imagePath = userData['imagePath'] ?? '';
            final address = userData['address'] ?? '';
            final birthdate = userData['birthDate'] ?? '';
            final historyMed = userData['history_medicine'] ?? '';
            final specialneeds = userData['special_needs'] ?? '';

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
                                  builder: (context) => EmpCtd(
                                    name: name,
                                    gender: gender,
                                    phoneNumber: phonenumber,
                                    imagePath: imagePath,
                                    address: address,
                                    phoneFamily: phonefamily,
                                    historyMed: historyMed,
                                    specialNeeds: specialneeds,
                                    birthDate: birthdate,
                                    historyMedicine:
                                        historyMed, // แนบ historyMedicine ที่นี่
                                  ),
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
                      backgroundImage:
                          imagePath != null ? NetworkImage(imagePath) : null,
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

class EmpCtd extends StatelessWidget {
  final String name;
  final String gender;
  final String phoneNumber;
  final String? imagePath;
  final String phoneFamily;
  final String address;
  final String birthDate;
  final String historyMed;
  final String specialNeeds;
  final String historyMedicine;

  const EmpCtd({
    required this.name,
    required this.gender,
    required this.phoneNumber,
    this.imagePath,
    required this.phoneFamily,
    required this.address,
    required this.birthDate,
    required this.historyMed,
    required this.specialNeeds,
    required this.historyMedicine,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียดของผู้ว่าจ้าง',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null)
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(imagePath!),
                ),
              ),
            SizedBox(height: 40),
            Text(
              'ชื่อ : $name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'เพศ : $gender',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'เบอร์ติดต่อ : $phoneNumber',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'เบอร์ติดต่อญาติ : $phoneFamily',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'ที่อยู่ : $address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'วันเกิด : $birthDate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'ประวัติการใช้ยา : $historyMed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'ความต้องการพิเศษ : $specialNeeds',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(
                  
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllColor.Primary,
                    fixedSize: Size(150, 50),
                  ),
                  onPressed: () {
                    // การทำงานเมื่อปุ่ม 'ยอมรับ' ถูกกด
                  },
                  child: Text('ยอมรับ',style: TextStyle(color: AllColor.TextPrimary),),
                  
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllColor.Third,
                    fixedSize: Size(150, 50),
                  ),
                  onPressed: () {
                    // การทำงานเมื่อปุ่ม 'ปฏิเสธ' ถูกกด
                  },
                  child: Text('ปฏิเสธ',style: TextStyle(color: AllColor.TextPrimary),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
