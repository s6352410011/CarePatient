import 'package:care_patient/Caregiver_Page/FormC_Page/f_work_ui.dart';
import 'package:care_patient/Caregiver_Page/FormC_Page/f_info_ui.dart';
import 'package:care_patient/Patient_Page/FormP_Page/f_info_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/Password_Page/forgot_password.dart';
import 'package:care_patient/Caregiver_Page/home_CaregiverUI.dart';
import 'package:care_patient/Patient_Page/home_PatientUI.dart';
import 'package:care_patient/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care_patient/class/AuthenticationService.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final AuthenticationService _authenticationService = AuthenticationService();
  bool _obscureTextPassword = true; // เพิ่มตัวแปรสำหรับรหัสผ่าน

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  int? _selectedOption = 0;
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  Future<void> checkLoggedIn() async {
    final bool isLoggedIn = await _authenticationService.isLoggedIn();
    if (isLoggedIn) {
      navigateToHome();
    }
  }

  Future<void> navigateToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeMainCareUI()),
    );
  }

  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isEmpty || !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 50),
              FadeInUp(
                duration: Duration(milliseconds: 1900),
                child: Image.asset(
                  'assets/images/logo_cp.png',
                  height: MediaQuery.of(context).size.height * 0.20,
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: <Widget>[
                          FadeInUp(
                            duration: Duration(milliseconds: 1900),
                            child: Container(
                              padding: EdgeInsets.all(1.0),
                              child: TextField(
                                keyboardType: TextInputType.emailAddress,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: 'Email : ',
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          FadeInUp(
                            duration: Duration(milliseconds: 1900),
                            child: Container(
                              padding: EdgeInsets.all(1.0),
                              child: TextFormField(
                                controller: _passwordController,
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
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Column(
                        children: [
                          Text(
                            'กรุณาเลือกประเภทเข้าใช้',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    'คนดูแล',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  leading: Radio(
                                    value: 0,
                                    groupValue: _selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedOption = value as int?;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    'ผู้ป่วย',
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                  leading: Radio(
                                    value: 1,
                                    groupValue: _selectedOption,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedOption = value as int?;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: ElevatedButton(
                        onPressed: () async {
                          final emailError =
                              validateEmail(_emailController.text);
                          if (emailError != null) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(emailError),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            dynamic result = await _authenticationService
                                .signInWithEmailPassword(_emailController.text,
                                    _passwordController.text);
                            if (result != null) {
                              print("Sign in successful");
                              // ตรวจสอบว่าผู้ใช้มีข้อมูล phoneNumber ในฐานข้อมูลหรือไม่
                              // โดยใช้ชื่อของ collection และ document ID ที่เหมาะสมของฐานข้อมูลของคุณ
                              DocumentSnapshot<
                                  Map<String,
                                      dynamic>> snapshot = await FirebaseFirestore
                                  .instance
                                  .collection('registerusers')
                                  .doc(result
                                      .uid) // ใช้ UID ของผู้ใช้เป็น Document ID
                                  .get();
                              if (snapshot.exists &&
                                  snapshot.data()!['phoneNumber'] != null) {
                                // ถ้ามี phoneNumber ในฐานข้อมูล
                                if (_selectedOption == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeMainCareUI(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeMainPatientUI(),
                                    ),
                                  );
                                }
                              } else {
                                // ถ้าไม่มี phoneNumber ในฐานข้อมูล
                                if (_selectedOption == 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CFormInfoUI(),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PFormInfoUI(),
                                    ),
                                  );
                                }
                              }
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(
                                      'Invalid email or password. Please try again.',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                    'Please enter both email and password.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 10),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: AllColor.pr,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
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
                      height: 10,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterUI(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 10),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: AllColor.sc,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
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
                      height: 20,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Text(
                        "— OR LOGIN WITH —",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: ElevatedButton(
                        onPressed: () async {
                          final bool isLoggedIn =
                              await _authenticationService.isLoggedIn();
                          if (!isLoggedIn) {
                            final user =
                                await _authenticationService.signInWithGoogle();
                            if (user != null) {
                              // Check if user selected an option
                              if (_selectedOption == 0) {
                                // Navigate to caregiver form page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CFormWorkUI(),
                                  ),
                                );
                              } else if (_selectedOption == 1) {
                                // Navigate to patient form page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PFormInfoUI(),
                                  ),
                                );
                              } else {
                                // If no option is selected, default to caregiver form page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CFormInfoUI(),
                                  ),
                                );
                              }
                            }
                          } else {
                            // Check if user selected an option
                            if (_selectedOption == 0) {
                              // Navigate to caregiver home page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeMainCareUI(),
                                ),
                              );
                            } else if (_selectedOption == 1) {
                              // Navigate to patient home page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeMainPatientUI(),
                                ),
                              );
                            } else {
                              // If no option is selected, default to caregiver home page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeMainCareUI(),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 10),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          backgroundColor: Colors.black,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.network(
                              'http://pngimg.com/uploads/google/google_PNG19635.png',
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "Login with Google",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
