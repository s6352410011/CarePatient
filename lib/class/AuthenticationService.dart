import 'package:care_patient/class/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
  // SharedPreferences key
  static const String _loggedInKey = 'isLoggedIn';
  static const String _emailKey = 'email';
  static const String _usernameKey = 'username';
  static const String _uidKey = 'uid';
  static const String _imageUrlKey = 'imageUrl';
  User? chat() {
    return _auth.currentUser;
  }

  String? getCurrentUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
  }

  String? getEmail() {
    User? user = _auth.currentUser;
    return user?.email;
  }

  Future<void> _setUserDataInSharedPreferences({
    String? email,
    String? username,
    String? uid,
    String? imageUrl,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email ?? '');
    await prefs.setString(_usernameKey, username ?? '');
    await prefs.setString(_uidKey, uid ?? '');
    await prefs.setString(_imageUrlKey, imageUrl ?? '');
  }

  // Method สำหรับ SignIn **loging ด้วย เมลล์
  // Method to sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        // Set logged in status
        await _setLoggedIn(true);

        // Set user data in SharedPreferences
        await _setUserDataInSharedPreferences(
          email: user.email,
          uid: user.uid,
        );

        return user;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Method to sign in with Google
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;

      if (user != null) {
        // Check if the user exists in Firestore
        final userDoc =
            FirebaseFirestore.instance.collection('users').doc(user.email);
        final userDocSnapshot = await userDoc.get();

        if (!userDocSnapshot.exists) {
          // If the user does not exist, add their data to Firestore
          await userDoc.set({
            'email': user.email, // Add email field to the document
            // Add other fields as needed
          });
        }

        // Set logged in status
        await _setLoggedIn(true);

        // Set user data in SharedPreferences
        await _setUserDataInSharedPreferences(
          email: user.email,
          username: user.displayName,
          uid: user.uid,
          imageUrl: user.photoURL,
        );

        return user;
      }
    }
    return null;
  }

  // Method to get user data from SharedPreferences
  Future<UserData> getUserDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserData(
      email: prefs.getString(_emailKey) ?? '',
      username: prefs.getString(_usernameKey) ?? '',
      uid: prefs.getString(_uidKey) ?? '',
      imageUrl: prefs.getString(_imageUrlKey) ?? '',
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _setLoggedIn(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> _setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Method สำหรับตรวจสอบสถานะการเข้าสู่ระบบ
  Future<bool> isSignedIn() async {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  // Method สำหรับรับข้อมูลผู้ใช้ปัจจุบัน
  Future<User?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> _checkIfEmailExists(String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('registerusers')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future getData() async {
    try {
      // ดึงข้อมูลจาก Collection "care_seekers"
      Future<QuerySnapshot> careSeekers =
          FirebaseFirestore.instance.collection("patient").get();

      // ดึงข้อมูลจาก Collection "care_providers"
      Future<QuerySnapshot> careProviders =
          FirebaseFirestore.instance.collection("caregiver").get();

      // ดึงข้อมูลจาก Collection "users"
      Future<QuerySnapshot> users =
          FirebaseFirestore.instance.collection("users").get();

      // รอให้ข้อมูลจากทั้งสาม Collection ถูกดึงกลับมา
      var snapshots = await Future.wait([careSeekers, careProviders, users]);

      // ตอนนี้คุณสามารถใช้ snapshots[index] เพื่อเข้าถึงข้อมูลของแต่ละ Collection ได้
      var careSeekersData = snapshots[0].docs;
      var careProvidersData = snapshots[1].docs;
      var usersData = snapshots[2].docs;

      // ต่อไปคุณสามารถนำข้อมูลที่ได้มาแสดงในหน้าจอได้
      // ตัวอย่าง: แสดงจำนวนข้อมูลที่ได้จากแต่ละ Collection
      print("Care Seekers count: ${careSeekersData.length}");
      print("Care Providers count: ${careProvidersData.length}");
      print("Users count: ${usersData.length}");

      // ต่อไปคุณสามารถนำข้อมูลที่ได้มาแสดงในหน้าจอได้
    } catch (e) {
      print('Error getting data: $e');
    }
  }

  //เช็คเบอร์โทรศัพท์
  // Future<bool> checkCaregiverPhoneNumberExists(String email) async {
  //   DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await FirebaseFirestore.instance.collection('caregiver').doc().get();

  //   return snapshot.exists && snapshot.data()!['phoneNumber'] != null;
  // }

  // Future<bool> checkPatientPhoneNumberExists(String email) async {
  //   DocumentSnapshot<Map<String, dynamic>> snapshot =
  //       await FirebaseFirestore.instance.collection('patient').doc().get();

  //   return snapshot.exists && snapshot.data()!['phoneNumber'] != null;
  // }
  Future<bool> checkUserPhoneNumberExists(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    return snapshot.exists && snapshot.data()!['phoneNumber'] != null;
  }

  //เช็ค Caregiver Policy
  Future<bool> checkCaregiverAcceptedPolicy(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('caregiver')
        .doc(email)
        .get();

    return snapshot.exists && snapshot.data()!['acceptedPolicy'] == true;
  }

  //เช็ค Patient Policy
  Future<bool> checkPatientAcceptedPolicy(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('patient').doc(email).get();

    return snapshot.exists && snapshot.data()!['acceptedPolicy'] == true;
  }

  //ดึงชื่อผู้ใช้จาก Firebase
  Future<String> getName() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('caregiver')
        .doc(email)
        .get();
    return userDoc['name'];
  }

  Future<void> saveDataToFirestore(
      BuildContext context, String selectedDate, String content) async {
    try {
      await Firebase.initializeApp();
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // ดึง user email ที่ล็อกอินเข้าสู่ระบบ
      String? userEmail = FirebaseAuth.instance.currentUser?.email;

      if (userEmail != null) {
        // สร้าง document reference ใน collection caregiver > document user.email > collection writeDaily
        DocumentReference dailyRef = firestore
            .collection('caregiver')
            .doc(userEmail)
            .collection('writeDaily')
            .doc();

        // ข้อมูลที่ต้องการบันทึก
        Map<String, dynamic> data = {
          'date': selectedDate, // วันที่
          'content': content, // เนื้อหาบันทึก
          // เพิ่มข้อมูลอื่น ๆ ตามต้องการ
        };

        // บันทึกข้อมูลลงใน Firestore
        await dailyRef.set(data);

        // แสดงข้อความว่าบันทึกสำเร็จ
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('บันทึกสำเร็จ')));
      }
    } catch (error) {
      // แสดงข้อความว่ามีข้อผิดพลาดเกิดขึ้น
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาดในการบันทึก')));
    }
  }
}

void showEmailAlreadyInUseDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Email Already in Use'),
        content: Text(
            'The email address is already in use. Please use a different email.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

class UserData {
  final String email;
  final String username;
  final String uid;
  final String imageUrl;

  UserData({
    required this.email,
    required this.username,
    required this.uid,
    required this.imageUrl,
  });
}
