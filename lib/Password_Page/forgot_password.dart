// ignore_for_file: unused_field
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // นำเข้าไลบรารี animate_do
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordUI extends StatefulWidget {
  const ForgotPasswordUI({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordUI> createState() => _ForgotPasswordUiState();
}

class _ForgotPasswordUiState extends State<ForgotPasswordUI> {
  final TextEditingController emailController =
      TextEditingController(); // เพิ่ม TextEditingController เพื่อรับค่าอีเมล

  void sendOTP(BuildContext context) async {
    String email = emailController.text; // นำค่าที่รับมาจาก TextField ไปใช้งาน

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.sendPasswordResetEmail(email: email);

      Fluttertoast.showToast(
          msg: "รหัส OTP ถูกส่งไปยังอีเมลของคุณแล้ว",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OTPUI(email: email)), // ส่งค่า email ไปยังหน้า OTPUI
      );
    } catch (e) {
      print("เกิดข้อผิดพลาดในการส่งรหัส OTP: $e");
      Fluttertoast.showToast(
          msg: "เกิดข้อผิดพลาดในการส่งรหัส OTP",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: Image.asset(
                    'assets/images/logo_cp.png',
                    height: MediaQuery.of(context).size.height * 0.30,
                  ),
                ),
                SizedBox(height: 50),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller:
                          emailController, // กำหนด controller ให้กับ TextField
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'Email : ',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: ElevatedButton(
                    onPressed: () {
                      sendOTP(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginUI(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Send OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: " Login here",
                              style: TextStyle(
                                color: Color.fromRGBO(44, 146, 172, 1),
                                decoration: TextDecoration.underline,
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
}

class OTPUI extends StatelessWidget {
  final String email;

  OTPUI({required this.email});

  final TextEditingController otpController = TextEditingController();

  void verifyOTP(BuildContext context) {
    String otp = otpController.text;

    if (otp == "803451") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NewPasswordUI(email: email)),
      );
    } else {
      Fluttertoast.showToast(
          msg: "รหัส OTP ไม่ถูกต้อง",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: Image.asset(
                    'assets/images/logo_cp.png',
                    height: MediaQuery.of(context).size.height * 0.30,
                  ),
                ),
                SizedBox(height: 50),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      controller: otpController,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        labelText: 'OTP : ',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: ElevatedButton(
                    onPressed: () {
                      verifyOTP(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: Size(200, 50),
                    ),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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
}

class NewPasswordUI extends StatefulWidget {
  final String email; // เพิ่มตัวแปร email เพื่อรับค่าอีเมล

  const NewPasswordUI({Key? key, required this.email})
      : super(key: key); // สร้าง constructor รับค่า email

  @override
  State<NewPasswordUI> createState() => _NewPasswordUIState();
}

class _NewPasswordUIState extends State<NewPasswordUI> {
  String newPassword = '';
  String confirmPassword = '';
  bool _obscureTextNewPassword = true;
  bool _obscureTextConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                Image.asset(
                  'assets/images/logo_cp.png',
                  height: MediaQuery.of(context).size.height * 0.30,
                ),
                SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      labelText:
                          'Email : ${widget.email}', // แสดงค่า email ที่รับมา
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    obscureText: _obscureTextNewPassword,
                    decoration: InputDecoration(
                      labelText: 'New Password : ',
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscureTextNewPassword = !_obscureTextNewPassword;
                          });
                        },
                        child: Icon(
                          _obscureTextNewPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        newPassword = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    style: TextStyle(fontSize: 20),
                    obscureText: _obscureTextConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password : ',
                      errorText: confirmPassword.isNotEmpty &&
                              newPassword != confirmPassword
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
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (newPassword == confirmPassword) {
                      Fluttertoast.showToast(
                          msg: "รหัสผ่านถูกเปลี่ยนแล้ว",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.pop(context); // กลับไปยังหน้าก่อนหน้า
                    } else {
                      Fluttertoast.showToast(
                          msg: "รหัสผ่านไม่ตรงกัน",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(200, 50),
                  ),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
}
