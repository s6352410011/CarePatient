import 'package:care_patient/Caregiver_Page/FormC_Page/f_work_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

// เรียกใช้ FirebaseAuth
FirebaseAuth auth = FirebaseAuth.instance;
// ดึงข้อมูลผู้ใช้ปัจจุบัน
User? user = auth.currentUser;

class CFormInfoUI extends StatefulWidget {
  const CFormInfoUI({Key? key}) : super(key: key);

  @override
  _CFormInfoUIState createState() => _CFormInfoUIState();
}

class _CFormInfoUIState extends State<CFormInfoUI> {
  // Variables to store user input
  String? _name = '';
  String? _gender = '';
  String? _selectedDate;
  String? _address = '';
  String? _phoneNumber = '';
  String? _email = ''; // Fetch from Firebase
  String? _selectedFile = '';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // กำหนดให้ไม่แสดงปุ่ม back
        title: Text(
          'แบบฟอร์มลงทะเบียน',
          style: TextStyle(
            color: AllColor.bg,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: AllColor.pr, // กำหนดสีพื้นหลังของ AppBar เป็นสีเขียว
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // หัวข้อใหญ่
              Text(
                'ข้อมูลทั่วไป',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              // ชื่อ - นามสกุล
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
              // เพศ
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
              // วัน/เดือน/ปีเกิด
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
              // ที่อยู่
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
              // เบอร์โทรศัพท์
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
              // E-mail
              Text(
                'E-mail: $_email',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // แนบไฟล์รูป
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
                      // ตัดชื่อไฟล์ให้เหลือแค่ email ของผู้ใช้
                      _selectedFile =
                          _email!.substring(0, _email!.indexOf('@')) + '_C.jpg';
                    });
                  } else {
                    // ถ้าผู้ใช้ยกเลิกการเลือกไฟล์
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
                icon: Icon(Icons.attach_file_rounded), // ไอคอนแนบไฟล์
                label: Text('เลือกไฟล์ $_selectedFile'), // ข้อความปุ่ม
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // สีข้อความบนปุ่ม
                  backgroundColor: AllColor.sc, // สีปุ่ม
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ), // ขนาดการเรียงรูปและข้อความ
                ),
              ),

              SizedBox(height: 20),
              // ปุ่มถัดไป
              Center(
                child: ElevatedButton(
                  onPressed: () {
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
                      // แสดงข้อความแจ้งเตือนถ้ามีข้อมูลที่ไม่ถูกกรอก
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
                      // ถ้าข้อมูลถูกกรอกครบทุกช่อง ให้เรียกหน้าแบบฟอร์มการแพทย์ต่อไป
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CFormWorkUI(),
                        ),
                      );
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ถัดไป'),
                      SizedBox(width: 8), // เพิ่มระยะห่างระหว่างข้อความและไอคอน
                      Icon(Icons.arrow_forward_ios_rounded),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AllColor.pr,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
