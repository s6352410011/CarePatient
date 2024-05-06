import 'package:care_patient/Caregiver_Page/main_caregiverUI.dart';
import 'package:care_patient/class/color.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  bool _acceptedPolicy = false;
  bool _allDaysSelected = false;
  bool _mondaySelected = false;
  bool _tuesdaySelected = false;
  bool _wednesdaySelected = false;
  bool _thursdaySelected = false;
  bool _fridaySelected = false;
  bool _saturdaySelected = false;
  bool _sundaySelected = false;

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
              Text(
                'วันที่สามารถทำงานได้',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: Text('ทุกวัน'),
                    selected: _allDaysSelected,
                    onSelected: (isSelected) {
                      setState(() {
                        _allDaysSelected = isSelected;
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
                        if (!isSelected) {
                          _allDaysSelected = false;
                        } else {
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
              SizedBox(height: 30),
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
                      // เพิ่มโค้ดสำหรับการยืนยันข้อมูลที่กรอกลงฟอร์ม
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
                            title: const Text('แจ้งเตือน'),
                            content: const Text(
                                'กรุณาเลือกวันที่ต้องการความดูแลอย่างน้อย 1 วัน'),
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
                                                'availableDays': {
                                                  'allDays': _allDaysSelected,
                                                  'monday': _mondaySelected,
                                                  'tuesday': _tuesdaySelected,
                                                  'wednesday':
                                                      _wednesdaySelected,
                                                  'thursday': _thursdaySelected,
                                                  'friday': _fridaySelected,
                                                  'saturday': _saturdaySelected,
                                                  'sunday': _sundaySelected,
                                                },
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('ยืนยัน'),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
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
