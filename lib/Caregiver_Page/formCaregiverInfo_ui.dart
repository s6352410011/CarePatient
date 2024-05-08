import 'package:care_patient/Caregiver_Page/main_caregiverUI.dart';
import 'package:care_patient/class/AuthenticationService.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/class/user_data.dart';
import 'package:care_patient/login_ui.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;

class CFormInfoUI extends StatefulWidget {
  const CFormInfoUI({Key? key}) : super(key: key);

  @override
  _CFormInfoUIState createState() => _CFormInfoUIState();
}

class _CFormInfoUIState extends State<CFormInfoUI> {
  String? _name = '';
  String? _gender = '';
  String? _selectedDate;
  String? _address = '';
  String? _phoneNumber = '';
  String? _email = '';
  String? _selectedFile = '';
  final Future<FirebaseApp> firebase = Firebase.initializeApp();
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('caregiver');
  CollectionReference _usersCollection1 =
      FirebaseFirestore.instance.collection('users');
  CollectionReference _usersCollection2 =
      FirebaseFirestore.instance.collection('patient');

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = pickedFile.path;
      });
    }
  }

  Future<void> _uploadImage(File file) async {
    // ระบุ path ใน Firebase Storage ที่คุณต้องการจะบันทึกไฟล์
    String storagePath =
        'images/${_email!.substring(0, _email!.indexOf('@'))}_Patient.jpg';

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
          foregroundColor: AllColor.TextPrimary,
          backgroundColor: AllColor.Primary_C,
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
                      value: 'M',
                      groupValue: _gender,
                      onChanged: (value) {
                        setState(() {
                          _gender = value.toString();
                        });
                      },
                    ),
                    Text('ชาย'),
                    Radio(
                      value: 'F',
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
                  onPressed: () {
                    FilePicker.platform
                        .pickFiles()
                        .then((FilePickerResult? result) {
                      if (result != null) {
                        setState(() {
                          _selectedFile = result.files.single.path!;
                        });

                        // เรียกใช้งาน _uploadImage โดยไม่รอการอัปโหลดเสร็จสิ้น
                        _uploadImage(File(_selectedFile!)).then((_) {
                          // ทำตามสิ่งที่ต้องการหลังจากอัปโหลดเสร็จสิ้น
                          print('อัปโหลดไฟล์เสร็จสิ้น');
                        }).catchError((error) {
                          print('เกิดข้อผิดพลาดในการอัปโหลด: $error');
                          // ทำสิ่งที่คุณต้องการเมื่อเกิดข้อผิดพลาด
                        });
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
                    });
                  },
                  icon: Icon(Icons.attach_file),
                  label: Text(
                      'เลือกไฟล์ ${_selectedFile != null ? _selectedFile!.split('/').last : ""}'), // แสดงชื่อไฟล์ที่เลือก
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AllColor.TextPrimary,
                    backgroundColor: AllColor.Primary,
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
                        await _usersCollection2.doc(user!.email).set({
                          'email': _email,
                          'name': _name,
                          'gender': _gender,
                          'birthDate': _selectedDate,
                          'address': _address,
                          'phoneNumber': _phoneNumber,
                          'imagePath': _selectedFile,
                        });
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
                              builder: (context) => CFormWorkUI(),
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
                      foregroundColor: AllColor.TextPrimary,
                      backgroundColor: AllColor.Secondary_C,
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
}

class CFormWorkUI extends StatefulWidget {
  const CFormWorkUI({Key? key}) : super(key: key);

  @override
  _CFormWorkUIState createState() => _CFormWorkUIState();
}

class _CFormWorkUIState extends State<CFormWorkUI> {
  late FirebaseAuth auth; // Declare FirebaseAuth variable

  String _relatedSkills = ''; // ทักษะและความสามารถที่เกี่ยวข้อง
  String _specificSkills = ''; // ความถนัดและความสามารถเฉพาะ
  String _careExperience = ''; // ประสบการณ์การดูแล
  String _workArea = ''; // เขตที่คุณสามารถไปดูแล
  String _rateMoney = ''; // เขตที่คุณสามารถไปดูแล
  bool _acceptedPolicy = false;
  User? user; // Declare User variable
  CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('caregiver');

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance; // Initialize FirebaseAuth inside initState()
    user = auth.currentUser; // Assign the current user to the user variable
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แบบฟอร์มลงทะเบียน'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ประวัติการทำงาน',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _relatedSkills = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ทักษะและความสามารถที่เกี่ยวข้อง',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _specificSkills = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ความถนัดและความสามารถเฉพาะ',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _careExperience = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'ประสบการณ์การดูแล',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                onChanged: (value) {
                  setState(() {
                    _workArea = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'เขตที่คุณสามารถไปดูแล',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (value) {
                  setState(() {
                    _rateMoney = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'เรทเงินที่ต้องการ',
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // กำหนดรูปร่างขอบเส้น
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    String? missingFields = '';
                    if (_careExperience == null || _careExperience == '') {
                      missingFields += 'ประสบการณ์, ';
                    }
                    if (_relatedSkills == null || _relatedSkills == '') {
                      missingFields += 'ทักษะความสามารถ, ';
                    }
                    if (_specificSkills == null || _specificSkills == '') {
                      missingFields += 'ความถนัด, ';
                    }
                    if (_workArea == null || _workArea == '') {
                      missingFields += 'เขตที่ดูแล, ';
                    }
                    if (_rateMoney == null || _rateMoney == '') {
                      missingFields += 'เรทเงินที่ต้องการ, ';
                    }
                    if (missingFields != '') {
                      // แสดงข้อความแจ้งเตือนถ้ามีข้อมูลที่ไม่ถูกกรอก
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('แจ้งเตือน'),
                            content: Text(
                                'กรุณากรอกข้อมูลให้ครบถ้วน: $missingFields'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('ตกลง'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: const Center(child: Text('ข้อตกลง')),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'ข้อตกลงการรักษาความลับของผู้ป่วยเป็นส่วนสำคัญในการให้บริการด้านสุขภาพ และเป็นปัจจัยหลักในการสร้างความเชื่อมั่นกับผู้รับบริการ ต่อไปนี้คือตัวอย่างข้อความที่สามารถนำไปใช้',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Checkbox(
                                          checkColor: Colors
                                              .white, // Color of the check
                                          activeColor: Colors
                                              .green, // Background color when checked
                                          value: _acceptedPolicy,
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _acceptedPolicy = value!;
                                            });
                                          },
                                        ),
                                        Expanded(
                                          child: const Text(
                                            'ยอมรับเงื่อนไขและนโยบายความเป็นส่วนตัว',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                actions: [
                                  Center(
                                    child: Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_acceptedPolicy) {
                                              await _usersCollection
                                                  .doc(user!.email)
                                                  .update({
                                                'acceptedPolicy':
                                                    _acceptedPolicy,
                                                'relatedSkills': _relatedSkills,
                                                'specificSkills':
                                                    _specificSkills,
                                                'careExperience':
                                                    _careExperience,
                                                'workArea': _workArea,
                                                'rateMoney': _rateMoney,
                                              }).then((value) {
                                                Navigator.pop(context);
                                              }).catchError((error) {
                                                print(
                                                    'Failed to add user: $error');
                                              });

                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeMainCareUI(),
                                                ),
                                              );
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                    'กรุณายอมรับเงื่อนไข',
                                                    style:
                                                        TextStyle(fontSize: 14),
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor:
                                                AllColor.TextPrimary,
                                            backgroundColor:
                                                AllColor.Secondary_C,
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    15), // เพิ่มเฉพาะ padding ในแนวตั้ง
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          child: const Text('ยืนยัน',
                                              style: TextStyle(fontSize: 16)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ยืนยัน'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AllColor.TextPrimary,
                    backgroundColor: AllColor.Primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
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
    );
  }
}

// Function to save specific user data from 'users' collection to 'Patient' collection
Future<void> saveUserDataToPatientCollection() async {
  // Get current user from FirebaseAuth
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    try {
      // Retrieve specific user data from the 'users' collection
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Get specific fields from the document
        Map<String, dynamic> userData = {
          'address': userSnapshot['address'],
          'birthDate': userSnapshot['birthDate'],
          'gender': userSnapshot['gender'],
          'imagePath': userSnapshot['imagePath'],
          'name': userSnapshot['name'],
          'phoneNumber': userSnapshot['phoneNumber'],
        };

        // Save user data to the 'Patient' collection under the document with the user's email
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(user.email)
            .set(userData);

        print('User data saved to Patient collection for user ${user.email}');
      } else {
        print('No user data found in users collection for user ${user.email}');
      }
    } catch (e) {
      print('Error: $e');
    }
  } else {
    print('No user signed in.');
  }
}
