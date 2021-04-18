import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TeacherDrawerHeader extends StatelessWidget {
  const TeacherDrawerHeader({
    Key key,
    @required String userName,
  })  : _userName = userName,
        super(key: key);

  final String _userName;

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      arrowColor: Colors.black,
      margin: EdgeInsets.zero,
      currentAccountPicture: Image.asset('images/teacher.png'),
      decoration: BoxDecoration(color: Color.fromRGBO(183, 22, 220, 1.0)),
      accountName: Text(
        _userName,
        style: GoogleFonts.montserrat(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      accountEmail: Text(
        // _email,
        Provider.of<User>(context).email != null
            ? Provider.of<User>(context).email
            : 'Loading Data',
        style: GoogleFonts.raleway(color: Colors.white70, fontSize: 14),
      ),
    );
  }
}
