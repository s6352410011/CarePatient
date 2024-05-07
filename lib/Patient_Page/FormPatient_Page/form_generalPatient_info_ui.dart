import 'package:care_patient/Patient_Page/FormPatient_Page/form_HistoryMedical_ui.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:io';

// เรียกใช้ FirebaseAuth
FirebaseAuth auth = FirebaseAuth.instance;
// ดึงข้อมูลผู้ใช้ปัจจุบัน
User? user = auth.currentUser;

class PFormInfoUI extends StatefulWidget {
  const PFormInfoUI({Key? key}) : super(key: key);

  @override
  _PFormInfoUIState createState() => _PFormInfoUIState();
}

class _PFormInfoUIState extends State<PFormInfoUI> {
  // Variables to store user input
  String? _name = '';
  String? _gender = '';
  String? _selectedDate;
  String? _address = '';
  String? _phoneNumber = '';
  String? _email = '';
  String? _selectedFile = '';
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('patient');
  CollectionReference _usersCollection1 =
      FirebaseFirestore.instance.collection('users');
  @override
  void initState() {
    super.initState();
    // Fetch user email from Firebase Authentication
    _fetchUserEmail();
  }

  // Function to fetch user email from Firebase Authentication
  Future<void> _fetchUserEmail() async {
    // Get current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;
    // Check if user is not null
    if (user != null) {
      // Set the email to the _email variable
      setState(() {
        _email = user.email;
      });
    }
  }

  void _showDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.year,
    ).then((DateTime? pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
        });
      }
    });
  }

  Widget _buildDatePickerButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        _showDatePicker(context);
      },
      icon: Icon(Icons.calendar_today),
      tooltip: 'เลือกวัน/เดือน/ปีเกิด',
    );
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.path;
      });
    }
  }

  Future<void> clearUserData() async {
    UserData.email = null;
    UserData.username = null;
    UserData.uid = null;
    UserData.imageUrl = null;
  }

  final AuthenticationService _authenticationService = AuthenticationService();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // ทำงานที่ต้องการเมื่อผู้ใช้กดปุ่มย้อนกลับ
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("ยืนยัน"),
              content: Text("คุณต้องการออกจากระบบหรือไม่?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // ปิดหน้าต่างยืนยัน
                  },
                  child: Text("ยกเลิก"),
                ),
                TextButton(
                  onPressed: () async {
                    // ทำการเคลียร์ข้อมูลใน UserData และล้าง SharedPreferences ตามต้องการ
                    clearUserData();
                    await _authenticationService.signOut();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    // โหลดหน้า LoginUI ใหม่
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginUI()),
                    );
                  },
                  child: Text("ออกจากระบบ"),
                ),
              ],
            );
          },
        );
        return false; // ไม่อนุญาตให้กดปุ่มย้อนกลับได้โดยตรง
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'แบบฟอร์มลงทะเบียน',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
        ),
        body: Padding(
          padding: EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ข้อมูลทั่วไป',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'ชื่อ - นามสกุล',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                Text('เพศ', style: TextStyle(fontSize: 16)),
                Row(
                  children: [
                    Radio(
                      value: 'ชาย',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    Text('ชาย'),
                    Radio(
                      value: 'หญิง',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    Text('หญิง'),
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    _buildDatePickerButton(context),
                    SizedBox(width: 10),
                    Text(
                      'วันที่เกิด: ${_selectedDate ?? "ยังไม่ได้เลือก"}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _address = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'ที่อยู่',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _phoneNumber = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'เบอร์โทรศัพท์',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'แนบรูปภาพ : ',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result != null) {
                      setState(() {
                        // _selectedFile = result.files.single.path!;
                        _selectedFile =
                            _email!.substring(0, _email!.indexOf('@')) +
                                '_C.jpg';
                      });

                      // เรียกใช้ฟังก์ชันอัปโหลดไฟล์
                      await _uploadImage(File(_selectedFile!));
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('แจ้งเตือน'),
                            content: Text('คุณยังไม่ได้เลือกไฟล์รูปภาพ'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('ตกลง'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  icon: Icon(Icons.attach_file),
                  // label: Text('เลือกไฟล์ $_selectedFile'),
                  label: Text('เลือกไฟล์ '),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String? missingFields = '';

                      if (_name == null || _name == '') {
                        missingFields += 'ชื่อ - นามสกุล, ';
                      }
                      if (_gender == null || _gender == '') {
                        missingFields += 'เพศ, ';
                      }
                      if (_selectedDate == null || _selectedDate == '') {
                        missingFields += 'วันที่เกิด, ';
                      }
                      if (_address == null || _address == '') {
                        missingFields += 'ที่อยู่, ';
                      }
                      if (_phoneNumber == null || _phoneNumber == '') {
                        missingFields += 'เบอร์โทรศัพท์, ';
                      }
                      if (_selectedFile == null || _selectedFile == '') {
                        missingFields += 'รูปภาพ, ';
                      }
                      if (missingFields != '') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('แจ้งเตือน'),
                              content: Text(
                                  'กรุณากรอกข้อมูลให้ครบถ้วน: $missingFields'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('ตกลง'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        await firebase;
                        // ตรวจสอบว่ามีเอกสารใน _usersCollection1 ที่มี email เป็น user!.email หรือไม่
                        var documentSnapshot =
                            await _usersCollection1.doc(user!.email).get();
                        // ตรวจสอบว่ามีฟิลด์ name ในเอกสารหรือไม่
                        if (documentSnapshot.exists &&
                            documentSnapshot.data() is Map<String, dynamic> &&
                            (documentSnapshot.data() as Map<String, dynamic>)
                                .containsKey('name')) {
                          // ถ้ามีฟิลด์ name ในเอกสารอยู่แล้ว ให้ทำการอัปเดตข้อมูล
                          await _usersCollection1.doc(user!.email).update({
                            'name': _name,
                            'gender': _gender,
                            'birthDate': _selectedDate,
                            'address': _address,
                            'phoneNumber': _phoneNumber,
                            'imagePath': _selectedFile,
                          });
                        } else {
                          // ถ้าไม่มีฟิลด์ name ในเอกสาร ให้ทำการเพิ่มข้อมูล
                          await _usersCollection1.doc(user!.email).set({
                            'name': _name,
                            'gender': _gender,
                            'birthDate': _selectedDate,
                            'address': _address,
                            'phoneNumber': _phoneNumber,
                            'imagePath': _selectedFile,
                          });
                        }

                        // เพิ่มข้อมูลลงใน _usersCollection และทำการ navigation หลังจากที่เพิ่มข้อมูลเสร็จสิ้น
                        await _usersCollection.doc(user!.email).set({
                          'name': _name,
                          'gender': _gender,
                          'birthDate': _selectedDate,
                          'address': _address,
                          'phoneNumber': _phoneNumber,
                          'email': _email,
                          'imagePath': _selectedFile,
                        }).then((value) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PFormMedicalUI(),
                            ),
                          );
                        }).catchError((error) {
                          print('Failed to add user: $error');
                        });
                      }
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('ถัดไป'),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
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

// คำสั่งสำหรับอัปโหลดไฟล์รูปภาพไปยัง Firebase Storage
  Future<void> _uploadImage(File file) async {
    // ระบุ path ใน Firebase Storage ที่คุณต้องการจะบันทึกไฟล์
    String storagePath =
        'images/${_email!.substring(0, _email!.indexOf('@'))}_P.jpg';

    // อ้างอิง Firebase Storage instance
    final Reference storageReference =
        FirebaseStorage.instance.ref().child(storagePath);

    try {
      // อัปโหลดไฟล์ไปยัง Firebase Storage
      await storageReference.putFile(file);

      // หากต้องการ URL ของไฟล์ที่อัปโหลด เพื่อนำมาเก็บไว้ใน Firestore หรือใช้งานอื่น ๆ
      String downloadURL = await storageReference.getDownloadURL();

      // ทำสิ่งที่ต้องการกับ downloadURL ต่อไป
      // เช่น เก็บ downloadURL ลงใน Firestore
    } catch (e) {
      // หากเกิดข้อผิดพลาดในการอัปโหลด
      print('เกิดข้อผิดพลาดในการอัปโหลด: $e');
      // ทำสิ่งที่คุณต้องการเมื่อเกิดข้อผิดพลาด เช่น แสดงข้อความแจ้งเตือน
    }
  }
}
