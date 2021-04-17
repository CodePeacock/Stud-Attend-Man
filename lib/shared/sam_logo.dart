import 'package:flutter/material.dart';

class SamLogo extends StatelessWidget {
  final double width;
  final double height;

  SamLogo({this.width, this.height});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'images/sam.png',
      width: width != null ? width : 100,
      height: height != null ? width : 100,
    );
  }
}
