import 'package:care_patient/Patient_Page/ShowPage/page1.dart';
import 'package:care_patient/Patient_Page/main_PatientUI.dart';
import 'package:care_patient/login_ui.dart';
import 'package:care_patient/class/firebase_options.dart';
import 'package:care_patient/test.dart';
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

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

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
            .Primary, // กำหนดสีพื้นหลังที่ต้องการให้กับ Bottom Navigation Bar
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 3.0,
            ),
          ),
        ),
      ),
      home: const Calendar(),
    );
  }
}
