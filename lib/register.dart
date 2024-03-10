import 'package:care_patient/Password_Page/forgot_password.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

enum UserType { caregiver, patient }

class RegisterUI extends StatefulWidget {
  const RegisterUI({super.key});

  @override
  State<RegisterUI> createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureTextPassword = true; // เพิ่มตัวแปรสำหรับรหัสผ่าน
  bool _obscureTextConfirmPassword = true; // เพิ่มตัวแปรสำหรับการยืนยันรหัสผ่าน

  bool isDataComplete = false;
  bool rememberMe = false;
  UserType selectedUserType = UserType.caregiver; // Default selected type
  final AuthenticationService _authenticationService = AuthenticationService();
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('registerusers');

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // ตรวจสอบว่า Email, Password, และ Confirm Password ไม่ว่าง
    if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        try {
          // สร้างผู้ใช้ใน Firebase Authentication
          UserCredential userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          // เพิ่มข้อมูลผู้ใช้ลงใน Firebase Firestore
          await _usersCollection.doc(userCredential.user!.uid).set({
            'email': email,
            'password': password,
          });

          print('User registered successfully: ${userCredential.user!.uid}');
        } catch (e) {
          print('Error registering user: $e');
          _showAlertDialogSignUp(
              "Sign up failed", "Unable to sign up. Please try again.");
        }
      } else {
        _showAlertDialogSignUp(
            "Password Mismatch", "Password and Confirm Password do not match");
      }
    } else {
      _showAlertDialogSignUp("Missing Information",
          "Please enter email, password, and confirm password");
    }
  }

  void _showAlertDialogSignUp(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  @override
  void initState() {
    super.initState();
    initializeFirebase();
  }

  Future<void> initializeFirebase() async {
    try {
      await Firebase.initializeApp();
      print("Firebase initialized");
    } catch (e) {
      print("Error initializing Firebase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FadeInUp(
                              duration: Duration(milliseconds: 1800),
                              child: Image.asset(
                                'assets/images/logo_cp.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _emailController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email : ',
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _passwordController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  obscureText: _obscureTextPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Password : ',
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureTextPassword =
                                              !_obscureTextPassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscureTextPassword
                                            ? Icons.visibility_off
                                            : Icons
                                                .visibility, // แสดง icon ตามสถานะของ _obscureTextPassword
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  obscureText: _obscureTextConfirmPassword,
                                  decoration: InputDecoration(
                                    labelText: 'Confirm Password : ',
                                    // เพิ่มเงื่อนไขการตรวจสอบและข้อความแจ้งเมื่อรหัสผ่านไม่ตรงกัน
                                    errorText: _confirmPasswordController
                                                .text.isNotEmpty &&
                                            _passwordController.text !=
                                                _confirmPasswordController.text
                                        ? 'Passwords do not match'
                                        : null,
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureTextConfirmPassword =
                                              !_obscureTextConfirmPassword;
                                        });
                                      },
                                      child: Icon(
                                        _obscureTextConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons
                                                .visibility, // แสดง icon ตามสถานะของ _obscureText
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: CheckboxListTile(
                          title: Text(
                            'ยอมรับนโยบายความเป็นส่วนตัว',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          value: rememberMe,
                          onChanged: (value) {
                            // Update the state of rememberMe when the checkbox is changed
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: AllColor.sc,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (isDataComplete && rememberMe) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("สำเร็จเรียบร้อย"),
                                    content: Text(
                                        "ทำการมัครให้ให้ท่านเสร็จเรียบร้อยแล้วครับ/ค่ะ"),
                                    actions: [
                                      TextButton(
                                        onPressed: () async {
                                          _signUp();
                                          // After successful registration, navigate to the Login UI
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => LoginUI(),
                                            ),
                                          );
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (!rememberMe) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("แจ้งเตือน"),
                                    content: Text(
                                        "โปรดกดเช็คในช่องยอมรับนโยบายความเป็นส่วนตัวด้วยครับ/ค่ะ"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text("OK"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showAlert1();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AllColor.sc, // สีปุ่ม
                            fixedSize: Size(200, 50),
                          ),
                          child: Center(
                            child: Text(
                              "Register",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPasswordUI(),
                                ),
                              );
                            },
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: AllColor.pr,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 150,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the login page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginUI(),
                                ),
                              );
                            },
                            child: Text.rich(
                              TextSpan(
                                text: "Have already an account?  ",
                                style: TextStyle(
                                    color: Colors.black, // set black color
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: " Login here",
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          44, 146, 172, 1), // set blue color
                                      decoration: TextDecoration
                                          .underline, // add underline
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void checkDataCompletion() {
    setState(() {
      isDataComplete = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty;
    });
  }

  void showAlert1() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("แจ้งเตือน"),
          content: Text("โปรดใส่ข้อมูลให้ครบถ้วน"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
