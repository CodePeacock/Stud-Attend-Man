import 'package:flutter/material.dart';
import 'package:stud_attend_man/logged_in/student/student_home.dart';
import 'package:stud_attend_man/logged_in/teacher/teacher_home.dart';
import 'package:stud_attend_man/logged_in/verification.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEmailVerified;
  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    String type = data['type'];
    isEmailVerified = data['isEmailVerified'];
    Widget homeScreen;
    homeScreen = type == 'Student' ? StudentHome() : TeacherHome();
    return isEmailVerified ? homeScreen : VerifyEmail();
  }
}
