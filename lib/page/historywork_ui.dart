import 'package:flutter/material.dart';
import 'package:care_patient/color.dart';

class HistoryWorkPage extends StatefulWidget {
  const HistoryWorkPage({Key? key}) : super(key: key);

  @override
  State<HistoryWorkPage> createState() => _HistoryWorkPageState();
}

class _HistoryWorkPageState extends State<HistoryWorkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ประวัติการทำงาน',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AllColor.pr,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'เสร็จสิ้น',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Tab(
              child: Text(
                'ล้มเหลว',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
          indicatorColor: Colors.white,
        ),
      ),
      body: Container(
        color: AllColor.bg,
        child: TabBarView(
          controller: _tabController,
          children: [
            Center(
              child: Text(
                'เสร็จสิ้น',
                style: TextStyle(
                  color: AllColor.sc,
                  fontSize: 24,
                ),
              ),
            ),
            Center(
              child: Text(
                'ล้มเหลว',
                style: TextStyle(
                  color: AllColor.sc,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
