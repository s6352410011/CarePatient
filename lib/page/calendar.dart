// ignore_for_file: unused_import

import 'package:care_patient/color.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalendarUI(),
    );
  }
}

class CalendarUI extends StatefulWidget {
  const CalendarUI({Key? key}) : super(key: key);

  @override
  State<CalendarUI> createState() => _CalendarUIState();
}

class _CalendarUIState extends State<CalendarUI> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _events = {};
  }

  void _addEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[200], // กำหนดสีพื้นหลังของ AlertDialog
          title: Text('เพิ่มกิจกรรม'),
          content: Container(
            width: 300,
            child: TextFormField(
              controller: _eventController,
              decoration: InputDecoration(
                hintText: 'ชื่อกิจกรรม',
              ),
              onSaved: (value) {
                // Save the value entered by the user (currently not used)
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Clear the text field and close the dialog
                _eventController.clear();
                Navigator.of(context).pop();
              },
              child: Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () {
                _saveEvent();
                // Clear the text field and close the dialog
                _eventController.clear();
                Navigator.of(context).pop();
              },
              child: Text('บันทึก'),
            ),
          ],
        );
      },
    );
  }

  void _saveEvent() {
    if (_selectedDay != null && _eventController.text.isNotEmpty) {
      setState(() {
        final newEvent = _eventController.text;

        if (_events.containsKey(_selectedDay)) {
          _events[_selectedDay]!.add(newEvent);
        } else {
          _events[_selectedDay] = [newEvent];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AllColor.pr,
        title: Text('ปฎิทิน'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              locale: 'th_TH',
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              calendarBuilders: CalendarBuilders(),
              availableCalendarFormats: const {
                CalendarFormat.month: 'เดือน',
                CalendarFormat.week: 'สัปดาห์',
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
            ),
            Divider(
              height: 20.0, // กำหนดความสูงของเส้นขั้น
              color: Colors.grey[300], // สีของเส้นขั้น
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5),
              child: Text(
                'กิจกรรม :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _events.entries.map((entry) {
                if (isSameDay(entry.key, _selectedDay)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: entry.value.asMap().entries.map((eventEntry) {
                      final int index = eventEntry.key;
                      final String event = eventEntry.value;

                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Card(
                          color: _selectedDay == entry.key
                              ? Colors.grey[300]
                              : Colors.transparent,
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  event,
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        // แสดงหน้าต่างแก้ไขกิจกรรม
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('แก้ไขกิจกรรม'),
                                              content: TextFormField(
                                                controller: _eventController,
                                                decoration: InputDecoration(
                                                  hintText: 'ชื่อกิจกรรมของคุณ',
                                                ),
                                                onSaved: (value) {
                                                  // บันทึกค่าที่ผู้ใช้ป้อน (ในปัจจุบันยังไม่ได้ใช้)
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    // เคลียร์ช่องข้อความและปิดหน้าต่าง
                                                    _eventController.clear();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('ยกเลิก'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // อัปเดตกิจกรรม
                                                    if (_selectedDay != null &&
                                                        _eventController
                                                            .text.isNotEmpty) {
                                                      setState(() {
                                                        final updatedEvent =
                                                            _eventController
                                                                .text;
                                                        _events[_selectedDay]![
                                                                index] =
                                                            updatedEvent;
                                                      });
                                                    }
                                                    // เคลียร์ช่องข้อความและปิดหน้าต่าง
                                                    _eventController.clear();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text('บันทึก'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // แสดงหน้าต่างยืนยัน
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("ยืนยัน"),
                                              content: Text(
                                                  "คุณแน่ใจหรือไม่ว่าต้องการลบกิจกรรมนี้?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("ยกเลิก"),
                                                  onPressed: () {
                                                    // ปิดหน้าต่าง
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("ตกลง"),
                                                  onPressed: () {
                                                    // ลบกิจกรรม
                                                    setState(() {
                                                      _events[entry.key]!
                                                          .remove(event);
                                                    });
                                                    // ปิดหน้าต่าง
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                } else {
                  return SizedBox.shrink();
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
