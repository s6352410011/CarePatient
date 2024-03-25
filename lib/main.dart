import 'package:care_patient/Calendar_Page/calendar.dart';
import 'package:care_patient/Patient_Page/home_PatientUI.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/class/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:care_patient/class/color.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('th_TH', null);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        canvasColor: AllColor
            .pr, // กำหนดสีพื้นหลังที่ต้องการให้กับ Bottom Navigation Bar
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: BorderSide(
              color: Colors.red,
              width: 3.0,
            ),
          ),
        ),
      ),
      home: CalendarUI(),
    );
  }
}
