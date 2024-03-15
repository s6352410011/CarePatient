import 'package:care_patient/Password_Page/forgot_password.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:email_validator/email_validator.dart';

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
  bool isValid = false;

  UserType selectedUserType = UserType.caregiver; // Default selected type
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
          // ตรวจสอบว่ามีผู้ใช้งานอีเมลนี้อยู่แล้วหรือไม่
          bool isExistingUser = await _checkExistingUser(email);
          if (!isExistingUser) {
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
          } else {
            _showAlertDialogSignUp("Email exists",
                "The email is already registered. Please use a different email.");
          }
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

  Future<bool> _checkExistingUser(String email) async {
    try {
      // ค้นหาผู้ใช้ที่ใช้อีเมลเดียวกันใน Firebase Firestore
      QuerySnapshot querySnapshot = await _usersCollection
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      // ถ้ามีผู้ใช้งานในระบบแล้ว
      if (querySnapshot.docs.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error checking existing user: $e');
      return false;
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

  void _checkEmailValidaty() {
    setState(() {
      isValid = EmailValidator.validate(_emailController.text.trim());
    });
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
                                child: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  onChanged: (_) {
                                    checkDataCompletion();
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Email : ',
                                    errorText:
                                        validateEmail(_emailController.text),
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
                              if (_passwordController.text.length >= 6) {
                                // Check email validity using EmailValidator
                                bool isEmailValid = EmailValidator.validate(
                                    _emailController.text.trim());
                                if (isEmailValid) {
                                  // Check if email exists
                                  bool isExistingUser =
                                      await _checkExistingUser(
                                          _emailController.text.trim());
                                  if (!isExistingUser) {
                                    // If email does not exist, proceed with registration
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
                                                Navigator.of(context).pop();
                                                // Proceed with registration - No need to call _signUp() here again
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginUI(),
                                                  ),
                                                );
                                              },
                                              child: Text("OK"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    // Call _signUp() here if needed, but in this case, it's not necessary
                                  } else {
                                    // If email exists, show alert
                                    _showAlertDialogSignUp("Email exists",
                                        "The email is already registered. Please use a different email.");
                                  }
                                } else {
                                  // If email is invalid, show alert
                                  _showAlertDialogSignUp("Invalid Email",
                                      "Please enter a valid email address.");
                                }
                              } else {
                                // If password length is less than 6 characters, show alert
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Password Length Error"),
                                      content: Text(
                                          "Password must be at least 6 characters long"),
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
                            } else if (!rememberMe) {
                              // If rememberMe is false, show alert
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
                              // If data is incomplete, show alert
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
}
