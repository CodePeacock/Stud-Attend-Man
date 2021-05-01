import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/loading_screen.dart';

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
          color: kGlobalContainerColor,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5, 60, 30, 50),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        bottomRight: Radius.circular(50))),
                child: Row(
                  children: <Widget>[
                    BackButton(
                      color: kGoodColor,
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
                          color: kGlobalContainerColor,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextButton.icon(
                        label: Text('Log Out',
                            style: GoogleFonts.montserrat(
                                color: kGoodColor,
                                fontWeight: FontWeight.bold)),
                        icon: Icon(
                          Icons.exit_to_app,
                          color: kGoodColor,
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
                  color: kGlobalContainerColor,
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Color.fromRGBO(51, 204, 255, 0.3),
                  //     blurRadius: 10,
                  //     offset: Offset(0, 10),
                  //   )
                  // ],
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
            color: kGlobalContainerColor,
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
          style: GoogleFonts.lato(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      );
    } else {
      List time = _attendanceListVisible.keys.toList();
      return Center(
        child: Column(
          children: <Widget>[
            Card(
              margin: EdgeInsets.only(top: 10),
              color: Colors.white,
              // shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(20)),
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // Text(
                    //   'Subject',
                    //   style: GoogleFonts.lato(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16),
                    // ),
                    SizedBox(width: 15),
                    Text('Date',
                        style: GoogleFonts.lato(
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    SizedBox(width: 80),
                    Text('Time',
                        style: GoogleFonts.raleway(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20)),
                    SizedBox(width: 90),
                    RichText(
                      softWrap: true,
                      textAlign: TextAlign.end,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'A',
                            style: GoogleFonts.raleway(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          TextSpan(
                            text: '/',
                            style: GoogleFonts.raleway(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                          TextSpan(
                            text: 'P',
                            style: GoogleFonts.raleway(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: time.length,
                addAutomaticKeepAlives: true,
                itemBuilder: (context, index) {
                  Map data = ModalRoute.of(context).settings.arguments;
                  print(data);
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.only(top: 10),
                    color: Colors.white,
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          // FutureBuilder(
                          //   future: FirebaseFirestore.instance
                          //       .collection('users')
                          //       .doc(_auth.email)
                          //       .get(),
                          //   builder: (BuildContext context,
                          //       AsyncSnapshot<DocumentSnapshot> snapshot) {
                          //     var fullName = snapshot.data.data()['firstName'] +
                          //         ' ' +
                          //         snapshot.data.data()['lastName'];
                          //     // assert(fullName != null);
                          //     return fullName != null
                          //         ? Text(
                          //             fullName,
                          //             style: GoogleFonts.lato(
                          //                 color: Colors.black,
                          //                 fontWeight: FontWeight.bold,
                          //                 fontSize: 12),
                          //           )
                          //         : Text("No data");
                          //   },
                          // ),
                          Text(
                            '${time[index].substring(0, 10)}',
                            style: GoogleFonts.raleway(
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${time[index].substring(12, 21)} - ${time[index].substring(23, (time[index].length))}',
                            style: GoogleFonts.raleway(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          _attendanceList[time[index]]
                              ? Text(
                                  'P',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              : Text(
                                  'A',
                                  style: GoogleFonts.montserrat(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
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
