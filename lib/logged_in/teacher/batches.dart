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

class Batches extends StatefulWidget {
  @override
  _BatchesState createState() => _BatchesState();
}

class _BatchesState extends State<Batches> {
  TeacherSubjectsAndBatches _tSAB;
  User _user;
  String _subject = '';
  String _error = '';
  String _userName = "";
  String _batch = '';
  List<String> _batches = [];
  List<String> _batchesVisible = [];
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool _delete = false;

  Future setup(User userCurrent, String sub) async {
    _user = userCurrent;
    _tSAB = TeacherSubjectsAndBatches(_user);
    _batches = await _tSAB.getBatches(sub);
    print(_batches);
    if (_batches == null) {
      _batches = ["Couldn't get batches, try again"];
    }
    _batchesVisible = _batches;
  }

  @override
  Widget build(BuildContext context) {
    Map data = ModalRoute.of(context).settings.arguments;
    _subject = data['subject'];
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
                          'Add Batch',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () async {
                          Navigator.of(context).pop();
                          addBatchForm().then((onValue) {
                            setState(() {});
                          });
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Remove Batch',
                          style: GoogleFonts.quicksand(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                          if (_batches[0] != 'Empty') {
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
                          'Batches',
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(6.5),
                            child: TextFormField(
                              style: GoogleFonts.lato(color: Colors.white),
                              decoration: authInputFormatting.copyWith(
                                hintText: "Search by Batch",
                                hintStyle: TextStyle(
                                    color: Color.fromRGBO(121, 121, 121, 1.0)),
                                border: InputBorder.none,
                                fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  _batchesVisible = _batches
                                      .where((batch) => batch
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
                          onPressed: () async {
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
                  future: setup(Provider.of<User>(context), _subject),
                  rememberFutureResult: true,
                  whenNotDone: LoadingData(),
                  whenDone: (arg) => batchList(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget batchList() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _batches[0] == "Empty" ? addBatchButton() : Container(),
          _delete && _batches[0] != 'Empty' ? deleteButton() : Container(),
          _batches[0] == 'Empty'
              ? Text(
            '\n\nYou Need To Add Batches',
                  style: GoogleFonts.raleway(
                      color: Colors.red, fontWeight: FontWeight.bold),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: _batchesVisible.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        color: kGlobalCardColor,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Row(
                              children: <Widget>[
                                Expanded(
                                    child: Text(
                                  '${_batchesVisible[index]}',
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontSize: 18,
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
                                      ),
                              ],
                            ),
                            onTap: () async {
                              if (!_delete) {
                                Navigator.of(context)
                                    .pushNamed('/enrolledStudents', arguments: {
                                  'subject': _subject,
                                  'batch': _batchesVisible[index],
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
                                                "Are you sure you want to delete ${_batchesVisible[index]}? This action can\'t be reverted.",
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
                                                        dynamic result =
                                                        await _tSAB.deleteBatch(
                                                            _subject,
                                                            _batchesVisible[
                                                            index]);
                                                        String deleted =
                                                        _batchesVisible[
                                                        index];
                                                        if (result ==
                                                            'Success') {
                                                          Navigator.of(context)
                                                              .pop();
                                                          setState(() {
                                                            _error = '';
                                                            _batchesVisible
                                                                .remove(
                                                                deleted);
                                                            _batches.remove(
                                                                deleted);
                                                          });
                                                          if (_batches
                                                              .isEmpty) {
                                                            setState(() {
                                                              _batches
                                                                  .add('Empty');
                                                              _delete = false;
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            _error =
                                                            "Couldn't delete ${_batchesVisible[index]}";
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
                          ),
                        ),
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }

  Widget addBatchButton() {
    return GestureDetector(
      onTap: () async {
        addBatchForm().then((onValue) {
          setState(() {});
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
              Icons.add_business_rounded,
              color: kGoodColor,
              size: 23,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              'Add Batch',
              style: GoogleFonts.sourceSansPro(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            )
          ],
        ),
      ),
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

  Future addBatchForm() {
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
                                  hintText: "Add Batch",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(121, 121, 121, 1.0)),
                                  border: InputBorder.none,
                                  fillColor: Color.fromRGBO(20, 20, 20, 1.0),
                                ),
                                validator: (val) => val.isEmpty
                                    ? 'Batch Name Can\'t Be Empty'
                                    : null,
                                onChanged: (val) => _batch = val,
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            adding
                                ? Center(
                                    child: Text("Adding ..."),
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
                                              if (_batches.contains(_batch)) {
                                                setState(() {
                                                  _error =
                                                      "Batch Already Present";
                                                  adding = false;
                                                });
                                              } else {
                                                dynamic result = await _tSAB
                                                    .addBatch(_subject, _batch);
                                                if (result == null) {
                                                  setState(() {
                                                    _error =
                                                        "Something Went Wrong, Couldn't Add Batch";
                                                    adding = false;
                                                  });
                                                } else {
                                                  if (_batches[0] == 'Empty') {
                                                    setState(() {
                                                      _batches.clear();
                                                      _batches.add(_batch);
                                                      _error = ' ';
                                                      adding = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      _batches.add(_batch);
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
