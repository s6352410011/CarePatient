import 'package:care_patient/class/color.dart';
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
  const CalendarUI({super.key});

  @override
  State<CalendarUI> createState() => _CalendarUIState();
}

class _CalendarUIState extends State<CalendarUI> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late Map<DateTime, List<dynamic>> _events;
  final TextEditingController _eventController = TextEditingController();
  TimeOfDay? _selectedTime; // Store the selected time

  String _buddhistDate(DateTime date) {
    final DateFormat formatter = DateFormat('d MMMM พ.ศ. yyyy', 'th');
    final buddhist = DateTime(date.year + 543, date.month, date.day);
    return formatter.format(buddhist);
  }

  Widget _headerStyle(BuildContext context, DateTime date) {
    final buddhist = date.year + 543;
    final headerText = DateFormat('MMMM พ.ศ. $buddhist', 'th').format(date);

    return Text(
      headerText,
    );
  }

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
                                  ? 'เลือกเวลาเริ่มกิจกรรม'
                                  : 'เวลา: ${_selectedTime!.hour.toString().padLeft(2, '0')} : ${_selectedTime!.minute.toString().padLeft(2, '0')}',
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

  void _saveEvent() {
    if (_eventController.text.isNotEmpty) {
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
        backgroundColor: AllColor.Primary,
        title: const Text('ปฏิทิน'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEvent,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TableCalendar(
              locale: 'th_TH', // 'en_US
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
                headerTitleBuilder: _headerStyle,
                defaultBuilder: (context, day, events) {
                  final hasEvent =
                      _events.containsKey(day) && _events[day]!.isNotEmpty;
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSameDay(day, _selectedDay)
                          ? Colors.blue
                          : hasEvent
                              ? Colors.amber
                              : Colors.transparent,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(
                        color: isSameDay(day, _selectedDay) || hasEvent
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  );
                },
              ),
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
              height: 20.0,
              color: Colors.grey[300],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 5),
              child: Text(
                'กิจกรรมของวันที่ ${_buddhistDate(_selectedDay)}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
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
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                            subtitle:
                                Text(DateFormat.Hm().format(eventDateTime)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    _eventController.text = event;
                                    _selectedTime =
                                        TimeOfDay.fromDateTime(eventDateTime);
                                    await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (BuildContext context,
                                              StateSetter setState) {
                                            return AlertDialog(
                                              title: const Text('แก้ไขกิจกรรม'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        _eventController,
                                                    decoration:
                                                        const InputDecoration(
                                                      hintText:
                                                          'ป้อนชื่อกิจกรรมของคุณ',
                                                    ),
                                                    onSaved: (value) {},
                                                  ),
                                                  const SizedBox(height: 20),
                                                  InkWell(
                                                    onTap: () async {
                                                      final TimeOfDay?
                                                          pickedTime =
                                                          await showTimePicker(
                                                        context: context,
                                                        initialTime:
                                                            _selectedTime ??
                                                                TimeOfDay.now(),
                                                        builder: (BuildContext
                                                                context,
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
                                                        const Icon(
                                                            Icons.access_time),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          _selectedTime == null
                                                              ? 'เลื่อกเวลาที่ทำกิจกรรม'
                                                              : 'เวลา: ${_selectedTime!.hour.toString().padLeft(2, '0')} : ${_selectedTime!.minute.toString().padLeft(2, '0')}',
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16),
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
                                                  child: const Text('ยกเลิก'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    final updatedEvent =
                                                        _eventController
                                                                .text.isNotEmpty
                                                            ? _eventController
                                                                .text
                                                            : event;
                                                    final DateTime
                                                        updatedDateTime =
                                                        DateTime(
                                                      _selectedDay.year,
                                                      _selectedDay.month,
                                                      _selectedDay.day,
                                                      _selectedTime?.hour ??
                                                          eventDateTime.hour,
                                                      _selectedTime?.minute ??
                                                          eventDateTime.minute,
                                                    );
                                                    setState(() {
                                                      if (_eventController.text
                                                              .isNotEmpty ||
                                                          _selectedTime !=
                                                              null) {
                                                        _events[
                                                            updatedDateTime] = [
                                                          updatedEvent
                                                        ];
                                                        if (updatedDateTime !=
                                                            entry.key) {
                                                          _events.remove(
                                                              entry.key);
                                                        }
                                                      }
                                                    });
                                                    _eventController.clear();
                                                    _selectedTime = null;
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
                                    setState(() {});
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text("ตกลง"),
                                          content: const Text(
                                              "คุณต้องการลบกิจกรรมนี้ ใช่หรือไม่?"),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text("ไม่ใช่"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text("ใช่"),
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
                  return const SizedBox.shrink();
                }
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
