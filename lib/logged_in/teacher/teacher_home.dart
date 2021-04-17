import 'package:flutter/material.dart';
import 'package:stud_attend_man/logged_in/teacher/subjects.dart';

class TeacherHome extends StatefulWidget {
  @override
  _TeacherHomeState createState() => _TeacherHomeState();
}

class _TeacherHomeState extends State<TeacherHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Subjects(),
    );
  }
}
