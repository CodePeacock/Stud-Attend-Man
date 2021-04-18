import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stud_attend_man/shared/formatting.dart';

class Sandbox extends StatefulWidget {
  @override
  _SandboxState createState() => _SandboxState();
}

class _SandboxState extends State<Sandbox> {
  User user;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: kGlobalContainerColor,
                borderRadius: BorderRadius.circular(20),
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
                  suffixIcon: IconButton(
                    splashColor: Colors.pinkAccent,
                    color: Color.fromRGBO(197, 31, 193, 1.0),
                    enableFeedback: true,
                    onPressed: () {},
                    icon: IconButton(
                      icon: Icon(Icons.motorcycle),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: kGlobalContainerColor,
                // border: Border(
                //     bottom: BorderSide(
                //         color: Colors.white, style: BorderStyle.solid)),
                borderRadius: BorderRadius.circular(20),
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
                  suffixIcon: IconButton(
                    splashColor: Colors.pinkAccent,
                    color: Color.fromRGBO(197, 31, 193, 1.0),
                    enableFeedback: true,
                    onPressed: () {},
                    icon: IconButton(
                      icon: Icon(Icons.motorcycle),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
