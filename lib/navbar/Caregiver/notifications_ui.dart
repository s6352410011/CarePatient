import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care_patient/Patient_Page/main_PatientUI.dart';
import 'package:care_patient/Caregiver_Page/main_caregiverUI.dart';
class NotificationsUI_C extends StatefulWidget {
  const NotificationsUI_C({Key? key}) : super(key: key);

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
    final currentUserEmail = FirebaseAuth.instance.currentUser?.email;

    if (currentUserEmail != null) {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('caregiver')
          .doc(currentUserEmail)
          .collection('sendProgress')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        setState(() {
          sendProgressData =
              querySnapshot.docs.map((doc) => doc['status'] as String).toList();
          sendProgressUid = querySnapshot.docs.map((doc) => doc.id).toList();
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
                        .collection('patient')
                        .doc(sendProgressUid[index])
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }

                      if (snapshot.hasData && snapshot.data != null) {
                        var userData = snapshot.data!.data();
                        if (userData != null &&
                            userData is Map<String, dynamic>) {
                          var name = userData['name'];
                          var gender = userData['gender'];
                          var phoneNumber = userData['phoneNumber'];
                          var birthDate = userData['birthDate'];
                          var history_medicine = userData['history_medicine'];
                          var special_needs = userData['special_needs'];

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
                                        SizedBox(height: 5),
                                        Text(
                                          'Name: $name',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          'Gender: $gender',
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
                                                birthDate: birthDate,
                                                history_medicine:
                                                    history_medicine,
                                                special_needs: special_needs,
                                                uid: sendProgressUid[index],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text('Hiring Details'),
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
                                    // Text(
                                    //   'UID: ${sendProgressUid[index]}',
                                    //   style: TextStyle(
                                    //       fontSize: 16,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    SizedBox(height: 5),
                                    Text(
                                      'คุณ: $name',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text('มีข้อเสนอจ้างดูแลผู้ป่วย'),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Text('Data is not valid');
                        }
                      }

                      return Text('Data not found');
                    },
                  );
                },
              )
            : Text(
                'No data to display',
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
  final String birthDate;
  final String special_needs;
  final String history_medicine;
  final String uid;

  HiringDetailsPage({
    required this.history_medicine,
    required this.special_needs,
    required this.birthDate,
    required this.name,
    required this.gender,
    required this.phoneNumber,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hiring Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hiring Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: $name'),
            Text('Gender: $gender'),
            Text('Phone: $phoneNumber'),
            Text('Birth Date: $birthDate'),
            Text('History of Medicine: $history_medicine'),
            Text('Special Needs: $special_needs'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String userEmail =
                          FirebaseAuth.instance.currentUser!.email!;
                      await FirebaseFirestore.instance
                          .collection('patient')
                          .doc(uid)
                          .collection('inprogress')
                          .doc('accept')
                          .set({
                        'Acceptance': 'Confirmed',
                      });

                      await FirebaseFirestore.instance
                          .collection('caregiver')
                          .doc(userEmail)
                          .collection('inprogress')
                          .doc('accept_by_me')
                          .set({
                        'Acceptance': 'Confirmed',
                      });

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("ยืนยัน"),
                            content: Text("คุณต้องการยืนยันใข่ไหม"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeMainCareUI()));
                                },
                                child: Text("ยอมรับ"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("ปฎิเศษ"),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Text('ยอมรับ'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      String userEmail =
                          FirebaseAuth.instance.currentUser!.email!;
                      await FirebaseFirestore.instance
                          .collection('patient')
                          .doc(uid)
                          .collection('inprogress')
                          .doc('accept')
                          .set({
                        'Acceptance': 'cancel',
                      });

                      await FirebaseFirestore.instance
                          .collection('caregiver')
                          .doc(userEmail)
                          .collection('inprogress')
                          .doc('accept_by_me')
                          .set({
                        'Acceptance': 'cancel',
                      });
                      await FirebaseFirestore.instance
                          .collection('caregiver')
                          .doc(userEmail)
                          .collection('inprogress')
                          .doc('accept_by_me')
                          .set({
                        'Acceptance': 'cancel',
                      });
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("ยืนยัน"),
                            content: Text("คุณต้องการยืนยันใข่ไหม"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeMainCareUI()));
                                },
                                child: Text("ยอมรับ"),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text("ปฎิเศษ"),
                              ),
                            ],
                          );
                        },
                      );
                    } catch (e) {
                      print('Error: $e');
                    }
                  },
                  child: Text('ยกเลิก'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
