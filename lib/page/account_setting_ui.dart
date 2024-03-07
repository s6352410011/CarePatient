import 'package:care_patient/color.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/login_ui.dart';
import 'package:flutter/services.dart';

class AccountSettingUI extends StatefulWidget {
  const AccountSettingUI({Key? key}) : super(key: key);

  @override
  State<AccountSettingUI> createState() => _AccountSettingUIState();
}

class _AccountSettingUIState extends State<AccountSettingUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllColor.pr,
        title: const Text('Account Setting'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/user_image.jpg'),
                // รูป user มีปุ่มให้กดเปลี่ยน
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ชื่อ-นามสกุล',
                  hintText: 'กรุณาใส่ชื่อและนามสกุล',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType: TextInputType.text, // ประเภทของคีย์บอร์ด (text)
                // ตัวอื่น ๆ ของ TextFormField จะอยู่ที่นี่
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'กรุณาใส่ที่อยู่อีเมล',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType:
                    TextInputType.emailAddress, // ประเภทของคีย์บอร์ด (email)
                // ตัวอื่น ๆ ของ TextFormField จะอยู่ที่นี่
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'เบอร์โทรศัพท์',
                  hintText: 'กรุณาใส่เบอร์โทรศัพท์',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType: TextInputType.phone, // ประเภทของคีย์บอร์ด (phone)
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                // ตัวอื่น ๆ ของ TextFormField จะอยู่ที่นี่
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'ที่อยู่',
                  hintText: 'กรุณาใส่ที่อยู่',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                ),
                keyboardType:
                    TextInputType.streetAddress, // ประเภทของคีย์บอร์ด (address)
                // ตัวอื่น ๆ ของ TextFormField จะอยู่ที่นี่
              ),
              SizedBox(height: 300),
              ElevatedButton(
                onPressed: () {
                  // รหัสที่ต้องการให้ทำเมื่อปุ่มถูกกด
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  fixedSize: Size(200, 50), // สีพื้นหลังของปุ่ม
                ),
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('ต้องการลบบัญชีของคุณถาวร?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // ปิดหน้าต่างแจ้งเตือน
                            },
                            child: Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
                              // ทำอะไรสักอย่างเมื่อกดปุ่ม OK
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginUI(),
                                ),
                              );
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // สีปุ่มแดง
                  fixedSize: Size(200, 50),
                ),
                child: Text('Delete Account',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
