import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';

import 'formatting.dart';

class AccountSettings extends StatefulWidget {
  @override
  _AccountSettingsState createState() => _AccountSettingsState();
}

class _AccountSettingsState extends State<AccountSettings> {
  Map _status = {
    'index': null,
    'action': null,
  };

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kGlobalContainerColor,
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
                        CloseButton(
                          color: kGoodColor,
                        ),
                        Expanded(
                            child: Text(
                              'Account Settings',
                              style: GoogleFonts.quicksand(
                              color: Colors.white,
                              fontSize: 24,
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
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                color: kGlobalContainerColor,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Card(
                      color: kGlobalCardColor,
                      child: ListTile(
                        title: Text(
                          "Update Name",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.sort_by_alpha_rounded,
                          color: kGoodColor,
                        ),
                        subtitle: _status['index'] == 0
                            ? Text(
                                _status['status'],
                                style: TextStyle(
                                    color: _status['error']
                                        ? Colors.red
                                        : Colors.green),
                              )
                            : Text(
                                "Update Your Display Name",
                                style: TextStyle(color: Colors.grey),
                              ),
                        onTap: () {
                          setState(() {
                            _status = {
                              'index': null,
                              'action': 0,
                            };
                          });
                        },
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    _status['action'] == 0 ? changeNameForm() : Container(),
                    Card(
                      color: kGlobalCardColor,
                      child: ListTile(
                        title: Text(
                          "Update Email",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.email,
                          color: kGoodColor,
                        ),
                        subtitle: _status['index'] == 1
                            ? Text(
                                _status['status'],
                                style: TextStyle(
                                    color: _status['error']
                                        ? Colors.red
                                        : Colors.green),
                              )
                            : Text(
                                "Update Your Current Email",
                                style: TextStyle(color: Colors.grey),
                              ),
                        onTap: () {
                          setState(() {
                            _status = {
                              'index': null,
                              'action': 1,
                            };
                          });
                        },
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    _status['action'] == 1 ? changeEmailForm() : Container(),
                    Card(
                      color: kGlobalCardColor,
                      child: ListTile(
                        title: Text(
                          "Update Password",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: Icon(
                          Icons.lock_rounded,
                          color: kGoodColor,
                        ),
                        subtitle: _status['index'] == 2
                            ? Text(
                                _status['status'],
                                style: TextStyle(
                                    color: _status['error']
                                        ? Colors.red
                                        : Colors.green),
                              )
                            : Text(
                                "Update Your Password",
                                style: TextStyle(color: Colors.grey),
                              ),
                        onTap: () {
                          setState(() {
                            _status = {
                              'index': null,
                              'action': 2,
                            };
                          });
                        },
                        // onLongPress: () {
                        //   setState(() {
                        //     _status = {
                        //       'index': null,
                        //       'action': null,
                        //     };
                        //   });
                        // },
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    _status['action'] == 2 ? changePasswordForm() : Container(),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget changeNameForm() {
    String firstName;
    String lastName;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 45, 0, 5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(51, 204, 255, 0.3),
                //     blurRadius: 20,
                //     offset: Offset(0, 10),
                //   )
                // ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.white)),
                    ),
                    child: TextFormField(
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 14),
                      decoration: authInputFormatting.copyWith(
                          hintText: "First Name",
                          fillColor: Colors.transparent),
                      validator: (val) =>
                          val.isEmpty ? "First Name Can't Be Empty" : null,
                      onChanged: (val) {
                        firstName = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      style:
                          GoogleFonts.lato(color: Colors.white, fontSize: 14),
                      decoration: authInputFormatting.copyWith(
                          hintText: "Last Name", fillColor: Colors.transparent),
                      validator: (val) =>
                          val.isEmpty ? "Last Name Can't Be Empty" : null,
                      onChanged: (val) {
                        lastName = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await UserDataBase(
                                Provider.of<User>(context, listen: false))
                            .updateUserName(firstName, lastName);
                        final CollectionReference _userData =
                            FirebaseFirestore.instance.collection('users');
                        String user = FirebaseAuth.instance.currentUser.email;
                        String time = DateTime.now().toString();
                        Map<String, dynamic> data = {
                          'fullName': firstName + ' ' + lastName,
                          'last_update': time,
                        };
                        await _userData
                            .doc(user)
                            .set(data, SetOptions(merge: true));
                        if (result != null) {
                          setState(() {
                            _status = {
                              'index': 0,
                              'action': null,
                              'error': false,
                              'status': 'Name Changed Successfully',
                            };
                          });
                        } else {
                          setState(() {
                            _status = {
                              'index': 1,
                              'action': 1,
                              'error': true,
                              'status': 'Couldn\'t Update Email',
                            };
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: GoogleFonts.montserrat(
                              color: kGoodColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = {
                          'index': null,
                          'action': null,
                        };
                      });
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kGoodColor,
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget changeEmailForm() {
    String currentEmail;
    String newEmail;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 45, 0, 5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(51, 204, 255, 0.3),
                //     blurRadius: 20,
                //     offset: Offset(0, 10),
                //   )
                // ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(
                          hintText: "Current Email", fillColor: Colors.black),
                      validator: (val) =>
                          val.isEmpty ? "Current Email can't be empty" : null,
                      onChanged: (val) {
                        currentEmail = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(
                          hintText: "New Email", fillColor: Colors.black),
                      validator: (val) =>
                          val.isEmpty ? "New Email can't be empty" : null,
                      onChanged: (val) {
                        newEmail = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                            await UserModel().updateEmail(newEmail);
                        final CollectionReference _userData =
                            FirebaseFirestore.instance.collection('users');
                        String user = FirebaseAuth.instance.currentUser.email;
                        String time = DateTime.now().toLocal().toString();
                        Map<String, dynamic> data = {
                          'old_email': currentEmail,
                          'last_update': time,
                        };
                        await _userData
                            .doc(user)
                            .set(data, SetOptions(merge: true));
                        if (result != null) {
                          setState(() {
                            _status = {
                              'index': 0,
                              'action': null,
                              'error': false,
                              'status': 'Name Changed Succesfuly',
                            };
                          });
                        } else {
                          setState(() {
                            _status = {
                              'index': 0,
                              'action': 0,
                              'error': true,
                              'status': 'Couldn\'t Update Name',
                            };
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: GoogleFonts.montserrat(
                              color: kGoodColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = {
                          'index': null,
                          'action': null,
                        };
                      });
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kGoodColor,
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget changePasswordForm() {
    String newPass;
    String oldPass;
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 45, 0, 5),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                // boxShadow: [
                //   BoxShadow(
                //     color: Color.fromRGBO(51, 204, 255, 0.3),
                //     blurRadius: 20,
                //     offset: Offset(0, 10),
                //   )
                // ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[200]))),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(
                          hintText: "Old Password", fillColor: Colors.black),
                      validator: UserModel().validateRegisterPass,
                      obscureText: true,
                      onChanged: (val) {
                        oldPass = val;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      decoration: authInputFormatting.copyWith(
                          hintText: "New Password", fillColor: Colors.black),
                      validator: UserModel().validateRegisterPass,
                      obscureText: true,
                      onChanged: (val) {
                        newPass = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result =
                        await UserModel().resetPassword(oldPass, newPass);
                        if (result != null) {
                          setState(() {
                            _status = {
                              'index': 2,
                              'action': null,
                              'error': false,
                              'status': 'Password Changed Successfully',
                            };
                          });
                        } else {
                          setState(() {
                            _status = {
                              'index': 2,
                              'action': 2,
                              'error': true,
                              'status': "Couldn't Change Password",
                            };
                          });
                        }
                      }
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black,
                      ),
                      child: Center(
                        child: Text(
                          "Update",
                          style: GoogleFonts.montserrat(
                              color: kGoodColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _status = {
                          'index': null,
                          'action': null,
                        };
                      });
                    },
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: kGoodColor,
                      ),
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.5,
                              fontSize: 17),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
