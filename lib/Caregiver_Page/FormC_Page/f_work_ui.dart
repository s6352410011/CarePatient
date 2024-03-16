import 'package:care_patient/Caregiver_Page/home_CaregiverUI.dart';
import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';

class CFormWorkUI extends StatefulWidget {
  const CFormWorkUI({super.key});

  @override
  State<CFormWorkUI> createState() => _CFormWorkUIState();
}

class _CFormWorkUIState extends State<CFormWorkUI> {
  // ตัวแปรสำหรับเก็บข้อมูลฟอร์ม
  bool _allDaysSelected = false;
  bool _mondaySelected = false;
  bool _tuesdaySelected = false;
  bool _wednesdaySelected = false;
  bool _thursdaySelected = false;
  bool _fridaySelected = false;
  bool _saturdaySelected = false;
  bool _sundaySelected = false;

  String _relatedSkills = ''; // ทักษะและความสามารถที่เกี่ยวข้อง
  String _specificSkills = ''; // ความถนัดและความสามารถเฉพาะ
  String _careExperience = ''; // ประสบการณ์การดูแล
  String _workArea = ''; // เขตที่คุณสามารถไปดูแล

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // กำหนดให้ไม่แสดงปุ่ม back
        title: const Text(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ประวัติการทำงาน :',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // ทักษะและความสามารถที่เกี่ยวข้อง
            TextField(
              onChanged: (value) {
                setState(() {
                  _relatedSkills = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'ทักษะและความสามารถที่เกี่ยวข้อง',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // ความถนัดและความสามารถเฉพาะ
            TextField(
              onChanged: (value) {
                setState(() {
                  _specificSkills = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'ความถนัดและความสามารถเฉพาะ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // ประสบการณ์การดูแล
            TextField(
              onChanged: (value) {
                setState(() {
                  _careExperience = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'ประสบการณ์การดูแล',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            // เขตที่คุณสามารถไปดูแล
            TextField(
              onChanged: (value) {
                setState(() {
                  _workArea = value;
                });
              },
              decoration: const InputDecoration(
                labelText: 'เขตที่คุณสามารถไปดูแล',
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),
            // วันที่สามารถทำงานได้
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Column(
                  children: [
                    Text(
                      'วันที่คุณสามารถรับงานได้ :',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(
                      label: const Text('ทุกวัน'),
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
                      label: const Text('จันทร์'),
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
                      label: const Text('อังคาร'),
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
                      label: const Text('พุธ'),
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
                      label: const Text('พฤหัสบดี'),
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
                      label: const Text('ศุกร์'),
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
                      label: const Text('เสาร์'),
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
                      label: const Text('อาทิตย์'),
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
            const SizedBox(height: 20),
            // ปุ่มยืนยัน
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
                          content:
                              Text('กรุณากรอกข้อมูลให้ครบถ้วน: $missingFields'),
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
                        bool _acceptedPolicy =
                            false; // ตัวแปรเก็บสถานะการยอมรับเงื่อนไขและนโยบายความเป็นส่วนตัว

                        return StatefulBuilder(
                          builder: (context, setState) {
                            return AlertDialog(
                              title: const Center(child: Text('ข้อตกลง')),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    'ข้อตกลงการรักษาความลับของผู้ป่วยเป็นส่วนสำคัญในการให้บริการด้านสุขภาพ และเป็นปัจจัยหลักในการสร้างความเชื่อมั่นกับผู้รับบริการ ต่อไปนี้คือตัวอย่างข้อความที่สามารถนำไปใช้:',
                                    style: TextStyle(fontSize: 16),
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
                                      const Text(
                                        'ตกลงยอมรับเงื่อนไข',
                                        style: TextStyle(fontSize: 16),
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
                                        onPressed: () {
                                          if (_acceptedPolicy) {
                                            Navigator.push(
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
                  backgroundColor: AllColor.pr,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
