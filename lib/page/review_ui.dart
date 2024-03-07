// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:care_patient/color.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _reviewController =
      TextEditingController(); // เพิ่ม Controller สำหรับจัดการข้อความรีวิว

  @override
  void dispose() {
    _reviewController.dispose(); // จัดการการคืนทรัพยากร
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllColor.pr, // สีพื้นหลังของ AppBar
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center, // จัดตำแหน่งตรงกลาง
          children: [
            Text(
              'คะแนนรีวิว ',
              style: TextStyle(
                fontWeight: FontWeight.bold, // ตัวหนา
                color: Colors.white, // สีข้อความ
              ),
            ),
            Icon(Icons.star,
                color: Colors.amber), // ไอคอน รูปดาว พร้อมกับสีของไอคอน
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: 5, // จำนวนรีวิว
                itemBuilder: (context, index) {
                  return Card(
                    color: AllColor.sc, // สีพื้นหลังของการ์ด
                    elevation: 5, // ความโค้งของการ์ด
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // กำหนดความโค้งของมุมการ์ด
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(
                          16), // ระยะห่างของข้อความภายในการ์ด
                      child: ListTile(
                        title: Text(
                          'รีวิวที่ ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white, // สีข้อความ
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'คำอธิบายรีวิวที่ ${index + 1}',
                          style: const TextStyle(
                            color: Colors.white70, // สีข้อความ
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Text(
                              '${index + 1}'), // สีพื้นหลังของ CircleAvatar
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white, // สีของไอคอน
                        ),
                        onTap: () {
                          // โค้ดเมื่อคลิกที่รีวิว
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _reviewController,
                    decoration: const InputDecoration(
                      hintText: 'เขียนรีวิว', // ข้อความในช่องพิมพ์
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: AllColor.sc, // สีของไอคอน
                  ),
                  onPressed: () {
                    // การทำงานเมื่อกดปุ่มส่งรีวิว
                    String reviewText = _reviewController.text;
                    // คุณสามารถทำอะไรก็ตามกับข้อความรีวิวที่ผู้ใช้พิมพ์ตรงนี้
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
