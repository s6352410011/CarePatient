import 'package:care_patient/forgotPassword.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:care_patient/class/AuthenticationService.dart';

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

  bool isDataComplete = false;
  bool rememberMe = false;
  UserType selectedUserType = UserType.caregiver; // Default selected type
  final AuthenticationService _authenticationService = AuthenticationService();

  void _signUp() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // ตรวจสอบว่า Email, Password, และ Confirm Password ไม่ว่าง
    if (email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        dynamic result = await _authenticationService.signUpWithEmailPassword(
            email, password);
        if (result != null) {
        } else {
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
                      FadeInUp(
                        duration: Duration(milliseconds: 1800),
                        child: Image.asset(
                          'assets/images/logo_cp.png',
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FadeInUp(
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
                              controller: _emailController,
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
                              controller: _passwordController,
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
                              controller: _confirmPasswordController,
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
                // FadeInUp(
                //   duration: Duration(milliseconds: 1800),
                //   child: ElevatedButton(
                //     onPressed: _signUp,
                //     child: Text("Register"),
                //   ),
                // ),
                FadeInUp(
                  duration: Duration(milliseconds: 1800),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (isDataComplete && rememberMe) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Success"),
                              content:
                                  Text("Registration completed successfully"),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    _signUp();
                                    // After successful registration, navigate to the Login UI
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginUI()),
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
                              title: Text("Alert"),
                              content: Text("Please accept the privacy policy"),
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
                    child: Text("Register"),
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
                                decoration:
                                    TextDecoration.underline, // เพิ่มเส้นขีดใต้
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
