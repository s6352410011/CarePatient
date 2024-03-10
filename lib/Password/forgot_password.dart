// ignore_for_file: unused_field
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart'; // นำเข้าไลบรารี animate_do

class ForgotPasswordUI extends StatefulWidget {
  const ForgotPasswordUI({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordUI> createState() => _ForgotPasswordUiState();
}

class _ForgotPasswordUiState extends State<ForgotPasswordUI> {
  String newPassword = '';
  String confirmPassword = '';

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
                      style: TextStyle(fontSize: 20), // เพิ่มขนาดของตัวอักษร
                      decoration: InputDecoration(
                        labelText: 'Email : ',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // ปรับแต่งสีของปุ่มและข้อความ
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: ElevatedButton(
                    onPressed: () {
                      // การกดปุ่ม Send OTP จะทำงานอย่างไรตามต้องการ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OTPUI()), // NextPage คือหน้าถัดไปที่ต้องการไป
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // สีของข้อความบนปุ่ม
                      minimumSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                    ),
                    child: Text(
                      'Send OTP',
                      style: TextStyle(
                        color: Colors.white, // สีของข้อความ
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // ตัวหนา
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
                      style: TextStyle(fontSize: 20), // เพิ่มขนาดของตัวอักษร
                      decoration: InputDecoration(
                        labelText: 'OTP : ',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // ปรับแต่งสีของปุ่มและข้อความ
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: ElevatedButton(
                    onPressed: () {
                      // การกดปุ่ม Send OTP จะทำงานอย่างไรตามต้องการ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NewPasswordUI()), // NextPage คือหน้าถัดไปที่ต้องการไป
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // สีของข้อความบนปุ่ม
                      minimumSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                    ),
                    child: Text(
                      'Verify OTP',
                      style: TextStyle(
                        color: Colors.white, // สีของข้อความ
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // ตัวหนา
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
  const NewPasswordUI({Key? key}) : super(key: key);

  @override
  State<NewPasswordUI> createState() => _NewPasswordUIState();
}

class _NewPasswordUIState extends State<NewPasswordUI> {
  String newPassword = '';
  String confirmPassword = '';
  bool _obscureTextNewPassword = true; // เพิ่มตัวแปรสำหรับรหัสผ่านใหม่
  bool _obscureTextConfirmPassword = true; // เพิ่มตัวแปรสำหรับการยืนยันรหัสผ่าน

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
                      style: TextStyle(fontSize: 20), // เพิ่มขนาดของตัวอักษร
                      decoration: InputDecoration(
                        labelText: 'Email : ',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(fontSize: 20),
                      obscureText:
                          _obscureTextNewPassword, // ใช้ค่าจากตัวแปร _obscureText เพื่อกำหนดการแสดงผลของรหัสผ่าน
                      decoration: InputDecoration(
                        labelText: 'New Password : ',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextNewPassword =
                                  !_obscureTextNewPassword; // เปลี่ยนค่าของ _obscureText เมื่อ icon ถูกคลิก
                            });
                          },
                          child: Icon(
                            _obscureTextNewPassword
                                ? Icons.visibility_off
                                : Icons
                                    .visibility, // แสดง icon ตามสถานะของ _obscureText
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
                ),
                SizedBox(height: 10),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                      style: TextStyle(fontSize: 20),
                      obscureText:
                          _obscureTextConfirmPassword, // ใช้ค่าจากตัวแปร _obscureText เพื่อกำหนดการแสดงผลของรหัสผ่าน
                      decoration: InputDecoration(
                        labelText: 'Confirm Password : ',
                        // ใส่เงื่อนไขการตรวจสอบ
                        errorText: confirmPassword.isNotEmpty &&
                                newPassword != confirmPassword
                            ? 'Passwords do not match'
                            : null,
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureTextConfirmPassword =
                                  !_obscureTextConfirmPassword; // เปลี่ยนค่าของ _obscureText เมื่อ icon ถูกคลิก
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
                      onChanged: (value) {
                        setState(() {
                          confirmPassword = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: 30),
                FadeInUp(
                  duration: Duration(milliseconds: 1900),
                  child: ElevatedButton(
                    onPressed: () {
                      // การกดปุ่ม Send OTP จะทำงานอย่างไรตามต้องการ
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginUI()), // LoginUI คือหน้าถัดไปที่ต้องการไป
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // สีของข้อความบนปุ่ม
                      minimumSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white, // สีของข้อความ
                        fontSize: 16,
                        fontWeight: FontWeight.bold, // ตัวหนา
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
