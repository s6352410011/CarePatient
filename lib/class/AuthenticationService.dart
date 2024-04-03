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
            FirebaseFirestore.instance.collection('forms').doc(user.email);
        final userDocSnapshot = await userDoc.get();

        if (!userDocSnapshot.exists) {
          // If the user does not exist, add their data to Firestore
          await userDoc.set({
            // Add other data you want to store about the user
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

  // Method สำหรับ SignUp **register
  Future signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      UserData.uid = user?.uid;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
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




// class RegisteredUsersList extends StatefulWidget {
//   @override
//   _RegisteredUsersListState createState() => _RegisteredUsersListState();
// }

// class _RegisteredUsersListState extends State<RegisteredUsersList> {
//   List<User?> _registeredUsers = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadRegisteredUsers();
//   }

//   Future<void> _loadRegisteredUsers() async {
//     List<User?> users = FirebaseAuth.instance.currentUser != null
//         ? [FirebaseAuth.instance.currentUser]
//         : [];

//     setState(() {
//       _registeredUsers = users;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Registered Users'),
//       ),
//       body: ListView.builder(
//         itemCount: _registeredUsers.length,
//         itemBuilder: (context, index) {
//           User? user = _registeredUsers[index];
//           return ListTile(
//             title: Text(user?.email ?? 'Unknown'),
//             subtitle: Text(user?.uid ?? ''),
//             // Add more user information if needed
//           );
//         },
//       ),
//     );
//   }
// }