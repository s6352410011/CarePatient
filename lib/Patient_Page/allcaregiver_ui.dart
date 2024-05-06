import 'dart:async';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllCareGiverUI extends StatefulWidget {
  const AllCareGiverUI({super.key});

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
                onTap: () {},
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
                          'อีเมล: $email',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
