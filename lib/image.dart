import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String uid;

  SecondPage({required this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('หน้าที่สอง'),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          Map<String, dynamic> userData =
              snapshot.data!.data() as Map<String, dynamic>;
          String name = userData['name'];
          int age = userData['age'];
          String gender = userData['gender'];
          String address = userData['address'];

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: $name'),
                Text('Age: $age'),
                Text('Gender: $gender'),
                Text('Address: $address'),
              ],
            ),
          );
        },
      ),
    );
  }
}
