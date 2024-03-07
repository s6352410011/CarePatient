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
        await _setLoggedIn(true);
      }

      return user;
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await _setLoggedIn(false);
  }

  Future<void> _setLoggedIn(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', value);
  }

  Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  // Method สำหรับ SignUp
  Future signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Method สำหรับ SignIn
  Future signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
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

  // Future<void> signUpWithEmailPassword(String email, String password) async {
  //   try {
  //     // ตรวจสอบว่ามีอีเมลนี้ในระบบหรือไม่
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);
  //     // หากสร้างบัญชีผู้ใช้สำเร็จ
  //     // คุณสามารถนำทางไปหน้าต่าง ๆ ตามต้องการได้
  //   } catch (e) {
  //     // หากเกิดข้อผิดพลาด
  //     if (e is FirebaseAuthException) {
  //       // หากมีอีเมลนี้ในระบบแล้ว
  //       if (e.code == 'email-already-in-use') {
  //         print('Email is already in use');
  //         // แสดงข้อความแจ้งเตือนหรือการจัดการข้อผิดพลาดเพิ่มเติมได้ที่นี่
  //       } else {
  //         print('Error signing up: ${e.message}');
  //       }
  //     } else {
  //       print('Error signing up: $e');
  //     }
  //   }
  // }

  // Future<void> registerWithEmailAndPassword(
  //     String email, String password, String displayName) async {
  //   try {
  //     // สร้างบัญชีผู้ใช้ใน Firebase Authentication
  //     UserCredential userCredential = await _auth
  //         .createUserWithEmailAndPassword(email: email, password: password);

  //     // บันทึกข้อมูลผู้ใช้ลงใน Cloud Firestore
  //     await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'email': email,
  //       'displayName': displayName,
  //       // เพิ่มข้อมูลอื่น ๆ ตามต้องการ
  //     });

  //     // หากลงทะเบียนสำเร็จ คุณสามารถทำการนำทางไปหน้าต่าง ๆ ตามต้องการได้
  //   } catch (e) {
  //     print('Error registering: $e');
  //   }
  // }
  // Future<String?> signUpWithEmailPassword(String email, String password) async {
  //   try {
  //     // Check if the email already exists in Firestore
  //     bool emailExists = await _checkIfEmailExists(email);
  //     if (emailExists) {
  //       return 'Email is already in use';
  //     }

  //     // Create user with email and password
  //     UserCredential userCredential =
  //         await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     // Add user data to Firestore
  //     await _firestore.collection('users').doc(userCredential.user!.uid).set({
  //       'email': email,
  //       // Add other user data as needed
  //     });

  //     return null; // Sign up successful
  //   } catch (e) {
  //     print('Error signing up: $e');
  //     return 'An error occurred, please try again later';
  //   }
  // }

  Future<bool> _checkIfEmailExists(String email) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
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
