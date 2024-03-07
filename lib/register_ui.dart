// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/forgot_password_ui.dart'; // Import หน้า ForgotPasswordUI

enum UserType { caregiver, patient }

class RegisterUI extends StatefulWidget {
  @override
  _RegisterUIState createState() => _RegisterUIState();
}

class _RegisterUIState extends State<RegisterUI> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();
  bool isDataComplete = false;
  bool rememberMe = false;
  UserType selectedUserType = UserType.caregiver; // Default selected type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 150),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Positioned(
                        child: FadeInUp(
                          duration: Duration(milliseconds: 1800),
                          child: Container(
                            height: 300,
                            width: 350,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/logo_cp.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: DropdownButtonFormField(
                          value: selectedUserType,
                          items: [
                            DropdownMenuItem(
                              value: UserType.caregiver,
                              child: Text('Caregiver'),
                            ),
                            DropdownMenuItem(
                              value: UserType.patient,
                              child: Text('Patient'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              selectedUserType = value as UserType;
                            });
                          },
                          decoration: InputDecoration(
                            labelText: 'Select User Type',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
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
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(143, 148, 251, 1),
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: emailController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Email or Phone number",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color.fromRGBO(143, 148, 251, 1),
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller: passwordController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: confirmController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Confirm password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey[700],
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
                              color: Color.fromRGBO(143, 148, 251, 1),
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
                          activeColor: Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: ElevatedButton(
                          onPressed: () {
                            if (isDataComplete && rememberMe) {
                              // Show success message and navigate to LoginUI
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("เรียบร้อย"),
                                    content:
                                        Text("บันทึกการสมัครเรียบร้อยแล้ว"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
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
                              // Show alert if Remember Me is not checked
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("แจ้งเตือน!!"),
                                    content:
                                        Text("ยอมรับนโยบายความเป็นส่วนตัว"),
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
                              // Show alert if data is incomplete
                              showAlert1();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(200, 50),
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            backgroundColor: Color.fromARGB(255, 55, 233, 180),
                            foregroundColor: Color.fromARGB(255, 136, 138, 137),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: Color.fromARGB(255, 136, 226, 176),
                              width: 2,
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
                        height: 30,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 2000),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // Navigate to the login page
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
                                color: Color.fromARGB(255, 39, 19, 48),
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
                                text: "Have already an account?",
                                style: TextStyle(
                                  color: Colors.black, // ตั้งค่าสีดำ
                                ),
                                children: [
                                  TextSpan(
                                    text: " Login here",
                                    style: TextStyle(
                                      color: Color.fromRGBO(
                                          44, 146, 172, 1), // ตั้งค่าสีน้ำเงิน
                                      decoration: TextDecoration
                                          .underline, // เพิ่มเส้นขีดใต้
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  void checkDataCompletion() {
    setState(() {
      isDataComplete = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmController.text.isNotEmpty;
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
