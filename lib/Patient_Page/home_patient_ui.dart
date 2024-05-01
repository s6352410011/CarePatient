import 'dart:async';
import 'package:care_patient/Patient_Page/ShowPage/page1.dart';
import 'package:care_patient/Patient_Page/ShowPage/page2.dart';
import 'package:care_patient/Patient_Page/ShowPage/page3.dart';
import 'package:care_patient/test.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:care_patient/Patient_Page/allcaregiver_ui.dart';
import 'package:care_patient/class/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePatientUI extends StatefulWidget {
  const HomePatientUI({Key? key}) : super(key: key);

  @override
  State<HomePatientUI> createState() => _HomePatientUIState();
}

class _HomePatientUIState extends State<HomePatientUI> {
  final PageController controller =
      PageController(viewportFraction: 0.8, keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startLoop();
  }

  void _startLoop() {
    Timer.periodic(Duration(seconds: 5), (_) {
      if (_currentPage < 2) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (mounted) {
        controller.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AllColor.Backgroud,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15.0),
          AppBarWidget(),
          PageViewWidget(controller: controller),
          buildRowWithNames(context, ['รายชื่อผู้ดูแล', 'รายชื่อทั้งหมด']),
          const SizedBox(height: 15.0),
          UserDataWidget(),
          const SizedBox(height: 15.0),
        ],
      ),
    );
  }
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
          child: Text('คุณ ' + '(❁´◡`❁)'),
        ),
      ],
    );
  }
}

class PageViewWidget extends StatelessWidget {
  final PageController controller;

  const PageViewWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageViewWithIndicator(
      controller: controller,
      pages: [
        ShowPage1(),
        ShowPage2(),
        ShowPage3(),
      ],
      colors: [
        AllColor.DotsPrimary,
        AllColor.DotsSecondary,
        AllColor.DotsThird,
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
    Timer.periodic(Duration(seconds: 2), (timer) {
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
        await FirebaseFirestore.instance.collection('general').get();
    List<String> names = [];
    querySnapshot.docs.forEach((doc) {
      final data = doc.data();
      if (data != null) {
        final name = (data as Map<String, dynamic>)['Name'] as String?;
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
        builder: (context) => AllCareGiverUI(),
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

Widget buildRowWithNames(BuildContext context, List<String> labels) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: labels.map((label) {
      IconData iconData;
      Color iconColor;

      if (label == 'รายชื่อผู้ดูแล') {
        iconData = Icons.recent_actors;
        iconColor = AllColor.Primary;
      } else if (label == 'รายชื่อทั้งหมด') {
        iconData = Icons.list;
        iconColor = AllColor.Secondary;
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AllCareGiverUI(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Icon(iconData, color: iconColor),
          ),
        );
      } else {
        iconData = Icons.error;
        iconColor = Colors.grey;
      }

      return InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Icon(iconData, color: iconColor),
              SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  color: AllColor.TextSecondary,
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
