import 'dart:async';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

        return ListView.builder(
          shrinkWrap: true,
          physics: ClampingScrollPhysics(), // ทำให้ไม่สามารถเลื่อนได้
          itemCount: users.length,
          itemBuilder: (context, index) {
            final userData = users[index].data() as Map<String, dynamic>;
            final name = userData['name'];

            return GestureDetector(
              // หรือใช้ InkWell ก็ได้
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) =>
                //         ReviewPage(), // นำทางไปยังหน้า ReviewPage
                //   ),
                // );
              },
              child: Card(
                color: AllColor.Primary,
                elevation: 20,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading:
                      Icon(Icons.account_circle, color: AllColor.Backgroud),
                  title: Text(
                    'ชื่อ: $name',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
