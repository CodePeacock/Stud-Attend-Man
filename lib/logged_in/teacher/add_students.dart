import 'dart:ui';

import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/loading_screen.dart';

class AddStudents extends StatefulWidget {
  @override
  _AddStudentsState createState() => _AddStudentsState();
}

class _AddStudentsState extends State<AddStudents> {
  List<String> _filteredStudents, _enrolledStudents;
  List<String> _allStudents = [];
  String _message = ' ';
  String _batch, _subject;
  final StudentsList _allStudentsInstance = StudentsList();
  TeacherSubjectsAndBatches _tSAB;

  Future setup(User user) async {
    _tSAB = TeacherSubjectsAndBatches(user);
    _allStudents = await _allStudentsInstance.getAllStudents();
    _allStudents = _allStudents
        .where((student) => !_enrolledStudents.contains(student))
        .toList();
    _filteredStudents = _allStudents;
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _enrolledStudents = data['enrolledStudents'];
    _batch = data['batch'];
    _subject = data['subject'];
    return EnhancedFutureBuilder(
      future: setup(Provider.of<User>(context)),
      rememberFutureResult: true,
      whenNotDone: LoadingScreen(),
      whenDone: (arg) => addStudents(),
    );
  }

  Widget addStudents() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: kGlobalContainerColor,
                borderRadius: BorderRadius.circular(20),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(51, 204, 255, 0.3),
                //     blurRadius: 10,
                //     offset: Offset(0, 10),
                //   ),
                // ],
              ),
              child: Container(
                padding: EdgeInsets.all(6.5),
                child: Row(
                  children: <Widget>[
                    BackButton(
                      color: kGoodColor,
                    ),
                    Expanded(
                      child: TextFormField(
                        style:
                            GoogleFonts.lato(color: Colors.white, fontSize: 14),
                        decoration: authInputFormatting.copyWith(
                            hintText: "Search Student By Email",
                            fillColor: kGlobalContainerColor),
                        onChanged: (val) {
                          setState(() {
                            _filteredStudents = _allStudents
                                .where((student) => student
                                    .toLowerCase()
                                    .contains(val.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Center(
                child: Text(
              _message,
              style: TextStyle(color: Colors.red),
            )),
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 20),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      color: kGlobalCardColor,
                      child: Container(
                        padding: EdgeInsets.all(6.5),
                        child: ListTile(
                          onTap: () async {
                            String added = _filteredStudents[index];
                            dynamic result =
                                await _tSAB.addStudent(_subject, _batch, added);
                            if (result == 'Success') {
                              setState(() {
                                _enrolledStudents.add(added);
                                _filteredStudents.remove(added);
                                Navigator.pop(context, {
                                  'studentAdded': added,
                                });
                              });
                            } else {
                              setState(() {
                                _message =
                                    "Something Went Wrong Couldn't Add Student";
                              });
                            }
                          },
                          title: Row(
                            children: <Widget>[
                              Expanded(
                                  child: Text(
                                '${_filteredStudents[index]}',
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                              Icon(
                                Icons.add_circle_outline,
                                color: kGoodColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: _filteredStudents.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
