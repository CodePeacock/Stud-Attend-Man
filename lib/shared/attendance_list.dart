import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/loading_screen.dart';

import 'formatting.dart';

class AttendanceList extends StatefulWidget {
  @override
  _AttendanceListState createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  final GetAttendance _attendance = GetAttendance();

  Map _attendanceList = {};
  Map _attendanceListVisible = {};

  Future setup(String teacherEmail, String subject, String batch,
      String studentEmail) async {
    _attendanceList = await _attendance.getAttendance(
        teacherEmail, subject, batch, studentEmail);
    _attendanceListVisible = _attendanceList;
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5, 60, 30, 50),
                decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Row(
                  children: <Widget>[
                    BackButton(
                      color: Colors.white70,
                    ),
                    Expanded(
                        child: Text(
                      'Attendance',
                      style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextButton.icon(
                        label: Text('Log Out',
                            style: TextStyle(
                                color: Colors.cyan,
                                fontWeight: FontWeight.bold)),
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.cyan,
                          size: 15,
                        ),
                        onPressed: () async {
                          dynamic result = await UserModel().signOut();
                          if (result == null) {
                            Navigator.of(context)
                                .pushReplacementNamed('/authentication');
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(40, 130, 40, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(51, 204, 255, 0.3),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    )
                  ],
                ),
                child: Container(
                  padding: EdgeInsets.all(6.5),
                  child: TextFormField(
                    decoration: authInputFormatting.copyWith(
                        hintText: "Search By Date or Time"),
                    onChanged: (val) {
                      setState(() {
                        _attendanceListVisible = Map.from(_attendanceList)
                          ..removeWhere((k, v) => !k.toString().contains(val));
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            color: Colors.white,
            child: EnhancedFutureBuilder(
              future: setup(data['teacherEmail'], data['subject'],
                  data['batch'], data['studentEmail']),
              rememberFutureResult: true,
              whenNotDone: LoadingScreen(),
              whenDone: (arg) => showAttendance(),
            ),
          ),
        ),
      ],
    ));
  }

  Widget showAttendance() {
    if (_attendanceList == null) {
      return Center(
        child: Text(
          'No Attendance Found !',
          style: TextStyle(
              color: Colors.cyan, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      );
    } else {
      List time = _attendanceListVisible.keys.toList();
      return Center(
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Teacher',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text(
                      'Date',
                      style: GoogleFonts.lato(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    Text('Time',
                        style: GoogleFonts.lato(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                    Text('A/P',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: time.length,
                itemBuilder: (context, index) {
                  Map data = ModalRoute.of(context).settings.arguments;
                  // print(data);
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        children: <Widget>[
                          FutureBuilder(
                            future: FirebaseFirestore.instance
                                .collection('users')
                                .doc('fighterapache101@gmail.com')
                                .get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              var fullName = snapshot.data.data()['fistName'] +
                                  ' ' +
                                  snapshot.data.data()['lastName'];
                              return fullName != null
                                  ? Text(
                                      fullName,
                                      style: GoogleFonts.lato(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    )
                                  : Text("No data");
                            },
                          ),
                          Text(
                            '${time[index].substring(0, 10)}',
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                          Text(
                            '${time[index].substring(12, 21)} \n to ${time[index].substring(23, (time[index].length))}',
                            style: TextStyle(color: Colors.black),
                          ),
                          _attendanceList[time[index]]
                              ? Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.red,
                                ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }
}
