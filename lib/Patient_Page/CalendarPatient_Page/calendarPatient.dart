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
  late final User? _user;
  late final ValueNotifier<List<Event>> _selectedEvents;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _selectedEvents = ValueNotifier([]);
    _selectedDay = DateTime.now();
  }

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
          SnackBar(content: Text('Event deleted successfully')),
        );
      }
    } catch (error) {
      print('Error deleting event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete event')),
      );
    }
  }

  void _editEvent(Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEventScreen(event: event),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TableCalendar<Event>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            eventLoader: _getEventsForDay,
            onDaySelected: _onDaySelected,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
          ),
          SizedBox(height: 10),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, events, _) {
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return ListTile(
                      title: Text(event.title),
                      subtitle: Text(event.time),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // เรียกใช้ฟังก์ชันแก้ไขเหตุการณ์ที่นี่
                              _editEvent(event);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // เรียกใช้ฟังก์ชันลบเหตุการณ์ที่นี่
                              _deleteEvent(event);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEventScreen()),
              );
            },
            child: Text('Add Event'),
          ),
        ],
      ),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _selectedEvents.value.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    final events = await _fetchEventsForDay(selectedDay);
    setState(() {
      _selectedEvents.value = events;
      _selectedDay = selectedDay;
    });
  }

  Future<List<Event>> _fetchEventsForDay(DateTime selectedDay) async {
    final startOfDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day);
    final endOfDay =
        DateTime(selectedDay.year, selectedDay.month, selectedDay.day + 1);
    final snapshot = await FirebaseFirestore.instance
        .collection('patient')
        .doc(_user!.email)
        .collection('calendar')
        .where('date', isGreaterThanOrEqualTo: startOfDay, isLessThan: endOfDay)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      final eventDate = (data['date'] as Timestamp).toDate();
      return Event(
        title: data['title'],
        time: data['time'],
        date: eventDate,
      );
    }).toList();
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

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Event Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _timeController,
                decoration: InputDecoration(labelText: 'Event Time'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event time';
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
                  Text('Event Date: '),
                  TextButton(
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
                    child: Text(
                      '${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addEvent();
                  }
                },
                child: Text('Save Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
          SnackBar(content: Text('Event added successfully')),
        );
        // อัพเดท UI ด้วย setState เพื่อให้แสดงการเปลี่ยนแปลงทันที
        setState(() {});
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error adding event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add event')),
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

  const EditEventScreen({Key? key, required this.event}) : super(key: key);

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
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Event Time'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Event Date: '),
                TextButton(
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
                  child: Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateEvent();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

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
          SnackBar(content: Text('Event updated successfully')),
        );
        // อัพเดท UI ด้วย setState เพื่อให้แสดงการเปลี่ยนแปลงทันที
        setState(() {});
        Navigator.pop(context);
      }
    } catch (error) {
      print('Error updating event: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update event')),
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
