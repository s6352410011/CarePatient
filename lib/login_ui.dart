import 'package:care_patient/class/color.dart';
import 'package:care_patient/forgotPassword.dart';
import 'package:care_patient/Caregiver_Page/home_CaregiverUI.dart';
import 'package:care_patient/home_PatientUI.dart';
import 'package:care_patient/register.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:care_patient/class/AuthenticationService.dart';

class LoginUI extends StatefulWidget {
  const LoginUI({super.key});

  @override
  State<LoginUI> createState() => _LoginUIState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
int? _selectedOption = 0;

class _LoginUIState extends State<LoginUI> {
  final AuthenticationService _authenticationService = AuthenticationService();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
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
                    FadeInUp(
                      duration: Duration(milliseconds: 1900),
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Color.fromRGBO(143, 148, 251, 1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromRGBO(143, 148, 251, .2),
                              blurRadius: 20.0,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(1.0),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Color.fromRGBO(143, 148, 251, 1),
                                  ),
                                ),
                              ),
                              child: TextField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(1.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Password",
                                  hintStyle: TextStyle(color: Colors.grey[700]),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                          if (_emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty) {
                            // เรียกใช้งาน signInWithEmailPassword เมื่อทั้ง Email และ Password ไม่ว่าง
                            dynamic result = await AuthenticationService()
                                .signInWithEmailPassword(_emailController.text,
                                    _passwordController.text);
                            if (result != null) {
                              // การเข้าสู่ระบบสำเร็จ
                              print("Sign in successful");
                              // การเข้าสู่ระบบสำเร็จ ให้ตรวจสอบ _selectedOption เพื่อเปิดหน้าจอที่ถูกต้อง
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
                              // ไม่สามารถเข้าสู่ระบบได้
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
                            // แสดง AlertDialog เมื่อ Email หรือ Password ไม่ถูกต้อง
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
                          foregroundColor: AllColor.pr,
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
                          backgroundColor: Color.fromARGB(255, 55, 233, 180),
                          foregroundColor: Color.fromARGB(255, 136, 138, 137),
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
                      duration: Duration(milliseconds: 1800),
                      child: Text(
                        "— OR LOGIN WITH —",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: ElevatedButton(
                        onPressed: () async {
                          final bool isLoggedIn =
                              await _authenticationService.isLoggedIn();
                          if (!isLoggedIn) {
                            final User? user =
                                await _authenticationService.signInWithGoogle();
                            if (user != null) {
                              // Navigate to home screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeMainCareUI()),
                              );
                            }
                          } else {
                            // Navigate to home screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeMainCareUI()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 10),
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          backgroundColor: Colors.red, // สีพื้นหลังของปุ่ม
                          foregroundColor: Colors.white, // สีของข้อความบนปุ่ม
                          elevation: 5, // เงาของปุ่ม
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/g.png',
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                                width: 8), // ระยะห่างระหว่างไอคอนกับข้อความ
                            Text(
                              "Login with Google",
                              style: TextStyle(
                                color: Colors.black,
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
                      duration: Duration(milliseconds: 2000),
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
                              // color: Color.fromARGB(255, 39, 19, 48),
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
