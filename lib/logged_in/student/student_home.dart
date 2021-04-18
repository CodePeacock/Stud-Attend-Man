import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, User;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/loading_screen.dart';
import 'package:stud_attend_man/shared/sam_logo.dart';
import 'package:url_launcher/url_launcher.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  StudentEnrollmentAndAttendance _sEAA;
  Map _enrollmentDetails = {};
  Map _enrollmentDetailsVisible = {};
  List _keys = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>(debugLabel: 'Scaffold');
  String userName = '';
  String _url = "http://flutter.dev/";
  User user;

  Future setup(User user) async {
    _sEAA = StudentEnrollmentAndAttendance(user);
    _enrollmentDetails = await _sEAA.enrollmentList();
    if (_enrollmentDetails == null) {
      _enrollmentDetails = {
        'error': {
          'subject': "Couldn't load subject list",
          'batch': 'Try Again',
          'teacherEmail': ' '
        }
      };
    }

    _enrollmentDetailsVisible = Map.from(_enrollmentDetails)
      ..removeWhere((key, value) => !value['active']);
    _keys = _enrollmentDetailsVisible.keys.toList();
    userName = await UserDataBase(user).userName();
    if (userName == null) {
      userName = 'Can\'t Get Name';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    void _launchURL() async => await canLaunch(_url)
        ? await launch(_url)
        : throw 'Could not launch $_url';
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        endDrawer: Drawer(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: UserAccountsDrawerHeader(
                      arrowColor: Colors.black,
                      margin: EdgeInsets.zero,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(183, 22, 220, 1.0)),
                      currentAccountPicture: Image.asset(
                        'images/student.png',
                        fit: BoxFit.scaleDown,
                      ),
                      accountName: Text(
                        userName,
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      accountEmail: Text(
                        // _email,
                        Provider.of<User>(context).email,
                        style: GoogleFonts.raleway(
                            color: Colors.white70, fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  color: kGlobalContainerColor,
                  child: ListView(
                    children: <Widget>[
                      // ListTile(
                      //   title: Text(
                      //     'Enrollment Requests',
                      //     style: GoogleFonts.montserrat(
                      //         color: Colors.white,
                      //         fontSize: 18,
                      //         fontWeight: FontWeight.w400),
                      //   ),
                      //   dense: true,
                      //   trailing: Icon(
                      //     Icons.edit_rounded,
                      //     color: kGoodColor,
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).pop();
                      //     Navigator.of(context).pushNamed('/accountSettings');
                      //   },
                      // ),
                      ListTile(
                        title: Text('Account Settings',
                            style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400)),
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).pushNamed('/accountSettings');
                        },
                      ),
                      AboutListTile(
                        applicationName: 'S.A.M',
                        applicationVersion: '0.1',
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
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w400),
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
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(45, 60, 30, 50),
                    decoration: BoxDecoration(
                        color: kGlobalContainerColor,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50))),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            'Subjects',
                            locale: Locale('en', 'IN'),
                            style: GoogleFonts.quicksand(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius:
                              BorderRadius.all(Radius.circular(50))),
                          child: TextButton.icon(
                            label: Text('Log Out',
                                style: TextStyle(
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
                      child: Row(
                        children: <Widget>[
                          Expanded(
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
                                  _enrollmentDetailsVisible =
                                  Map.from(_enrollmentDetails)
                                    ..removeWhere((k, v) => !((v['subject']
                                        .toString()
                                        .toLowerCase()
                                        .startsWith(
                                        val.toLowerCase()) ||
                                        v['teacherEmail']
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(
                                            val.toLowerCase()) ||
                                        v['batch']
                                            .toString()
                                            .toLowerCase()
                                            .startsWith(
                                            val.toLowerCase())) &&
                                        v['active']));
                                  _keys =
                                      _enrollmentDetailsVisible.keys.toList();
                                });
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.menu, color: kGoodColor),
                            onPressed: () {
                              setState(() {
                                _scaffoldKey.currentState.openEndDrawer();
                              });
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: Colors.black,
                child: EnhancedFutureBuilder(
                  future: setup(Provider.of<User>(context)),
                  rememberFutureResult: true,
                  whenNotDone: LoadingScreen(),
                  whenDone: (arg) => enrollmentList(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget enrollmentList() {
    return ListView.builder(
      itemCount: _keys.length,
      itemBuilder: (context, index) {
        User _auth = FirebaseAuth.instance.currentUser;
        var data = FirebaseFirestore.instance
            .collection('users')
            .where(_auth,
                isEqualTo: _enrollmentDetailsVisible[_keys[index]]
                    ['teacherEmail'])
            .snapshots();
        print(data);
        return Card(
          margin: EdgeInsets.symmetric(vertical: 7),
          elevation: 4,
          color: kGlobalPrimaryColor,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              onTap: () {
                Navigator.pushNamed(context, '/attendanceList', arguments: {
                  'teacherEmail': _enrollmentDetailsVisible[_keys[index]]
                      ['teacherEmail'],
                  'subject': _enrollmentDetailsVisible[_keys[index]]['subject'],
                  'batch': _enrollmentDetailsVisible[_keys[index]]['batch'],
                  'studentEmail':
                      Provider.of<User>(context, listen: false).email,
                });
              },
              title: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${_enrollmentDetailsVisible[_keys[index]]['subject']} (${_enrollmentDetailsVisible[_keys[index]]['batch']})',
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Teacher Email: ${_enrollmentDetailsVisible[_keys[index]]['teacherEmail']}',
                          style: GoogleFonts.nunito(
                            color: Colors.cyanAccent,
                            fontSize: 10,
                            fontStyle: FontStyle.italic,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.forward,
                    color: kGoodColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
