import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeacherDrawerHeader extends StatelessWidget {
  TeacherDrawerHeader({
    Key key,
    @required String userName,
  })  : _userName = userName,
        super(key: key);

  final String _userName;
  final User _auth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      arrowColor: Colors.black,
      margin: EdgeInsets.zero,
      currentAccountPicture: Image.asset(
        'images/teacher.png',
        fit: BoxFit.scaleDown,
      ),
      decoration: BoxDecoration(color: Color.fromRGBO(183, 22, 220, 1.0)),
      accountName: Text(
        _userName,
        style: GoogleFonts.montserrat(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        // _email,
        _auth.email == null ? 'Loading Data' : _auth.email,
        style: GoogleFonts.raleway(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
