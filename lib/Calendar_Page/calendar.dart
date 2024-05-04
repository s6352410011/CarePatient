import 'dart:async';

import 'package:care_patient/Caregiver_Page/FormCaregiver_Page/form_generalCaregiver_info_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

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
  late TimeOfDay? _selectedTime; // เพิ่มตัวแปร _selectedTime ที่นี่
  final User? user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    super.initState();
    // กำหนดรูปแบบปฏิทินเริ่มต้นเป็นรูปแบบเดือน
    _calendarFormat = CalendarFormat.month;
    // กำหนดวันที่โฟกัสในปฏิทินเริ่มต้นเป็นวันปัจจุบัน
    _focusedDay = DateTime.now();
    // กำหนดวันที่ที่เลือกในปฏิทินเริ่มต้นเป็นวันปัจจุบัน
    _selectedDay = DateTime.now();
    _selectedTime = null; // กำหนดค่าเริ่มต้นของ _selectedTime เป็น null
    // สร้างรายการเหตุการณ์เปล่า ๆ
    _events = {};
    _fetchEvents();
  }

  void _fetchEvents() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      DocumentSnapshot snapshot =
          await firestore.collection('caregiver').doc(user!.email).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _events = {
            for (var entry in data.entries)
              DateTime.parse(entry.key): [
                {
                  'event': entry.value['event'],
                  'time': (entry.value['time'] as Timestamp).toDate()
                }
              ]
          };
        });
      } else {
        print('Document does not exist on the database');
      }
    } catch (error) {
      print('Failed to get data: $error');
    }
  }

  // แสดง Dialog เพื่อเพิ่มเหตุการณ์ใหม่
  void _addEvent() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[200],
              title: const Text('เพิ่มกิจกรรม'),
              content: SizedBox(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _eventController,
                      decoration: const InputDecoration(
                        hintText: 'ชื่อกิจกรรม',
                      ),
                      onSaved: (value) {},
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () async {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                          builder: (BuildContext context, Widget? child) {
                            return MediaQuery(
                              data: MediaQuery.of(context)
                                  .copyWith(alwaysUse24HourFormat: true),
                              child: child!,
                            );
                          },
                        );
                        if (pickedTime != null) {
                          setState(() {
                            _selectedTime = pickedTime;
                          });
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.access_time),
                          const SizedBox(width: 5),
                          SizedBox(
                            width: 200,
                            child: Text(
                              _selectedTime == null
                                  ? 'Select event time'
                                  : 'Time: ${_selectedTime!.hour.toString().padLeft(2, '0')} : ${_selectedTime!.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _eventController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('ยกเลิก'),
                ),
                TextButton(
                  onPressed: () {
                    _saveEvent();
                    _eventController.clear();
                    Navigator.of(context).pop();
                  },
                  child: const Text('บันทึก'),
                ),
              ],
            );
          },
        );
      },
    );
  }

// บันทึกเหตุการณ์ใหม่
  void _saveEvent() {
    if (_selectedDay != null &&
        _eventController.text.isNotEmpty &&
        _selectedTime != null) {
      final newEvent = _eventController.text;
      final DateTime eventDateTime = DateTime(
        _selectedDay.year,
        _selectedDay.month,
        _selectedDay.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      // เชื่อมต่อ Firestore
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // สร้างโครงสร้างข้อมูล
      Map<String, dynamic> eventData = {
        'event': newEvent,
        'time': Timestamp.fromDate(eventDateTime),
      };

      // บันทึกข้อมูลลงใน Firestore
      firestore
          .collection('caregiver') // ชื่อ Collection
          .doc(user!.email) // ชื่อ Document (ในที่นี้ให้ใช้ email ของผู้ใช้)
          .set(eventData,
              SetOptions(merge: true)) // merge: true จะทำให้มีการรวมข้อมูล
          .then((value) => print('Event added to Firestore'))
          .catchError((error) => print('Failed to add event: $error'));

      setState(() {
        if (_events.containsKey(_selectedDay)) {
          _events[_selectedDay]!
              .add({'event': newEvent, 'time': _selectedTime});
        } else {
          _events[_selectedDay] = [
            {'event': newEvent, 'time': _selectedTime}
          ];
        }
      });
    }
  }

// แก้ไขเหตุการณ์
  void _editEvent(String event, TimeOfDay? eventTime) async {
    _eventController.text = event;
    _selectedTime = eventTime;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text('Edit Event'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _eventController,
                    decoration: InputDecoration(
                      hintText: 'Enter your event',
                    ),
                  ),
                  SizedBox(height: 20),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Row(
                      children: [
                        Icon(Icons.access_time),
                        SizedBox(width: 5),
                        Text(
                          _selectedTime == null
                              ? 'Select event time'
                              : 'Time: ${_selectedTime!.hour.toString().padLeft(2, '0')} : ${_selectedTime!.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _eventController.clear();
                    _selectedTime = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    // อัปเดตข้อมูลใน Firestore
                    FirebaseFirestore.instance
                        .collection('caregiver') // ชื่อ Collection
                        .doc(
                            user!.email) // ใช้ email ของผู้ใช้เป็นชื่อ Document
                        .update({
                          'event': _eventController.text,
                          'time': _selectedTime != null
                              ? Timestamp.fromDate(DateTime(
                                  _selectedDay.year,
                                  _selectedDay.month,
                                  _selectedDay.day,
                                  _selectedTime!.hour,
                                  _selectedTime!.minute,
                                ))
                              : null,
                        })
                        .then((value) => print('Event updated in Firestore'))
                        .catchError(
                            (error) => print('Failed to update event: $error'));

                    setState(() {
                      _events[_selectedDay] =
                          _events[_selectedDay]?.map((eventData) {
                                if (eventData['event'] == event) {
                                  return {
                                    'event': _eventController.text,
                                    'time': _selectedTime
                                  };
                                }
                                return eventData;
                              }).toList() ??
                              [
                                {
                                  'event': _eventController.text,
                                  'time': _selectedTime
                                }
                              ];
                    });

                    _eventController.clear();
                    _selectedTime = null;
                    Navigator.of(context).pop();
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    setState(() {});
  }

  void _deleteEvent(String event, TimeOfDay? eventTime) async {
    // ลบฟิลด์ 'event' และ 'time' จากเอกสารใน Firestore
    FirebaseFirestore.instance
        .collection('caregiver') // ชื่อ Collection
        .doc(user!.email) // ใช้ email ของผู้ใช้เป็นชื่อ Document
        .update({
          'event': FieldValue.delete(), // ลบฟิลด์ 'event'
          'time': FieldValue.delete(), // ลบฟิลด์ 'time'
        })
        .then((value) => print('Fields deleted from Firestore document'))
        .catchError((error) => print('Failed to delete fields: $error'));

    setState(() {
      _events[_selectedDay]?.removeWhere((eventData) =>
          eventData['event'] == event && eventData['time'] == eventTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แสดงปฏิทิน
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
                'Events :',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _events.entries.map((entry) {
                if (isSameDay(entry.key, _selectedDay)) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: _selectedDay == entry.key
                              ? Colors.grey[300]
                              : Colors.transparent,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: entry.value.length,
                            itemBuilder: (context, index) {
                              final Map<String, dynamic> eventData =
                                  entry.value[index];
                              final String event = eventData['event'];
                              final TimeOfDay? eventTime = eventData['time'];
                              return ListTile(
                                title: Text(
                                  event,
                                  style: TextStyle(
                                    fontSize: 20, // ปรับขนาดตัวอักษรตามต้องการ
                                  ),
                                ),
                                subtitle: eventTime != null
                                    ? Text(
                                        'Time: ${eventTime.hour.toString().padLeft(2, '0')} : ${eventTime.minute.toString().padLeft(2, '0')}',
                                        style: TextStyle(fontSize: 16),
                                      )
                                    : null,
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () async {
                                        _editEvent(event, eventTime);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        // Show confirmation dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text("Confirmation"),
                                              content: Text(
                                                  "Are you sure you want to delete this event?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    // Close the dialog
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    // Delete the event
                                                    _deleteEvent(
                                                        event, eventTime);
                                                    setState(() {
                                                      _events[entry.key]!
                                                          .remove(event);
                                                    });
                                                    // Close the dialog
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
                              );
                            },
                          ),
                        ),
                      ),
                    ],
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
