import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

extension DayBuilderExt on CalendarBuilders {
  Widget Function(BuildContext, DateTime, List<dynamic>) get dayBuilder =>
      (context, day, events) {
        final hasEvent = events.isNotEmpty;
        return Container(
          margin: const EdgeInsets.all(4.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasEvent ? Colors.amber : Colors.transparent,
          ),
          child: Text(
            day.day.toString(),
            style: TextStyle(
              color: hasEvent ? Colors.white : Colors.black,
            ),
          ),
        );
      };
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
  TimeOfDay? _selectedTime; // Store the selected time

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
        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[200],
              title: Text('Add Event'),
              content: Container(
                width: 300,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        hintText: 'Event Name',
                      ),
                      onSaved: (value) {},
                    ),
                    SizedBox(
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
                          Icon(Icons.access_time),
                          SizedBox(width: 5),
                          Text(
                            _selectedTime == null
                                ? 'Select Time'
                                : 'Time: ${_selectedTime!.hour.toString().padLeft(2, '0')} : ${_selectedTime!.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 20,
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
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _saveEvent();
                    _eventController.clear();
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
  }

  void _saveEvent() {
    if (_selectedDay != null && _eventController.text.isNotEmpty) {
      setState(() {
        final newEvent = _eventController.text;
        final DateTime eventDateTime = DateTime(
          _selectedDay.year,
          _selectedDay.month,
          _selectedDay.day,
          _selectedTime != null ? _selectedTime!.hour : 0,
          _selectedTime != null ? _selectedTime!.minute : 0,
        );

        if (_events.containsKey(eventDateTime)) {
          _events[eventDateTime]!.add(newEvent);
        } else {
          _events[eventDateTime] = [newEvent];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
            TableCalendar(
              locale: 'en_US',
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
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, events) {
                  final hasEvent =
                      _events.containsKey(day) && _events[day]!.isNotEmpty;
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasEvent ? Colors.amber : Colors.transparent,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: hasEvent ? Colors.white : Colors.black,
                      ),
                    ),
                  );
                },
              ),
              availableCalendarFormats: const {
                CalendarFormat.month: 'Month',
                CalendarFormat.week: 'Week',
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
              height: 20.0,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5),
              child: Text(
                'Events:',
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
                      final String event = eventEntry.value;
                      final DateTime eventDateTime = entry.key;

                      return Padding(
                        padding:
                            const EdgeInsets.only(top: 5, left: 10, right: 10),
                        child: Card(
                          color: _selectedDay == entry.key
                              ? Colors.grey[300]
                              : Colors.transparent,
                          child: ListTile(
                            title: Text(
                              event,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle:
                                Text(DateFormat.Hm().format(eventDateTime)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Edit Event'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                controller: _eventController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      'Enter your event name',
                                                ),
                                                onSaved: (value) {},
                                              ),
                                              SizedBox(
                                                  height:
                                                      20), // เพิ่มระยะห่างระหว่างช่องใส่ข้อความและเวลา
                                              InkWell(
                                                onTap: () async {
                                                  // เลือกเวลา
                                                  final TimeOfDay? pickedTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    builder:
                                                        (BuildContext context,
                                                            Widget? child) {
                                                      return MediaQuery(
                                                        data: MediaQuery.of(
                                                                context)
                                                            .copyWith(
                                                                alwaysUse24HourFormat:
                                                                    true),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (pickedTime != null) {
                                                    setState(() {
                                                      _selectedTime =
                                                          pickedTime;
                                                    });
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(Icons
                                                        .access_time), // เพิ่มไอคอนเวลา
                                                    SizedBox(
                                                      width: 5,
                                                    ), // ระยะห่างระหว่างไอคอนกับข้อความ
                                                    Text(
                                                      _selectedTime == null
                                                          ? 'Select Time'
                                                          : 'Time: ${_selectedTime!.hour.toString().padLeft(2, '0')} : ${_selectedTime!.minute.toString().padLeft(2, '0')}',
                                                      style: TextStyle(
                                                        fontSize:
                                                            16, // ปรับขนาดอักษร
                                                      ),
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
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                if (_selectedDay != null &&
                                                    _eventController
                                                        .text.isNotEmpty) {
                                                  setState(() {
                                                    final updatedEvent =
                                                        _eventController.text;
                                                    final DateTime
                                                        updatedDateTime =
                                                        _selectedTime != null
                                                            ? DateTime(
                                                                _selectedDay
                                                                    .year,
                                                                _selectedDay
                                                                    .month,
                                                                _selectedDay
                                                                    .day,
                                                                _selectedTime!
                                                                    .hour,
                                                                _selectedTime!
                                                                    .minute,
                                                              )
                                                            : eventDateTime; // ใช้เวลาเดิมถ้าไม่ได้เลือกเวลาใหม่
                                                    _events[entry.key]![
                                                            eventEntry.key] =
                                                        updatedEvent;
                                                  });
                                                }
                                                _eventController.clear();
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Save'),
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
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm"),
                                          content: Text(
                                              "Are you sure you want to delete this event?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Confirm"),
                                              onPressed: () {
                                                setState(() {
                                                  _events[entry.key]!
                                                      .remove(event);
                                                });
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
