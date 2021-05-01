import 'dart:ui';

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

class Subjects extends StatefulWidget {
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  List<String> _subjects = [];
  List<String> _subjectsVisible = [];
  bool _delete = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String _subject = ' ';
  String _error = ' ';
  String _userName = '';
  // String _email = '';
  TeacherSubjectsAndBatches _tSAB;
  User _user;

  Future setup(User userCurrent) async {
    _user = userCurrent;
    _tSAB = TeacherSubjectsAndBatches(_user);
    _subjects = await _tSAB.getSubjects();
    if (_subjects == null) {
      _subjects = ["Couldn't get subjects, try logging in again"];
    }
    _subjectsVisible = _subjects;

    _userName = await UserDataBase(_user).userName();
    // _email = _user.email;
    if (_userName == null) {
      _userName = 'Can\'t Get Name';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        endDrawer: Drawer(
          child: Column(
            children: <Widget>[
              TeacherDrawerHeader(userName: _userName),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Add Subject',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          addSubjectForm().then((onValue) {
                            setState(() {});
                          });
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Remove Subject',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          if (_subjects[0] != 'Empty') {
                            setState(() {
                              _delete = true;
                            });
                          }
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
                        applicationLegalese: 'Copyright Pending',
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
                clipBehavior: Clip.antiAlias,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 60, 30, 50),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Text(
                          'Subjects',
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
                                style: GoogleFonts.notoSans(
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
                      color: Color.fromRGBO(25, 25, 25, 1.0),
                      borderRadius: BorderRadius.circular(20),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Color.fromRGBO(183, 22, 220, 0.1),
                      //     blurRadius: 10,
                      //     offset: Offset(0, 10),
                      //   )
                      // ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            // color: Color.fromRGBO(25, 25, 25, 1.0),
                            padding: EdgeInsets.all(6.5),
                            child: TextFormField(
                              style: GoogleFonts.lato(color: Colors.white),
                              decoration: authInputFormatting.copyWith(
                                hintText: "Enter Subject",
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(121, 121, 121, 1.0)),
                                fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _subjectsVisible = _subjects
                                      .where((subject) => subject
                                          .toLowerCase()
                                          .contains(val.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          color: Color.fromRGBO(23, 23, 23, 1.0),
                          icon: Icon(Icons.menu, color: kGoodColor, size: 30),
                          onPressed: () async {
                            _scaffoldKey.currentState.openEndDrawer();
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
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
                  future: setup(Provider.of<User>(context)),
                  rememberFutureResult: true,
                  whenNotDone: LoadingData(),
                  whenDone: (arg) => subjectsList(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget subjectsList() {
    return Center(
      child: Column(
        children: <Widget>[
          _subjects[0] == 'Empty' ? addSubjectButton() : Container(),
          _delete && _subjects[0] != 'Empty' ? deleteButton() : Container(),
          _subjects[0] == 'Empty'
              ? SizedBox(
                  height: 15,
                )
              : Container(),
          _subjects[0] == 'Empty'
              ? Text(
                  'You Need To Add Subjects',
                  style: GoogleFonts.raleway(
                      color: Colors.redAccent, fontWeight: FontWeight.bold),
                )
              : Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    itemCount: _subjectsVisible.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: kGlobalCardColor,
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            onTap: () async {
                              if (!_delete) {
                                Navigator.of(context).pushNamed('/batches',
                                    arguments: {
                                      'subject': _subjectsVisible[index],
                                      'userName': _userName
                                    });
                              } else {
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
                                                "Are you sure you want to delete ${_subjectsVisible[index]}? This action can\'t be reverted.",
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
                                                        String deleted =
                                                        _subjectsVisible[
                                                        index];
                                                        dynamic result = await _tSAB
                                                            .deleteSubject(
                                                            _subjectsVisible[
                                                            index]);
                                                        if (result ==
                                                            'Success') {
                                                          setState(() {
                                                            _error = ' ';
                                                            _subjectsVisible
                                                                .remove(
                                                                deleted);
                                                            _subjects.remove(
                                                                deleted);
                                                          });
                                                          if (_subjects
                                                              .isEmpty) {
                                                            setState(() {
                                                              _subjects
                                                                  .add('Empty');
                                                              _delete = false;
                                                            });
                                                          }
                                                          Navigator.of(context)
                                                              .pop();
                                                        } else {
                                                          setState(() {
                                                            _error =
                                                            "Couldn't delete ${_subjectsVisible[index]}";
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
                              }
                            },
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  '${_subjectsVisible[index]}',
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                                _delete
                                    ? Icon(
                                        Icons.delete,
                                        color: kGoodColor,
                                      )
                                    : Icon(
                                  Icons.forward,
                                        color: kGoodColor,
                                      )
                              ],
                            ),
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

  Widget addSubjectButton() {
    return Row(
      children: <Widget>[
        Expanded(
          child: GestureDetector(
            onTap: () async {
              addSubjectForm().then((onValue) {
                setState(() {});
              });
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
                    Icons.note_add_rounded,
                    color: kGoodColor,
                    size: 23,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Add Subject',
                    style: GoogleFonts.sourceSansPro(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget deleteButton() {
    return Column(
      children: <Widget>[
        _error == ' '
            ? Container()
            : Center(
                child: Text(
                  '$_error',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
        _error == ' '
            ? Container()
            : SizedBox(
                height: 15,
              ),
        GestureDetector(
          onTap: () {
            setState(() {
              _delete = false;
              _error = ' ';
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
                  Icons.check_circle_rounded,
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
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future addSubjectForm() {
    bool adding = false;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                backgroundColor: kGlobalContainerColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _error == ' '
                                ? Container()
                                : Center(
                                    child: Text(
                                    '$_error',
                                    style: TextStyle(color: Colors.red),
                                  )),
                            _error == ' '
                                ? Container()
                                : SizedBox(
                                    height: 15,
                                  ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Color.fromRGBO(20, 20, 20, 1.0),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Color.fromRGBO(51, 204, 255, 0.3),
                                //     blurRadius: 10,
                                //     offset: Offset(0, 10),
                                //   )
                                // ],
                              ),
                              child: TextFormField(
                                keyboardType: TextInputType.name,
                                style: GoogleFonts.lato(
                                    color: Colors.white, fontSize: 14),
                                decoration: authInputFormatting.copyWith(
                                  hintText: "Add Subject",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(121, 121, 121, 1.0)),
                                  border: InputBorder.none,
                                  fillColor: Color.fromRGBO(20, 20, 20, 1.0),
                                ),
                                validator: (val) => val.isEmpty
                                    ? 'Subject Name Can\'t Be Empty'
                                    : null,
                                onChanged: (val) => _subject = val,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            adding
                                ? Center(
                                    child: Text(
                                      "Adding ...",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  )
                                : Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 45, vertical: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Add",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                          onTap: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                adding = true;
                                              });
                                              if (_subjects
                                                  .contains(_subject)) {
                                                setState(() {
                                                  _error =
                                                      "Subject Already Present";
                                                  adding = false;
                                                });
                                              } else {
                                                dynamic result = await _tSAB
                                                    .addSubject(_subject);
                                                if (result == null) {
                                                  setState(() {
                                                    _error =
                                                        "Something Went Wrong, Couldn't Add Subject";
                                                    adding = false;
                                                  });
                                                } else {
                                                  if (_subjects[0] == 'Empty') {
                                                    setState(() {
                                                      _subjects.clear();
                                                      _subjects.add(_subject);
                                                      _error = ' ';
                                                      adding = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _subjects.add(_subject);
                                                      _error = ' ';
                                                      adding = false;
                                                    });
                                                  }
                                                }
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 45, vertical: 15),
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                            ),
                                            child: Center(
                                                child: Text(
                                              "Done",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _error = ' ';
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                          ],
                        )),
                  ),
                ),
              );
            },
          );
        });
  }
}
