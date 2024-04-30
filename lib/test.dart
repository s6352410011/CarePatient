import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:care_patient/Patient_Page/ShowPage/page1.dart';
import 'package:care_patient/Patient_Page/ShowPage/page2.dart';
import 'package:care_patient/Patient_Page/ShowPage/page3.dart';
import 'package:care_patient/class/color.dart';

class PageViewWithIndicator extends StatelessWidget {
  final PageController controller;
  final List<Widget> pages;
  final List<Color> colors;

  const PageViewWithIndicator({
    Key? key,
    required this.controller,
    required this.pages,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 16),
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: controller,
            itemCount: pages.length,
            itemBuilder: (_, index) {
              return pages[index % pages.length];
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          child: Center(
            child: SmoothPageIndicator(
              controller: controller,
              count: pages.length,
              effect: CustomizableEffect(
                activeDotDecoration: DotDecoration(
                  width: 100,
                  height: 12,
                  color: colors[0], // สี dots สถานะที่ 1
                  rotationAngle: 180,
                  verticalOffset: -10,
                  borderRadius: BorderRadius.circular(24),
                ),
                dotDecoration: DotDecoration(
                  width: 24,
                  height: 12,
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(16),
                  verticalOffset: 0,
                ),
                spacing: 10.0, // ระยะห่างระหว่าง dots
                inActiveColorOverride: (i) =>
                    colors[i], // เลือกสี dots ในสถานะที่ไม่ได้ active
              ),
            ),
          ),
        ),
        const SizedBox(height: 32.0),
      ],
    );
  }
}

class TestUI extends StatefulWidget {
  const TestUI({Key? key}) : super(key: key);

  @override
  State<TestUI> createState() => _TestUIState();
}

class _TestUIState extends State<TestUI> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _startLoop();
  }

  void _startLoop() {
    Future.delayed(Duration(seconds: 5), () {
      if (_currentPage < 3) {
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
        _startLoop();
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
    final pages = <Widget>[
      ShowPage1(),
      ShowPage2(),
      ShowPage3(),
    ];

    final colors = <Color>[
      AllColor.DotsPrimary,
      AllColor.DotsSecondary,
      AllColor.DotsThird,
    ];

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageViewWithIndicator(
            controller: controller,
            pages: pages,
            colors: colors,
          ),
        ),
      ),
    );
  }
}
