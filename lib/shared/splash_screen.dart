import 'dart:async' show Timer;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stud_attend_man/shared/formatting.dart';
import 'package:stud_attend_man/shared/loading_screen.dart';

class SplashScreen extends StatefulWidget {
  static String id = '/splash_screen';
  final Color backgroundColor = Colors.white;
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _versionName = 'V0.1';
  final int splashDelay = 5;
  FirebaseAuth user = FirebaseAuth.instance;
  static const Color textColor = Color(0xFF00ffef);

  @override
  void initState() {
    super.initState();
    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacementNamed(context, '/authentication');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGlobalContainerColor,
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                      color: kGlobalContainerColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'images/sam.png',
                            height: 200,
                            width: 200,
                          ),
                          LoadingScreen(),
                          Text(
                            'Loading',
                            style: GoogleFonts.oswald(
                                color: textColor, fontSize: 18),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                        ],
                      )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Spacer(),
                            Text(_versionName,
                                style: GoogleFonts.raleway(
                                    color: textColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900)),
                            Spacer(
                              flex: 4,
                            ),
                            Text(
                              'Mayur Sinalkar',
                              style: GoogleFonts.raleway(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900),
                            ),
                            Spacer(),
                          ])
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
