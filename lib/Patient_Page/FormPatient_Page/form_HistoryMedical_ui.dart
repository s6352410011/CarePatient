import 'package:care_patient/Caregiver_Page/FormCaregiver_Page/form_generalCaregiver_info_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:care_patient/Patient_Page/main_PatientUI.dart';

class PFormMedicalUI extends StatefulWidget {
  const PFormMedicalUI({Key? key}) : super(key: key);

  @override
  State<PFormMedicalUI> createState() => _PFormMedicalUIState();
}

class _PFormMedicalUIState extends State<PFormMedicalUI> {
  bool _allDaysSelected = false;
  bool _mondaySelected = false;
  bool _tuesdaySelected = false;
  bool _wednesdaySelected = false;
  bool _thursdaySelected = false;
  bool _fridaySelected = false;
  bool _saturdaySelected = false;
  bool _sundaySelected = false;
  bool _acceptedPolicy = false;
  String? _address = '';
  String? _phoneNumber = '';
  String? _email = ''; // Fetch from Firebase
  String? _selectedFile = '';
  // สร้าง TextEditingController สำหรับช่องข้อมูล "โปรดระบุ"
  TextEditingController _allergicToMedicationDetailController =
      TextEditingController();

// ตรวจสอบว่ามีช่องใดที่ยังไม่ได้กรอกข้อมูลหรือไม่

  bool _allergicToMedication = false;
  String _historyofillness = '';
  String _historymedicine = '';
  String _needspecial = '';
  String _namerelative = '';
  String _relationship = '';

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
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: AllColor.Primary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ประวัติการรักษา
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'ประวัติการรักษา',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //ประวัติการเจ็บป่วย หรือ โรคประจำตัว
            TextField(
              onChanged: (value) {
                setState(() {
                  _historyofillness = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ประวัติการเจ็บป่วย หรือ โรคประจำตัว',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'ประวัติการแพ้ยา',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      value: !_allergicToMedication,
                      onChanged: (value) {
                        setState(() {
                          _allergicToMedication = !value!;
                        });
                      },
                    ),
                    Text('ไม่มีประวัติการแพ้ยา'),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: _allergicToMedication,
                      onChanged: (value) {
                        setState(() {
                          _allergicToMedication = value!;
                        });
                      },
                    ),
                    Text('มีประวัติการแพ้ยา'),
                  ],
                ),
                if (_allergicToMedication)
                  TextFormField(
                    enabled:
                        _allergicToMedication, // ทำให้ช่องข้อมูลนี้สามารถกรอกได้เมื่อมีประวัติการแพ้ยาเท่านั้น
                    controller: _allergicToMedicationDetailController,
                    decoration: InputDecoration(
                      labelText: 'โปรดระบุ',
                    ),
                  ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            // ประวัติการรับยาเป็นประจำ
            TextField(
              onChanged: (value) {
                setState(() {
                  _historymedicine = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ประวัติการรับยาเป็นประจำ',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //ความต้องการให้ดูแลเป็นพิเศษ
            TextField(
              onChanged: (value) {
                setState(() {
                  _needspecial = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ความต้องการให้ดูแลเป็นพิเศษ',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'วันที่ต้องการความดูแล',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: Text('ทุกวัน'),
                      selected: _allDaysSelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _allDaysSelected = isSelected;
                          // เมื่อเลือกทุกวันให้เลือกทุกวันอื่น ๆ ด้วย
                          _mondaySelected = isSelected;
                          _tuesdaySelected = isSelected;
                          _wednesdaySelected = isSelected;
                          _thursdaySelected = isSelected;
                          _fridaySelected = isSelected;
                          _saturdaySelected = isSelected;
                          _sundaySelected = isSelected;
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('จันทร์'),
                      selected: _mondaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _mondaySelected = isSelected;
                          // ถ้ายกเลิกการเลือกจันทร์ให้ยกเลิกการเลือกทุกวันด้วย
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('อังคาร'),
                      selected: _tuesdaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _tuesdaySelected = isSelected;
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('พุธ'),
                      selected: _wednesdaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _wednesdaySelected = isSelected;
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('พฤหัสบดี'),
                      selected: _thursdaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _thursdaySelected = isSelected;
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('ศุกร์'),
                      selected: _fridaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _fridaySelected = isSelected;
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('เสาร์'),
                      selected: _saturdaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _saturdaySelected = isSelected;
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text('อาทิตย์'),
                      selected: _sundaySelected,
                      onSelected: (isSelected) {
                        setState(() {
                          _sundaySelected = isSelected;
                          if (!isSelected) {
                            _allDaysSelected = false;
                          } else {
                            // ตรวจสอบว่าทุกวันถูกเลือกหรือไม่
                            if (_mondaySelected &&
                                _tuesdaySelected &&
                                _wednesdaySelected &&
                                _thursdaySelected &&
                                _fridaySelected &&
                                _saturdaySelected &&
                                _sundaySelected) {
                              _allDaysSelected = true;
                            }
                          }
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            //ที่อยู่
            TextField(
              onChanged: (value) {
                setState(() {
                  _address = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ที่อยู่',
              ),
            ),
            SizedBox(height: 20),
            // ข้อมูลการติดต่อฉุกเฉิน
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'ข้อมูลการติดต่อฉุกเฉิน',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //ชื่อผู้ติดต่อ
            TextField(
              onChanged: (value) {
                setState(() {
                  _namerelative = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ชื่อผู้ติดต่อ',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            //ความสัมพันธ์กับผู้ป่วย
            TextField(
              onChanged: (value) {
                setState(() {
                  _relationship = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'ความสัมพันธ์กับผู้ป่วย',
              ),
            ),
            SizedBox(
              height: 20,
            ),
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
                  borderRadius:
                      BorderRadius.circular(20.0), // กำหนดรูปร่างขอบเส้น
                ),
              ),
            ),
            // แนบไฟล์รูป
            Text(
              'แนบรูปภาพผู้ป่วย : ',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () async {
                FilePickerResult? result =
                    await FilePicker.platform.pickFiles();

                if (result != null) {
                  setState(() {
                    // ตัดชื่อไฟล์ให้เหลือแค่ email ของผู้ใช้
                    _selectedFile = _email!.substring(0, _email!.indexOf('@')) +
                        '_patient.jpg';
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
                backgroundColor: AllColor.Secondary, // สีปุ่ม
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
                onPressed: () async {
                  String? missingFields = '';

                  if (_email == null || _email == '') {
                    missingFields += 'Email, ';
                  }
                  if (_historymedicine == null || _historymedicine == '') {
                    missingFields += 'ประวัติการรับยา, ';
                  }
                  if (_historyofillness == null || _historyofillness == '') {
                    missingFields += 'ประวัติการเจ็บป่วย, ';
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

                  if (_namerelative == null || _namerelative == '') {
                    missingFields += 'ชื่อผู้ติดต่อ, ';
                  }
                  if (_needspecial == null || _needspecial == '') {
                    missingFields += 'ความต้องการพิเศษ, ';
                  }
                  if (_relationship == null || _relationship == '') {
                    missingFields += 'ความสัมพันธ์, ';
                  }
                  if (missingFields != '') {
                    // แสดงข้อความแจ้งเตือนถ้ามีข้อมูลที่ไม่ถูกกรอก
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('แจ้งเตือน'),
                          content:
                              Text('กรุณากรอกข้อมูลให้ครบถ้วน: $missingFields'),
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
                  // ตรวจสอบการกรอกข้อมูลในช่อง "โปรดระบุ" หากมีประวัติการแพ้ยา
                  else if (_allergicToMedication &&
                      _allergicToMedicationDetailController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('แจ้งเตือน'),
                          content: Text('กรุณากรอกข้อมูลในช่อง "โปรดระบุ"'),
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
                  } else if (!_allDaysSelected &&
                      !_mondaySelected &&
                      !_tuesdaySelected &&
                      !_wednesdaySelected &&
                      !_thursdaySelected &&
                      !_fridaySelected &&
                      !_saturdaySelected &&
                      !_sundaySelected) {
                    // ถ้าไม่มีการเลือกวันใดเลย
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('แจ้งเตือน'),
                          content: Text(
                              'กรุณาเลือกวันที่ต้องการความดูแลอย่างน้อย 1 วัน'),
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
                                        checkColor:
                                            Colors.white, // Color of the check
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
                                            // Code to save form data to Firebase
                                            await firebase;
                                            await _usersCollection
                                                .doc(user!.email)
                                                .set({
                                              'acceptedPolicy': _acceptedPolicy,
                                              'email': _email,
                                              'history_medicine':
                                                  _historymedicine,
                                              'history_of_illness':
                                                  _historyofillness,
                                              'address': _address,
                                              'phone_number': _phoneNumber,
                                              'relative_name': _namerelative,
                                              'special_needs': _needspecial,
                                              'relationship': _relationship,
                                              'allergic_to_medication':
                                                  _allergicToMedication,
                                              'allergic_to_medication_detail':
                                                  _allergicToMedicationDetailController
                                                      .text,
                                              'all_days_selected':
                                                  _allDaysSelected,
                                              'monday_selected':
                                                  _mondaySelected,
                                              'tuesday_selected':
                                                  _tuesdaySelected,
                                              'wednesday_selected':
                                                  _wednesdaySelected,
                                              'thursday_selected':
                                                  _thursdaySelected,
                                              'friday_selected':
                                                  _fridaySelected,
                                              'saturday_selected':
                                                  _saturdaySelected,
                                              'sunday_selected':
                                                  _sundaySelected,
                                            });

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomeMainPatientUI(),
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
                                          foregroundColor: Colors.white,
                                          backgroundColor: Colors.green,
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
                  backgroundColor: AllColor.Primary,
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
    );
  }
}
