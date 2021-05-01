import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/refined_button.dart';

class Login extends StatefulWidget {
  final ValueChanged<bool> updateTitle;
  Login(this.updateTitle);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final UserModel _account = UserModel();
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _pass;
  String _error = '';
  bool _loading = false;
  bool _isSubmitting = true;

  void suffixTap() {
    setState(() {
      _isSubmitting = !_isSubmitting;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loginForm();
  }

  Widget loginForm() {
    return _loading
        ? AuthLoading(185, 20)
        : Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 45, 0, 5),
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(23, 23, 23, 1.0),
                          borderRadius: BorderRadius.circular(20),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color.fromRGBO(197, 31, 193, 0.3),
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
                                      bottom: BorderSide(color: Colors.white))),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                style:
                                    GoogleFonts.montserrat(color: Colors.white),
                                cursorColor: kGoodColor.withRed(255),
                                decoration: authInputFormatting.copyWith(
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      color:
                                          Color.fromRGBO(121, 121, 121, 1.0)),
                                  border: InputBorder.none,
                                  fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                                ),
                                validator: _account.validateId,
                                onChanged: (val) {
                                  _email = val;
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              // decoration: BoxDecoration(
                              //     border: Border(
                              //         bottom:
                              //             BorderSide(color: Colors.grey[200]))),
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscuringCharacter: '*',
                                style: GoogleFonts.lato(color: Colors.white),
                                decoration: authInputFormatting.copyWith(
                                  hintText: "Enter Password",
                                  hintStyle: GoogleFonts.montserrat(
                                      color:
                                          Color.fromRGBO(121, 121, 121, 1.0)),
                                  border: InputBorder.none,
                                  fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                                  suffixIcon: IconButton(
                                    splashColor: Colors.pinkAccent,
                                    color: Color.fromRGBO(197, 31, 193, 1.0),
                                    enableFeedback: true,
                                    onPressed: suffixTap,
                                    icon: Icon(
                                      _isSubmitting
                                          ? Icons.visibility_off_rounded
                                          : Icons.visibility_rounded,
                                    ),
                                  ),
                                ),
                                validator: _account.validateLoginPass,
                                obscureText: _isSubmitting,
                                onChanged: (val) {
                                  _pass = val;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        _error,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          RefinedButton(
                            textColor: Colors.white,
                            buttonText: "Login",
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => _loading = true);
                                User user = await _account.login(_email, _pass);
                                if (user != null) {
                                  bool isEmailVerified = user.emailVerified;
                                  dynamic type =
                                      await UserDataBase(user).userType();
                                  if (type != null) {
                                    Navigator.of(context).pushReplacementNamed(
                                        '/home',
                                        arguments: {
                                          'type': type,
                                          'isEmailVerified': isEmailVerified
                                        });
                                  } else {
                                    await _account.signOut();
                                    setState(() {
                                      _loading = false;
                                      _error =
                                          'Couldn\'t get user type, try again';
                                    });
                                  }
                                } else {
                                  setState(() {
                                    _loading = false;
                                    _error =
                                        'Email and/or password is incorrect';
                                  });
                                }
                              }
                            },
                          ),
                          RefinedButton(
                            buttonText: "Register",
                            onPressed: () => widget.updateTitle(false),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
