import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/logged_in/home.dart';
import 'package:stud_attend_man/logged_in/teacher/add_students.dart';
import 'package:stud_attend_man/logged_in/teacher/attendance.dart';
import 'package:stud_attend_man/logged_in/teacher/batches.dart';
import 'package:stud_attend_man/logged_in/teacher/students.dart';
import 'package:stud_attend_man/logged_out/authentication.dart';
import 'package:stud_attend_man/shared/account_settings.dart';
import 'package:stud_attend_man/shared/attendance_list.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/loading_screen.dart';
import 'package:stud_attend_man/shared/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(SamApp());
}

class SamApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // User user = FirebaseAuth.instance.currentUser;
    return StreamProvider<User>.value(
      value: UserModel().account,
      initialData: null,
      lazy: true,
      child: MaterialApp(
        checkerboardOffscreenLayers: true,
        debugShowCheckedModeBanner: false,
        title: 'S.A.M',
        home: SplashScreen(),
        theme: ThemeData.dark().copyWith(
          appBarTheme: AppBarTheme(
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: kGoodColor),
              elevation: 10,
              titleSpacing: 1.0,
              textTheme:
                  TextTheme(headline6: GoogleFonts.quicksand(fontSize: 17))),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dialogTheme: DialogTheme(
            backgroundColor: kGlobalContainerColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            titleTextStyle: GoogleFonts.ubuntu(color: Colors.black),
            contentTextStyle: GoogleFonts.nunito(),
            elevation: 35.0,
          ),
          buttonTheme: ButtonThemeData(
              layoutBehavior: ButtonBarLayoutBehavior.padded,
              textTheme: ButtonTextTheme.accent),
          textTheme: TextTheme(
              subtitle1: GoogleFonts.nunito(), button: GoogleFonts.rubik()),
        ),
        routes: {
          '/batches': (context) => Batches(),
          LoadingScreen.id: (context) => LoadingScreen(),
          '/sandbox': (context) => SplashScreen(),
          '/enrolledStudents': (context) => EnrolledStudents(),
          '/addStudents': (context) => AddStudents(),
          '/addAttendance': (context) => AddAttendance(),
          '/attendanceList': (context) => AttendanceList(),
          '/home': (context) => Home(),
          SplashScreen.id: (context) => SplashScreen(),
          '/authentication': (context) => Authentication(),
          '/accountSettings': (context) => AccountSettings(),
        },
      ),
    );
  }
}
