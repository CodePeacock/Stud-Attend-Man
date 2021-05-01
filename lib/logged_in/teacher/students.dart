import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/sam_logo.dart';
import 'package:stud_attend_man/shared/teacher_drawer_header.dart';

class EnrolledStudents extends StatefulWidget {
  @override
  _EnrolledStudentsState createState() => _EnrolledStudentsState();
}

class _EnrolledStudentsState extends State<EnrolledStudents> {
  TeacherSubjectsAndBatches _tSAB;
  Map _studentsMap = {};
  List<String> _students = [];
  List<String> _studentsVisible = [];
  String _subject = '';
  String _batch = '';
  String _error = '';
  String _userName = '';
  bool _removeStudents = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  Future setup(User user, String sub, String batchCopy) async {
    _tSAB = TeacherSubjectsAndBatches(user);
    _studentsMap = await _tSAB.getStudents(sub, batchCopy);
    if (_studentsMap == null) {
      _students = ['Couldn\'t get students, try again'];
    } else {
      _students = _studentsMap.keys.where((key) => key != 'Empty').toList();
      _studentsVisible = _students;
      // print(_studentsMap);
      // print(_studentsVisible);
      print(_students);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _subject = data['subject'];
    _batch = data['batch'];
    _userName = data['userName'];
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: Column(
            children: <Widget>[
              TeacherDrawerHeader(userName: _userName),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.black),
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Add Student',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          dynamic returnedData = await Navigator.pushNamed(
                              context, '/addStudents', arguments: {
                            'enrolledStudents': _students,
                            'batch': _batch,
                            'subject': _subject
                          });
                          if (returnedData != null) {
                            if (_studentsMap['Empty']) {
                              _studentsMap['Empty'] = false;
                            }
                            setState(() {
                              _studentsMap['${returnedData['studentAdded']}'] =
                                  false;
                              _students.add(returnedData['studentAdded']);
                              _studentsVisible
                                  .add(returnedData['studentAdded']);
                            });
                          }
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Remove Student',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          setState(() {
                            _removeStudents = true;
                          });
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Add Attendance',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          await Navigator.pushNamed(context, '/addAttendance',
                              arguments: {
                                'enrolledStudents': _students,
                                'subject': _subject,
                                'batch': _batch
                              });
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Account Settings',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/accountSettings');
                        },
                      ),
                      AboutListTile(
                        applicationName: 'S.A.M',
                        applicationVersion: '0.6',
                        applicationIcon: SamLogo(
                          height: 50,
                          width: 50,
                        ),
                        applicationLegalese: 'Made possible by Flutter',
                        // aboutBoxChildren: [
                        //   TextButton(
                        //     child: Text(
                        //       'Learn More',
                        //       style:
                        //           GoogleFonts.montserrat(color: Colors.black),
                        //     ),
                        //     onPressed: _launchURL,
                        //   ),
                        // ],
                        child: Text(
                          'About S.A.M',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
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
                          'Students',
                          style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: kGlobalContainerColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
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
                        ),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(6.5),
                            child: TextFormField(
                              style: GoogleFonts.lato(color: Colors.white),
                              decoration: authInputFormatting.copyWith(
                                hintText: "Search By ID",
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(121, 121, 121, 1.0)),
                                border: InputBorder.none,
                                fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _studentsVisible = _students
                                      .where((student) => student
                                          .toLowerCase()
                                          .startsWith(val.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.menu, color: kGoodColor),
                          onPressed: () {
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                        ),
                        SizedBox(
                          width: 5,
                        )
                      ],
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
                  future: setup(Provider.of<User>(context), _subject, _batch),
                  rememberFutureResult: true,
                  whenNotDone: LoadingData(),
                  whenDone: (arg) => studentList(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget studentList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _studentsMap['Empty'] ? addStudentButton() : Container(),
          _removeStudents && !_studentsMap['Empty']
              ? removeStudent()
              : Container(),
          _studentsMap['Empty']
              ? SizedBox(
                  height: 15,
                )
              : Container(),
          _studentsMap['Empty']
              ? Expanded(
                  child: Text(
                    'You Need To Add Students',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _studentsVisible.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        color: kGlobalCardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            trailing: _removeStudents
                                ? Icon(
                                    Icons.delete,
                                    color: kGoodColor,
                                  )
                                : Icon(
                                    Icons.forward,
                                    color: kGoodColor,
                                  ),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  '${_studentsVisible[index]}' != null
                                      ? '${_studentsVisible[index]}'
                                      : 'Loading Data',
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    // decoration: TextDecoration.underline,
                                    // decorationStyle: TextDecorationStyle.wavy,
                                    // shadows: [
                                    //   Shadow(
                                    //     color: Colors.black,
                                    //     blurRadius: 8,
                                    //     offset: Offset(0, 10),
                                    //   ),
                                    // ],
                                  ),
                                )),
                              ],
                            ),
                            onTap: () async {
                              if (_removeStudents) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        backgroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0)),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 20),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Text(
                                                "Are you sure you want to remove ${_studentsVisible[index]}? This action can\'t be reverted.",
                                                textAlign: TextAlign.justify,
                                                style: GoogleFonts.montserrat(
                                                    color: Colors.cyanAccent),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    child: TextButton(
                                                      child: Text(
                                                        'Cancel',
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color: Colors
                                                                    .green),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: TextButton(
                                                      child: Text(
                                                        'Delete',
                                                        style:
                                                            GoogleFonts.raleway(
                                                                color:
                                                                    Colors.red),
                                                      ),
                                                      onPressed: () async {
                                                        dynamic result = await _tSAB
                                                            .deleteStudent(
                                                            _subject,
                                                            _batch,
                                                            _studentsVisible[
                                                            index]);
                                                        String deleted =
                                                        _studentsVisible[
                                                        index];
                                                        if (result ==
                                                            'Success') {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            _error = '';
                                                            _studentsVisible
                                                                .remove(
                                                                deleted);
                                                            _students.remove(
                                                                deleted);
                                                            _studentsMap
                                                                .removeWhere((key,
                                                                value) =>
                                                            key ==
                                                                deleted);
                                                          });
                                                          if (_students
                                                              .isEmpty) {
                                                            setState(() {
                                                              _removeStudents =
                                                              false;
                                                              _studentsMap[
                                                              'Empty'] =
                                                              true;
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _error =
                                                            "Couldn't delete ${_studentsVisible[index]}";
                                                          });
                                                          Navigator.of(context)
                                                              .pop();
                                                        }
                                                      },
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              } else {
                                if (_studentsMap[_studentsVisible[index]]) {
                                  print(_studentsMap[_studentsVisible[index]]);
                                  Navigator.pushNamed(
                                      context, '/attendanceList',
                                      arguments: {
                                        'teacherEmail': Provider.of<User>(
                                                context,
                                                listen: false)
                                            .email,
                                        'subject': _subject,
                                        'batch': _batch,
                                        'studentEmail': _studentsVisible[index],
                                      });
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0)),
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 20),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 30,
                                                ),
                                                Text(
                                                  'This enrollment has not been accepted by the student.',
                                                  textAlign: TextAlign.justify,
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                TextButton(
                                                  child: Text(
                                                    'Close',
                                                    style: TextStyle(
                                                        color: Colors.cyan),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }
                            },
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

  Widget addStudentButton() {
    return GestureDetector(
      onTap: () async {
        dynamic data = await Navigator.pushNamed(context, '/addStudents',
            arguments: {
              'enrolledStudents': _students,
              'batch': _batch,
              'subject': _subject
            });
        print(data);
        if (data != null) {
          if (_studentsMap['Empty']) {
            _studentsMap['Empty'] = false;
          }
          setState(() {
            _studentsMap['${data['studentAdded']}'] = false;
            _students.add(data['studentAdded']);
            _studentsVisible.add(data['studentAdded']);
          });
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.person_add_alt_1_rounded,
              color: kGoodColor,
              size: 23,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Student',
              style: GoogleFonts.sourceSansPro(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget removeStudent() {
    return Column(
      children: <Widget>[
        _error == ''
            ? Container()
            : Center(
                child: Text(
                  '$_error',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
        _error == ''
            ? Container()
            : SizedBox(
                height: 15,
              ),
        GestureDetector(
          onTap: () {
            setState(() {
              _removeStudents = !_removeStudents;
              _error = '';
            });
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.check_rounded,
                  color: kGoodColor,
                  size: 23,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Done',
                  style: GoogleFonts.sourceSansPro(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
