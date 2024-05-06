import 'dart:async';
import 'package:care_patient/Caregiver_Page/CalendarCare_Page/calendarCare.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/Caregiver_Page/data_patient_ui.dart';
import 'package:care_patient/Pages/historywork_ui.dart';
import 'package:care_patient/Pages/map_ui.dart';
import 'package:care_patient/Pages/review_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeCaregiverUI extends StatefulWidget {
  @override
  _HomeCaregiverUIState createState() => _HomeCaregiverUIState();
}

class _HomeCaregiverUIState extends State<HomeCaregiverUI> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<String> labels = ['ปฏิทิน', 'แผนที่', 'ประวัติการทำงาน', 'คะแนนรีวิว'];

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppBarWidget(),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: buildCarousel(labels),
            ),
            SizedBox(height: 10),
            buildDots(labels.length),
            const SizedBox(height: 20.0),
            buildRowTabBar(context, ['กำลังดำเนินการ']),
            buildCardWithContact(context),
            buildCardWithNoHire(context),
            UserDataWidget(),
          ],
        ),
      ),
    );
  }

  Widget buildCarousel(List<String> labels) {
    return SizedBox(
      height: 150,
      child: PageView.builder(
        itemCount: labels.length,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        itemBuilder: (context, index) {
          return buildSlide(labels[index]);
        },
      ),
    );
  }

  Widget buildSlide(String label) {
    IconData iconData;
    Color iconColor;

    switch (label) {
      case 'ปฏิทิน':
        iconData = Icons.calendar_today;
        iconColor = Colors.blue;
        break;
      case 'ประวัติการทำงาน':
        iconData = Icons.history;
        iconColor = Colors.green;
        break;
      case 'แผนที่':
        iconData = Icons.map;
        iconColor = Colors.red;
        break;
      case 'คะแนนรีวิว':
        iconData = Icons.star;
        iconColor = Colors.yellow;
        break;
      default:
        iconData = Icons.error;
        iconColor = Colors.grey;
        break;
    }
    return GestureDetector(
      // Change InkWell to GestureDetector
      onTap: () {
        switch (label) {
          case 'ปฏิทิน':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CalendarCareUI(),
              ),
            );
            break;
          case 'ประวัติการทำงาน':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HistoryWorkPage(),
              ),
            );
            break;
          case 'แผนที่':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MapPage(),
              ),
            );
            break;
          case 'คะแนนรีวิว':
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewPage(),
              ),
            );
            break;
          default:
            break;
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, color: iconColor, size: 100),
            SizedBox(height: 5),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget buildDots(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == _selectedIndex
                ? Colors.blue
                : Colors.grey, // color Dots
          ),
        ),
      ),
    );
  }

  Widget buildRowTabBar(BuildContext context, List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 5),
                Text(
                  'กำลังดำเนินการ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCardWithContact(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataPatientUI()),
            );
          },
          child: SizedBox(
            height: 80,
            child: Card(
              color: Colors.blue,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ชื่อผู้ป่วย',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.white),
                          onPressed: () {},
                        ),
                        SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.chat, color: Colors.white),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCardWithNoHire(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DataPatientUI()),
            );
          },
          child: SizedBox(
            height: 80,
            child: Card(
              color: Colors.blue,
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    'ยังไม่มีการว่าจ้างในขณะนี้ <(＿　＿)>',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> getName() async {
  String email = FirebaseAuth.instance.currentUser!.email!;
  DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('patient').doc(email).get();
  return userDoc['name'];
}

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('สวัสดี'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FutureBuilder(
            future: getName(),
            builder: (context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Text('คุณ ${snapshot.data}');
                }
              }
            },
          ),
        ),
      ],
    );
  }
}

class UserDataWidget extends StatefulWidget {
  const UserDataWidget({Key? key}) : super(key: key);

  @override
  _UserDataWidgetState createState() => _UserDataWidgetState();
}

class _UserDataWidgetState extends State<UserDataWidget> {
  late Future<List<String>> _userDataFuture;
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _loadUserData();
    _pageController =
        PageController(viewportFraction: 0.8, initialPage: _currentPage);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    Timer.periodic(Duration(seconds: 20), (timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<List<String>> _loadUserData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('caregiver').get();
    List<String> names = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      if (data != null) {
        final name = (data as Map<String, dynamic>)['name'] as String?;
        if (name != null) {
          names.add(name);
        }
      }
    });
    return names;
  }

  void _onCardClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DataPatientUI(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _userDataFuture,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Text('เกิดข้อผิดพลาด: ${snapshot.error}');
        }
        List<String> names = snapshot.data!;
        return Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: names.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _onCardClicked,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    color: AllColor.Secondary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.account_circle,
                          color: AllColor.IconPrimary),
                      title: Text(
                        names[index],
                        style: TextStyle(
                          color: AllColor.TextPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
