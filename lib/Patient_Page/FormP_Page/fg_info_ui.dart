import 'package:care_patient/Caregiver_Page/FormC_Page/f_work_ui.dart';
import 'package:care_patient/Patient_Page/FormP_Page/f_medical_ui.dart';
import 'package:flutter/material.dart';

class PFormInfoUI extends StatefulWidget {
  const PFormInfoUI({Key? key}) : super(key: key);

  @override
  _PFormInfoUIState createState() => _PFormInfoUIState();
}

class _PFormInfoUIState extends State<PFormInfoUI> {
  // Variables to store user input
  String? _name = '';
  String? _gender = '';
  DateTime? _dob;
  String? _address = '';
  String? _phoneNumber = '';
  String? _email = ''; // Fetch from Firebase
  String? _selectedFile = '';

  // Function to handle date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
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
              SizedBox(height: 10),
              // วัน/เดือน/ปีเกิด
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text(
                  _dob == null
                      ? 'วัน/เดือน/ปีเกิด'
                      : 'วันเกิด: ${_dob!.day}/${_dob!.month}/${_dob!.year}',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              SizedBox(height: 10),
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
              TextField(
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              // E-mail
              Text(
                'E-mail: $_email', // Assume fetched from Firebase
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // แนบไฟล์รูป
              ElevatedButton(
                onPressed: () {
                  // Code to select and store file
                },
                child: Text('เลือกไฟล์จากเครื่อง + $_selectedFile'),
              ),
              SizedBox(height: 20),
              // ปุ่มถัดไป
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PFormMedicalUI(),
                      ),
                    );
                  },
                  icon: Icon(Icons.arrow_forward),
                  label: Text('ถัดไป'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(width: 2, color: Colors.white),
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
