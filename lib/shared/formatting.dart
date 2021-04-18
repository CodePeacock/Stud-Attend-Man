import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// For formatting text input fields
const enabled = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.blue, width: 2),
);

const focused = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
);

const textInputFormatting = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  errorBorder: enabled,
  focusedErrorBorder: focused,
  enabledBorder: enabled,
  focusedBorder: focused,
);

const Color kGlobalPrimaryColor = Color(0xff363649);
const Color kGlobalContainerColor = Color(0xff171616);
const Color kGlobalCardColor = Color(0xff1d2763);
// const Color cGlobalTextColor = Color(0xFFc6c1eb);

// TextStyle buttonTextStyle = GoogleFonts.raleway(
//   fontSize: 40.0,
// );

const Color cGradientColorOption1Part1 = Color(0xFF1CAAD9);
const Color cGradientColorOption1Part2 = Color(0xFF6C5CBA);
const Color cGradientColorOption2Part2 = Color(0xFFA163F5);

const LinearGradient kButtonGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: kGradientButtonList,
  tileMode: TileMode.decal,
);

const kGradientButtonList = [
  Color.fromARGB(255, 185, 23, 216),
  Color.fromARGB(255, 210, 39, 170),
];

const Color kGoodColor = Color.fromARGB(255, 185, 23, 216);

const authInputFormatting = InputDecoration(
  filled: true,
  border: InputBorder.none,
  hintText: "Enter Email",
  hintStyle: TextStyle(color: Color.fromRGBO(121, 121, 121, 1.0)),
  fillColor: Color.fromRGBO(23, 23, 23, 1.0),
);

// For loading screen
// class LoadingScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: SpinKitRing(
//           color: Colors.cyan,
//           size: 50,
//           lineWidth: 2.0,
//         ),
//       ),
//     );
//   }
// }

class LoadingData extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGlobalContainerColor,
      body: Center(
        child: SpinKitRing(
          color: Colors.pinkAccent,
          size: 60,
          lineWidth: 2.0,
        ),
      ),
    );
  }
}

class AuthLoading extends StatelessWidget {
  final double _height, _width;
  AuthLoading(this._height, this._width);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _width, vertical: _height),
      child: Center(
        child: SpinKitWave(
          color: kGoodColor,
          size: 40,
          type: SpinKitWaveType.start,
          itemCount: 10,
        ),
      ),
    );
  }
}
