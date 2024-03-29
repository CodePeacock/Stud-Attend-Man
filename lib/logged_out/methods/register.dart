import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/classes/firestore_data.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/refined_button.dart';

class Register extends StatefulWidget {
  final ValueChanged<bool> updateTitle;
  Register(this.updateTitle);
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final UserModel _account = UserModel();
  final _formKey = GlobalKey<FormState>();

  String email, pass, firstName, lastName;
  String error = '';
  String type = '';
  List<String> _types = ['', 'Student', 'Teacher'];
  bool loading = false;
  Widget _currentForm;

  @override
  void initState() {
    super.initState();
    _currentForm = _registerNameEmail();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? AuthLoading(185, 20)
        : Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 45, 0, 5),
                child: _currentForm,
              ),
              SizedBox(
                height: 20,
              ),
              RefinedButton(
                buttonText: "Login",
                onPressed: () => widget.updateTitle(true),
              ),
            ],
          );
  }

  Widget _registerNameEmail() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          style: GoogleFonts.lato(color: Colors.white),
                          decoration: authInputFormatting.copyWith(
                            hintText: "First Name",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 121, 121, 1.0)),
                            border: InputBorder.none,
                            fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Can\'t Be Empty' : null,
                          onChanged: (val) {
                            firstName = val;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(color: Colors.white),
                                bottom: BorderSide(color: Colors.white))),
                        child: TextFormField(
                          style: GoogleFonts.lato(color: Colors.white),
                          decoration: authInputFormatting.copyWith(
                            hintText: "Last Name",
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 121, 121, 1.0)),
                            border: InputBorder.none,
                            fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                          ),
                          validator: (val) =>
                              val.isEmpty ? 'Can\'t Be Empty' : null,
                          onChanged: (val) {
                            lastName = val;
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    style: GoogleFonts.lato(color: Colors.white),
                    decoration: authInputFormatting.copyWith(
                      hintText: "Enter Email",
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(121, 121, 121, 1.0)),
                      border: InputBorder.none,
                      fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                    ),
                    validator: _account.validateId,
                    onChanged: (val) {
                      email = val;
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
            error,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(
            height: 30,
          ),
          RefinedButton(
            buttonText: "Next",
            onPressed: () {
              if (_formKey.currentState.validate()) {
                setState(() {
                  _currentForm = _registerPasswordType();
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _registerPasswordType() {
    bool _isSubmitting = true;
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: kGlobalContainerColor,
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
                    color: kGlobalContainerColor,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscuringCharacter: '*',
                    style: GoogleFonts.lato(color: Colors.white),
                    decoration: authInputFormatting.copyWith(
                      hintText: "Enter Password",
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(121, 121, 121, 1.0)),
                      border: InputBorder.none,
                      fillColor: Color.fromRGBO(23, 23, 23, 1.0),
                      // suffixIcon: IconButton(
                      //   color: kGoodIconColor,
                      //   icon: Icon(
                      //     _isSubmitting
                      //         ? Icons.visibility_off_rounded
                      //         : Icons.visibility_rounded,
                      //     color: kGoodIconColor,
                      //   ),
                      //   onPressed: () {
                      //     try {
                      //       setState(() {
                      //         _isSubmitting = !_isSubmitting;
                      //       });
                      //     } catch (e) {
                      //       return e;
                      //     }
                      //   },
                      // ),
                    ),
                    validator: _account.validateRegisterPass,
                    obscureText: _isSubmitting,
                    onChanged: (val) {
                      pass = val;
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: 70,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: FormField<String>(
                    validator: (val) =>
                        val.isEmpty ? "Choose A Category" : null,
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: authInputFormatting.copyWith(
                            hintText: 'Choose Account Type',
                            hintStyle: TextStyle(
                                color: Color.fromRGBO(121, 121, 121, 1.0)),
                            fillColor: Color.fromRGBO(23, 23, 23, 1.0)),
                        isEmpty: type == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: type,
                            dropdownColor: kGlobalContainerColor,
                            isDense: true,
                            onChanged: (value) {
                              setState(() {
                                type = value;
                                state.didChange(value);
                              });
                            },
                            items: _types.map((value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
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
            error,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RefinedButton(
                  buttonText: "Back",
                  onPressed: () {
                    setState(() {
                      _currentForm = _registerNameEmail();
                    });
                  }),
              RefinedButton(
                buttonText: "Register",
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    User user = await _account.register(email, pass);
                    if (user != null) {
                      UserDataBase userData = UserDataBase(user);
                      dynamic userDataSet = await userData.newUserData(
                          firstName.trim(), lastName.trim(), type);
                      bool isEmailVerified = user.emailVerified;
                      if (userDataSet != null) {
                        dynamic type = await userData.userType();
                        if (type != null) {
                          Navigator.of(context).pushReplacementNamed('/home',
                              arguments: {
                                'type': type,
                                'isEmailVerified': isEmailVerified
                              });
                        } else {
                          await _account.signOut();
                          setState(() {
                            loading = false;
                            error = 'Couldn\'t get user type, try to log in';
                          });
                        }
                      } else {
                        await _account.deleteUser();
                        setState(() {
                          loading = false;
                          error = "Couldn't add user details to database";
                        });
                      }
                    } else {
                      setState(() {
                        type = '';
                        loading = false;
                        error = "Please provide an valid E-mail";
                        _currentForm = _registerNameEmail();
                      });
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
