import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:care_patient/Caregiver_Page/FormCaregiver_Page/form_HistoryWork_ui.dart';

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
      FirebaseFirestore.instance.collection('forms');

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
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                onPressed: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();

                  if (result != null) {
                    setState(() {
                      // _selectedFile = result.files.single.path!;
                      _selectedFile =
                          _email!.substring(0, _email!.indexOf('@')) + '_C.jpg';
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
                },
                icon: Icon(Icons.attach_file),
                label: Text('เลือกไฟล์ $_selectedFile'),
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
                      await _usersCollection
                          .doc(user!.email)
                          .collection('general')
                          .doc('data')
                          .set({
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
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
