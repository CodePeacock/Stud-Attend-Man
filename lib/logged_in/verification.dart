import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:stud_attend_man/classes/account.dart';
import 'package:stud_attend_man/shared/formatting.dart';

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailState createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  String _success = ' ';
  @override
  Widget build(BuildContext context) {
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
                      color: Colors.white,
                    ),
                    Expanded(
                        child: Text(
                      'Email Verification',
                      style: GoogleFonts.quicksand(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    )),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: kGlobalContainerColor,
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: TextButton.icon(
                        label: Text('Log Out',
                            style: TextStyle(
                                color: kGoodIconColor,
                                fontWeight: FontWeight.bold)),
                        icon: Icon(
                          Icons.exit_to_app,
                          color: kGoodIconColor,
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
            ],
          ),
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 150),
              color: kGlobalContainerColor,
              child: Center(
                child: Column(
                  children: <Widget>[
                    _success == ' '
                        ? Container()
                        : Center(
                            child: Text(
                              '$_success',
                              style: TextStyle(color: Colors.green),
                              textAlign: TextAlign.center,
                            ),
                          ),
                    _success == ' '
                        ? Container()
                        : SizedBox(
                            height: 15,
                          ),
                    Text(
                      'Verify your email using the verification link sent on your signup email id. This is required to access your account and helps save us from spam accounts. Log in again after you verify your email.',
                      style: GoogleFonts.josefinSans(
                          fontSize: 24, color: Colors.white),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kGoodIconColor),
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        User user = Provider.of<User>(context, listen: false);
                        await user
                            .sendEmailVerification()
                            .then((value) => setState(() {
                                  _success = 'Verification Email Sent';
                                }));
                      },
                      child: Text(
                        'Re-Send Verification Email',
                        softWrap: true,
                        style: GoogleFonts.dosis(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ],
    ));
  }
}
