import 'dart:async';
import 'package:care_patient/class/color.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class CalendarPatientUI extends StatefulWidget {
  const CalendarPatientUI({Key? key}) : super(key: key);

  @override
  State<CalendarPatientUI> createState() => _CalendarPatientUIState();
}

class _CalendarPatientUIState extends State<CalendarPatientUI> {
  // สร้างตัวแปรเพื่อเก็บข้อมูลของผู้ใช้ปัจจุบัน
  late final User? _user;
  // สร้าง ValueNotifier เพื่อติดตามเหตุการณ์ที่ถูกเลือก
  late final ValueNotifier<List<Event>> _selectedEvents;
  // เก็บวันที่ที่ถูกเลือก
  late DateTime _selectedDay;
  // เก็บเดือนที่โฟกัส
  DateTime _focusedMonth = DateTime.now();
  // สตรีมเหตุการณ์สำหรับเดือนนั้นๆ
  Stream<List<Event>> _eventsForMonth = const Stream.empty();

  @override
  void initState() {
    super.initState();
    // รับข้อมูลผู้ใช้ปัจจุบัน
    _user = FirebaseAuth.instance.currentUser;
    // กำหนดค่าเริ่มต้นของ ValueNotifier
    _selectedEvents = ValueNotifier([]);
    // กำหนดวันที่เริ่มต้นเป็นวันปัจจุบัน
    _selectedDay = DateTime.now();
    // เตรียมข้อมูลเหตุการณ์สำหรับเดือนปัจจุบัน
    _initializeEvents();
  }

  // เตรียมข้อมูลเหตุการณ์สำหรับเดือนปัจจุบัน
  Future<void> _initializeEvents() async {
    _eventsForMonth = _getEventsForMonth(DateTime.now());
  }

  // เมื่อเปลี่ยนหน้าเดือนในปฏิทิน
  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedMonth = focusedDay;
    });
    _updateEvents(focusedDay);
  }

  // อัปเดตเหตุการณ์สำหรับเดือนที่กำลังโฟกัส
  Future<void> _updateEvents(DateTime month) async {
    _eventsForMonth = _getEventsForMonth(month);
  }

  // ลบเหตุการณ์ที่เลือก
  void _deleteEvent(Event event) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(user.email)
            .collection('calendar')
            .where('title', isEqualTo: event.title)
            .where('time', isEqualTo: event.time)
            .where('date', isEqualTo: Timestamp.fromDate(event.date))
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.delete();
          });
        });
        _selectedEvents.value.remove(event);
        // อัพเดท UI ด้วย setState เมื่อมีการลบเหตุการณ์
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ลบกิจกรรมเรียบร้อยแล้ว')),
        );
      }
    } catch (error) {
      print('Error deleting event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ลบกิจกรรมไม่สำเร็จ')),
      );
    }
  }

  // อัปเดตปฏิทินหลังจากที่มีการแก้ไขเหตุการณ์
  void refreshCalendar() {
    setState(() {});
  }

  // แก้ไขเหตุการณ์
  void _editEvent(Event event) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditEventScreen(event: event, refreshCalendar: refreshCalendar),
      ),
    );
    if (result == true) {
      _updateEvents(_focusedMonth);
    }
  }

  // สร้างมาร์เกอร์สำหรับวันในปฏิทิน
  Widget _markerBuilder(
      BuildContext context, DateTime day, List<Event> events) {
    return StreamBuilder<List<Event>>(
      stream: _eventsForMonth,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final eventsForMonth = snapshot.data!;
          final hasEvent =
              eventsForMonth.any((event) => isSameDay(event.date, day));
          if (hasEvent) {
            return Container(
              margin: EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AllColor.DotsThird, //สีจุด Highlights
              ),
              width: 10, // ปรับขนาดกว้างของวงกลม
              height: 10, // ปรับขนาดสูงของวงกลม
            );
          }
        }
        return SizedBox.shrink();
      },
    );
  }

  @override
  // สร้างหน้า UI ของปฏิทิน
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ปฏิทิน',
          style: TextStyle(
            color: AllColor.TextPrimary, // สีของข้อความ
            fontWeight: FontWeight.bold, // ตัวหนา
          ),
        ),
        centerTitle: true, // ทำให้ข้อความอยู่ตรงกลาง
        backgroundColor: AllColor.Primary, // สีพื้นหลัง
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar<Event>(
            locale: 'th_TH',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedMonth,
            calendarFormat: CalendarFormat.month,
            onDaySelected: _onDaySelected,
            onPageChanged: _onPageChanged,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AllColor.DotsThird.withOpacity(0.5), //สีที่บอกวันปัจุบัน
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: _markerBuilder,
            ),
          ),
          SizedBox(height: 10),

          //แสดงกิจกรรม
          Expanded(
            child: Container(
              child: StreamBuilder<List<Event>>(
                stream: _fetchEventsForDay(_selectedDay),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final events = snapshot.data!;
                    return ListView.builder(
                      itemCount: events.length,
                      itemBuilder: (context, index) {
                        final event = events[index];
                        return Container(
                          margin: EdgeInsets.all(
                              10), // กำหนดระยะห่างระหว่าง ListTile
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                20), // กำหนดรูปร่างของกรอบ
                            color: AllColor.Primary, // กำหนดสีพื้นหลังของกรอบ
                          ),
                          child: ListTile(
                            title: Text(
                              event.title,
                              style: TextStyle(
                                color: AllColor.TextPrimary, // กำหนดสีของอักษร
                              ),
                            ),
                            subtitle: Text(
                              event.time,
                              style: TextStyle(
                                color:
                                    AllColor.TextSecondary, // กำหนดสีของอักษร
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color:
                                        AllColor.IconPrimary, // กำหนดสีของไอคอน
                                  ),
                                  onPressed: () {
                                    // เรียกใช้ฟังก์ชันแก้ไขเหตุการณ์ที่นี่
                                    _editEvent(event);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color:
                                        AllColor.IconPrimary, // กำหนดสีของไอคอน
                                  ),
                                  onPressed: () {
                                    // เรียกใช้ฟังก์ชันลบเหตุการณ์ที่นี่
                                    _deleteEvent(event);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(selectedDate: _selectedDay),
            ),
          );
          if (result == true) {
            _updateEvents(_focusedMonth);
          }
        },
        backgroundColor: AllColor.Primary, // สีพื้นหลังของปุ่ม
        foregroundColor: AllColor.IconPrimary, // สีของไอคอนภายในปุ่ม
        child: const Icon(Icons.add),
      ),
    );
  }

  // ดึงข้อมูลเหตุการณ์สำหรับเดือนที่กำลังโฟกัส
  Stream<List<Event>> _getEventsForMonth(DateTime month) {
    final startOfMonth = DateTime(month.year, month.month, 1);
    final endOfMonth = DateTime(month.year, month.month + 1, 0);
    return FirebaseFirestore.instance
        .collection('patient')
        .doc(_user!.email)
        .collection('calendar')
        .where('date',
            isGreaterThanOrEqualTo: startOfMonth, isLessThan: endOfMonth)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final eventDate = (data['date'] as Timestamp).toDate();
        return Event(
          title: data['title'],
          time: data['time'],
          date: eventDate,
        );
      }).toList();
    });
  }

  // อัปเดตวันที่ที่เลือกและโหลดเหตุการณ์สำหรับวันที่ถูกเลือก
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
    });
  }

  // ดึงข้อมูลเหตุการณ์สำหรับวันที่ถูกเลือก
  Stream<List<Event>> _fetchEventsForDay(DateTime selectedDay) {
    final startOfDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final endOfDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1);
    return FirebaseFirestore.instance
        .collection('patient')
        .doc(_user!.email)
        .collection('calendar')
        .where('date', isGreaterThanOrEqualTo: startOfDay, isLessThan: endOfDay)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        final eventDate = (data['date'] as Timestamp).toDate();
        return Event(
          title: data['title'],
          time: data['time'],
          date: eventDate,
        );
      }).toList();
    });
  }
}

class Event {
  final String title;
  final String time;
  final DateTime date;

  Event({
    required this.title,
    required this.time,
    required this.date,
  });
}

// Add Event Page
class AddEventScreen extends StatefulWidget {
  final DateTime selectedDate;

  AddEventScreen({required this.selectedDate});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  //final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  late DateTime _selectedDate;
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // ตรวจสอบว่าคุณมีส่วนนี้หรือไม่

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Event',
          style: TextStyle(
            color: AllColor.TextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AllColor.Primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'กิจกรรมของวันนี้ :',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'ชื่อของกิจกรรม'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดกรอกชื่อของกิจรรมด้วยครับ';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'เวลาเริ่มกิจกรรม'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'โปรดเลือกเวลาเริ่มกิจกรรมด้วยครับ';
                  }
                  return null;
                },
                onTap: () async {
                  final selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    _timeController.text = selectedTime.format(context);
                  }
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'วันที่เริ่มกิจกรรม : ',
                    style: TextStyle(fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2030),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      }
                    },
                    icon: Icon(Icons.calendar_today),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addEvent();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AllColor.Primary, // กำหนดสีพื้นหลังที่นี่
                  ),
                  child: Text(
                    'บันทึก',
                    style: TextStyle(fontSize: 20, color: AllColor.TextPrimary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // เพิ่มเหตุการณ์ใหม่
  void _addEvent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(user.email)
            .collection('calendar')
            .add({
          'title': _titleController.text,
          'time': _timeController.text,
          'date': Timestamp.fromDate(_selectedDate),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('เพิ่มกิจกรรมเรียบร้อยแล้ว')),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      print('Error adding event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถเพิ่มกิจกรรม')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}

class EditEventScreen extends StatefulWidget {
  final Event event;
  final Function refreshCalendar;

  const EditEventScreen({
    Key? key,
    required this.event,
    required this.refreshCalendar,
  }) : super(key: key);

  @override
  _EditEventScreenState createState() => _EditEventScreenState();
}

class _EditEventScreenState extends State<EditEventScreen> {
  late TextEditingController _titleController;
  late TextEditingController _timeController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.event.title);
    _timeController = TextEditingController(text: widget.event.time);
    _selectedDate = widget.event.date;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Event',
          style: TextStyle(
            color: AllColor.TextPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AllColor.Primary,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                'กิจกรรมของวันนี้ :',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'ชื่อของกิจกรรม'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'เวลาเริ่มกิจกรรม'),
              onTap: () async {
                final selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(_selectedDate),
                );
                if (selectedTime != null) {
                  setState(() {
                    _timeController.text = selectedTime.format(context);
                    _selectedDate = DateTime(
                      _selectedDate.year,
                      _selectedDate.month,
                      _selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                  });
                }
              },
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(
                  'วันที่เริ่มกิจกรรม : ',
                  style: TextStyle(fontSize: 20),
                ),
                IconButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2022),
                      lastDate: DateTime(2030),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _selectedDate = selectedDate;
                      });
                    }
                  },
                  icon: Icon(Icons.calendar_today),
                ),
                Text(
                  '${_selectedDate.day} / ${_selectedDate.month} / ${_selectedDate.year}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _updateEvent();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AllColor.Primary, // กำหนดสีพื้นหลังที่นี่
                ),
                child: Text(
                  'บันทึกการเปลี่ยนแปลง',
                  style: TextStyle(fontSize: 20, color: AllColor.TextPrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // อัปเดตเหตุการณ์
  void _updateEvent() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('patient')
            .doc(user.email)
            .collection('calendar')
            .where('title', isEqualTo: widget.event.title)
            .where('time', isEqualTo: widget.event.time)
            .where('date', isEqualTo: Timestamp.fromDate(widget.event.date))
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            doc.reference.update({
              'title': _titleController.text,
              'time': _timeController.text,
              'date': Timestamp.fromDate(_selectedDate),
            });
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('อัปเดตกิจกรรมเรียบร้อยแล้ว')),
        );
        Navigator.pop(context, true);
      }
    } catch (error) {
      print('Error updating event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ไม่สามารถอัปเดตกิจกรรมได้')),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _timeController.dispose();
    super.dispose();
  }
}
