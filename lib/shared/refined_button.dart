import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';

import 'formatting.dart';

class RefinedButton extends StatelessWidget {
  final Function onPressed;
  final Color textColor;
  final String buttonText;

  RefinedButton({
    Key key,
    this.textColor,
    @required this.buttonText,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      child: GFButton(
        text: "Login" != null ? buttonText : "Add Text",
        color: kGoodColor,
        size: GFSize.LARGE,
        textStyle: GoogleFonts.raleway(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 17),
        borderShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        textColor: Colors.white != null ? Colors.white : textColor,
        onPressed: () {} != null ? onPressed : () {},
        // icon: Icon(
        //   Icons.login_rounded,
        //   color: kGoodColor,
        // ),
      ),
    );
  }
}
