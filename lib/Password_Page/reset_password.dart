import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordUI extends StatefulWidget {
  @override
  _ResetPasswordUIState createState() => _ResetPasswordUIState();
}

class _ResetPasswordUIState extends State<ResetPasswordUI> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isResettingPassword = false;

  Future<void> _resetPassword() async {
    setState(() {
      _isResettingPassword = true;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      _showSuccessDialog("Password Reset Email Sent",
          "Please check your email to reset your password.");
    } catch (error) {
      _showErrorDialog("Error", error.toString());
    } finally {
      setState(() {
        _isResettingPassword = false;
      });
    }
  }

  void _showSuccessDialog(String title, String message) {
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

  void _showErrorDialog(String title, String message) {
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
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      controller: _emailController, // กำหนด controller
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
                    onPressed: _isResettingPassword ? null : _resetPassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // สีของปุ่ม
                      minimumSize: Size(200, 50), // กำหนดขนาดของปุ่ม
                    ),
                    child: _isResettingPassword
                        ? CircularProgressIndicator()
                        : Text(
                            'Reset Password',
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
