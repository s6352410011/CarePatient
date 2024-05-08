import 'package:care_patient/Caregiver_Page/formCaregiverInfo_ui.dart';
import 'package:care_patient/Caregiver_Page/home_caregiver_ui.dart';
import 'package:care_patient/Patient_Page/FormPatient_Page/form_HistoryMedical_ui.dart';
import 'package:care_patient/Patient_Page/FormPatient_Page/formPatientInfo_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/Password_Page/forgot_password.dart';
import 'package:care_patient/Caregiver_Page/main_caregiverUI.dart';
import 'package:care_patient/Patient_Page/main_PatientUI.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:care_patient/register.dart';
import 'package:care_patient/test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
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
    setState(() {});
    super.initState();
    clearUserData();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      clearUserData();
      checkLoggedIn(context);
    });
  }

  Future<void> clearUserData() async {
    UserData.email = null;
    UserData.username = null;
    UserData.uid = null;
    UserData.imageUrl = null;
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    final bool isLoggedIn = await _authenticationService.isLoggedIn();
    if (isLoggedIn) {
      navigateToHome(context);
    }
  }

  Future<void> navigateToHome(BuildContext context) async {
    if (_selectedOption == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeMainCareUI()),
      );
    } else if (_selectedOption == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeMainPatientUI()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginUI()),
      );
    }
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
                          _loginWithEmailPassword();
                          // // Validate email
                          // final emailError =
                          //     validateEmail(_emailController.text);
                          // if (emailError != null) {
                          //   print("Email Error: $emailError");
                          //   // Show error dialog
                          //   await showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: Text('Error'),
                          //         content: Text(emailError),
                          //         actions: [
                          //           TextButton(
                          //             onPressed: () {
                          //               Navigator.pop(context);
                          //             },
                          //             child: Text('OK'),
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          //   return;
                          // }

                          // // Check email and password
                          // if (_emailController.text.isNotEmpty &&
                          //     _passwordController.text.isNotEmpty) {
                          //   dynamic user = await _authenticationService
                          //       .signInWithEmailPassword(_emailController.text,
                          //           _passwordController.text);
                          //   if (user != null) {
                          //     print("Sign in successful");

                          //     if (_selectedOption == 0) {
                          //       bool generalPhoneNumberExists =
                          //           await _authenticationService
                          //               .checkUserPhoneNumberExists(
                          //                   user.email!);
                          //       bool caregiverAcceptedPolicy =
                          //           await _authenticationService
                          //               .checkCaregiverAcceptedPolicy(
                          //                   user.email!);
                          //       bool patientAcceptedPolicy =
                          //           await _authenticationService
                          //               .checkPatientAcceptedPolicy(
                          //                   user.email!);

                          //       if (!generalPhoneNumberExists) {
                          //         print("Redirecting to CFormInfoUI");
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('แจ้งเตือน'),
                          //               content: Text(
                          //                   'รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.pop(context);
                          //                     Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             CFormInfoUI(),
                          //                       ),
                          //                     );
                          //                   },
                          //                   child: Text('แบบฟอร์ม'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       } else if (caregiverAcceptedPolicy &&
                          //           patientAcceptedPolicy) {
                          //         print("Redirecting to HomeMainCareUI");
                          //         Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => HomeMainCareUI(),
                          //           ),
                          //         );
                          //       } else if (caregiverAcceptedPolicy) {
                          //         print("Redirecting to CFormWorkUI");
                          //         Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => CFormWorkUI(),
                          //           ),
                          //         );
                          //       } else {
                          //         print("Redirecting to CFormInfoUI");
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('แจ้งเตือน'),
                          //               content: Text(
                          //                   'รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.pop(context);
                          //                     Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             CFormInfoUI(),
                          //                       ),
                          //                     );
                          //                   },
                          //                   child: Text('แบบฟอร์ม'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       }
                          //     } else if (_selectedOption == 1) {
                          //       bool generalPhoneNumberExists =
                          //           await _authenticationService
                          //               .checkUserPhoneNumberExists(
                          //                   user.email!);
                          //       bool patientAcceptedPolicy =
                          //           await _authenticationService
                          //               .checkPatientAcceptedPolicy(
                          //                   user.email!);

                          //       if (!generalPhoneNumberExists) {
                          //         print("Redirecting to PFormInfoUI");
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('แจ้งเตือน'),
                          //               content: Text(
                          //                   'รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.pop(context);
                          //                     Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             PFormInfoUI(),
                          //                       ),
                          //                     );
                          //                   },
                          //                   child: Text('แบบฟอร์ม'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       } else if (!patientAcceptedPolicy) {
                          //         print("Redirecting to PFormMedicalUI");
                          //         showDialog(
                          //           context: context,
                          //           builder: (BuildContext context) {
                          //             return AlertDialog(
                          //               title: Text('แจ้งเตือน'),
                          //               content: Text(
                          //                   'รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
                          //               actions: <Widget>[
                          //                 TextButton(
                          //                   onPressed: () {
                          //                     Navigator.pop(context);
                          //                     Navigator.push(
                          //                       context,
                          //                       MaterialPageRoute(
                          //                         builder: (context) =>
                          //                             PFormMedicalUI(),
                          //                       ),
                          //                     );
                          //                   },
                          //                   child: Text('แบบฟอร์ม'),
                          //                 ),
                          //               ],
                          //             );
                          //           },
                          //         );
                          //       } else {
                          //         print("Redirecting to HomeMainPatientUI");
                          //         Navigator.pushReplacement(
                          //           context,
                          //           MaterialPageRoute(
                          //             builder: (context) => HomeMainPatientUI(),
                          //           ),
                          //         );
                          //       }
                          //     }
                          //   } else {
                          //     print(
                          //         "Sign in failed: Invalid email or password");
                          //     await showDialog(
                          //       context: context,
                          //       builder: (BuildContext context) {
                          //         return AlertDialog(
                          //           title: Text('Error'),
                          //           content: Text(
                          //               'Invalid email or password. Please try again.'),
                          //           actions: [
                          //             TextButton(
                          //               onPressed: () {
                          //                 Navigator.pop(context);
                          //               },
                          //               child: Text('OK'),
                          //             ),
                          //           ],
                          //         );
                          //       },
                          //     );
                          //   }
                          // } else {
                          //   print(
                          //       "Sign in failed: Please enter both email and password");
                          //   await showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: Text('Error'),
                          //         content: Text(
                          //             'Please enter both email and password.'),
                          //         actions: [
                          //           TextButton(
                          //             onPressed: () {
                          //               Navigator.pop(context);
                          //             },
                          //             child: Text('OK'),
                          //           ),
                          //         ],
                          //       );
                          //     },
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 10),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: AllColor.Primary,
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
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegisterUI(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(200, 10),
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          backgroundColor: AllColor.Secondary,
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
                                bool generalPhoneNumberExists =
                                    await _authenticationService
                                        .checkUserPhoneNumberExists(
                                            user.email!);
                                bool caregiverAcceptedPolicy =
                                    await _authenticationService
                                        .checkCaregiverAcceptedPolicy(
                                            user.email!);

                                if (!generalPhoneNumberExists) {
                                  // ไม่พบหมายเลขโทรศัพท์ในระบบ นำผู้ใช้ไปยังหน้า CFormInfoUI
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CFormInfoUI(),
                                    ),
                                  );
                                } else if (!caregiverAcceptedPolicy) {
                                  // หมายเลขโทรศัพท์มีอยู่แต่ผู้ดูแลรับผิดชอบยังไม่ยอมรับนโยบาย นำผู้ใช้ไปยังหน้า CFormWorkUI
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CFormWorkUI(),
                                    ),
                                  );
                                } else {
                                  // ผู้ใช้มีทั้งหมดหมายเลขโทรศัพท์และยอมรับนโยบาย นำผู้ใช้ไปยังหน้า HomeMainCareUI
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeMainCareUI(),
                                    ),
                                  );
                                }
                              } else if (_selectedOption == 1) {
                                bool generalPhoneNumberExists =
                                    await _authenticationService
                                        .checkUserPhoneNumberExists(
                                            user.email!);
                                bool patientAcceptedPolicy =
                                    await _authenticationService
                                        .checkPatientAcceptedPolicy(
                                            user.email!);

                                if (!generalPhoneNumberExists) {
                                  // ไม่พบหมายเลขโทรศัพท์ในระบบ นำผู้ใช้ไปยังหน้า PFormInfoUI
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PFormInfoUI(),
                                    ),
                                  );
                                } else if (!patientAcceptedPolicy) {
                                  // หมายเลขโทรศัพท์มีอยู่แต่ผู้ป่วยยังไม่ยอมรับนโยบาย นำผู้ใช้ไปยังหน้า PFormMedicalUI
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const PFormMedicalUI(),
                                    ),
                                  );
                                } else {
                                  // ผู้ใช้มีทั้งหมดหมายเลขโทรศัพท์และยอมรับนโยบาย นำผู้ใช้ไปยังหน้า HomeMainPatientUI
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeMainPatientUI(),
                                    ),
                                  );
                                }
                              }
                            }
                          } else {
                            // ผู้ใช้ลงชื่อเข้าใช้แล้ว นำผู้ใช้ไปยังหน้า HomeMainCareUI หรือ HomeMainPatientUI ตามตัวเลือกที่เลือก
                            if (_selectedOption == 0) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeMainCareUI(),
                                ),
                              );
                            } else if (_selectedOption == 1) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeMainPatientUI(),
                                ),
                              );
                            } else {
                              // กรณีไม่มีตัวเลือกที่ถูกต้อง นำผู้ใช้ไปยังหน้า LoginUI
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginUI(),
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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForgotPasswordUI(),
                              ),
                            );
                          },
                          child: Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: AllColor.Primary,
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

  Future<void> _loginWithEmailPassword() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      final emailError = validateEmail(_emailController.text);
      if (emailError != null) {
        print("Email Error: $emailError");
        // Show error dialog
        await showDialog(
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
      if (userCredential.user != null) {
        // Login success, now check phoneNumber and caregiver policy
        bool phoneNumberExists =
            await checkUserPhoneNumberExists(userCredential.user!.email!);
        bool caregiverAcceptedPolicy =
            await checkCaregiverAcceptedPolicy(userCredential.user!.email!);
        bool patientrAcceptedPolicy =
            await checkPatientAcceptedPolicy(userCredential.user!.email!);
        if (_selectedOption == 0) {
          if (!phoneNumberExists) {
            // No phone number, navigate to CFormInfoUI
            print("Redirecting to CFormInfoUI");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('แจ้งเตือน'),
                  content: Text(
                      'รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // เพิ่มโค้ดที่นำผู้ใช้ไปยังหน้า Form ที่ต้องการ
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CFormInfoUI(),
                          ),
                        );
                      },
                      child: Text('แบบฟอร์ม'),
                    ),
                  ],
                );
              },
            );
          } else if (!caregiverAcceptedPolicy) {
            // Phone number exists but caregiver has not accepted policy, navigate to CFormWorkUI
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => CFormWorkUI()),
            );
          } else {
            // Both phone number and caregiver policy accepted, navigate to HomeMainCareUI
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeMainCareUI()),
            );
          }
        } else if (_selectedOption == 1) {
          if (!phoneNumberExists) {
            // No phone number, navigate to CFormInfoUI
            print("Redirecting to CFormInfoUI");
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('แจ้งเตือน'),
                  content: Text(
                      'รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // เพิ่มโค้ดที่นำผู้ใช้ไปยังหน้า Form ที่ต้องการ
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PFormInfoUI(),
                          ),
                        );
                      },
                      child: Text('แบบฟอร์ม'),
                    ),
                  ],
                );
              },
            );
          } else if (!patientrAcceptedPolicy) {
            // Phone number exists but caregiver has not accepted policy, navigate to CFormWorkUI
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PFormInfoUI()),
            );
          } else {
            // Both phone number and caregiver policy accepted, navigate to HomeMainCareUI
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeMainPatientUI()),
            );
          }
        } else {
          print("Sign in failed: Invalid email or password");
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
      }
    } catch (e) {
      // Error occurred during login, show error message
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text(e.toString()),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<bool> checkUserPhoneNumberExists(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(email).get();

    return snapshot.exists && snapshot.data()!['phoneNumber'] != null;
  }

  Future<bool> checkCaregiverAcceptedPolicy(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('caregiver')
        .doc(email)
        .get();

    return snapshot.exists && snapshot.data()!['acceptedPolicy'] == true;
  }

  Future<bool> checkPatientAcceptedPolicy(String email) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('patient').doc(email).get();

    return snapshot.exists && snapshot.data()!['acceptedPolicy'] == true;
  }
}

class DialogForms {
  static void showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('แจ้งเตือน'),
          content: Text('รบกวนกรอกแบบฟอร์มเพื่อลงทะเบียนการรับงานและว่าจ้าง'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('แบบฟอร์ม'),
            ),
          ],
        );
      },
    );
  }
}
