import 'package:care_patient/class/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  User? chat() {
    return _auth.currentUser;
  }

  String? getCurrentUserID() {
    User? user = _auth.currentUser;
    return user?.uid;
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
            'email': user.email, // เพิ่มฟิลด์ email ลงในเอกสาร
            // เพิ่มฟิลด์อื่น ๆ ตามต้องการ
          });
        }

        // Set logged in status
        await _setLoggedIn(true);

        // Set user data locally
        UserData.email = user.email;
        UserData.username = user.displayName;
        UserData.uid = user.uid;
        UserData.imageUrl = user.photoURL;

        return user;
      }
    }
    return null;
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

  // Method สำหรับ SignIn **loging ด้วย เมลล์
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      UserData.uid = user?.uid;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
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
        await FirebaseFirestore.instance.collection('users').doc().get();

    return snapshot.exists && snapshot.data()!['phoneNumber'] != null;
  }

  //เช็ค Caregiver Policy
  Future<bool> checkCaregiverAcceptedPolicy(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('caregiver').doc().get();

    return snapshot.exists && snapshot.data()!['acceptedPolicy'] == true;
  }

  //เช็ค Patient Policy
  Future<bool> checkPatientAcceptedPolicy(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('patient').doc().get();

    return snapshot.exists && snapshot.data()!['acceptedPolicy'] == true;
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
