import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'methods/login.dart';
import 'methods/register.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication>
    with SingleTickerProviderStateMixin {
  bool _login = true;

  _updateTitle(bool login) {
    setState(() => _login = login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        color: Colors.black,
        // decoration: BoxDecoration(
        //     gradient: LinearGradient(begin: Alignment.topLeft, colors: [
        //   Color(0xffd128a6).withAlpha(255),
        //   Colors.pink,
        //   Colors.lightBlue[200]
        // ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 70, 15, 0),
              child: Text(
                '${_login ? 'Login' : 'Register'}',
                style: GoogleFonts.raleway(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(38, 0, 15, 0),
              child: Text(
                '${_login ? 'Welcome Back.' : 'Good to see you here.'}',
                style: GoogleFonts.montserrat(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.w300),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  addAutomaticKeepAlives: true,
                  children: <Widget>[
                    _login ? Login(_updateTitle) : Register(_updateTitle),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
