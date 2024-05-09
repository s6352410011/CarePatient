import 'package:care_patient/class/color.dart';
import 'package:care_patient/navbar/Caregiver/employment_ct.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
              UserDataWidget(),
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
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => EmpCtd(),
                              //   ),
                              // );
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

// // ดึงข้อมูลของผู้ดูแลทั้งหมดจาก Firebase
// Future<List<Map<String, dynamic>>> _loadUserDataWithImages() async {
//   QuerySnapshot querySnapshot =
//       await FirebaseFirestore.instance.collection('patient').get();
//   List<Map<String, dynamic>> userDataWithImages = [];
//   for (var doc in querySnapshot.docs) {
//     final data = doc.data();
//     final uid = doc.id; // เพิ่มบรรทัดนี้เพื่อดึง UID ของเอกสาร
//     if (data != null) {
//       final name = (data as Map<String, dynamic>)['name'] as String?;
//       final email = (data as Map<String, dynamic>)['email'] as String?;
//       final birthDate = (data as Map<String, dynamic>)['birthDate'] as String?;
//       final phoneNumber =
//           (data as Map<String, dynamic>)['phoneNumber'] as String?;
//       final specialNeeds =
//           (data as Map<String, dynamic>)['specialNeeds'] as String?;
//       final historyMedicine =
//           (data as Map<String, dynamic>)['historyMedicine'] as String?;

//       if (name != null &&
//           email != null &&
//           birthDate != null &&
//           phoneNumber != null &&
//           specialNeeds != null &&
//           historyMedicine != null) {
//         String storagePath =
//             'images/${email.substring(0, email.indexOf('@'))}_Patient.jpg';
//         final imageUrl = await _getUserProfileImageUrl(storagePath);
//         userDataWithImages.add({
//           'uid': uid, // เพิ่ม UID ใน Map ของข้อมูล
//           'name': name,
//           'imageUrl': imageUrl,
//           'birthDate': birthDate,
//           'phoneNumber': phoneNumber,
//           'specialNeeds': specialNeeds,
//           'historyMedicine': historyMedicine,
//         });
//       }
//     }
//   }
//   return userDataWithImages;
// }

// ดึงข้อมูลของผู้ดูแลทั้งหมดจาก Firebase
Future<List<Map<String, dynamic>>> _loadUserDataWithImages() async {
  QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('caregiver').get();
  List<Map<String, dynamic>> userDataWithImages = [];
  for (var doc in querySnapshot.docs) {
    final data = doc.data();
    final uid = doc.id; // เพิ่มบรรทัดนี้เพื่อดึง UID ของเอกสาร
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
          'uid': uid, // เพิ่ม UID ใน Map ของข้อมูล
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
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => CaregiverDetailPage(uid: uid)),
                  // );
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
