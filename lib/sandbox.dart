import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
  Widget build(BuildContext context) {
    // Future<DocumentSnapshot> data() async {
    //   return await FirebaseFirestore.instance
    //       .collection('users')
    //       .doc('mayursinalkar404@gmail.com')
    //       .get();
    // }

    return Scaffold(
      body: Center(
        child: SpinKitWave(
          color: kGoodColor,
          size: 60,
          type: SpinKitWaveType.start,
          itemCount: 10,
        ),
      ),
    );
    // return Scaffold(
    //   body: Center(
    //     child: FutureBuilder(
    //       future: data(),
    //       builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //         // var data2 = snapshot.data.data();
    //         data().then((value) {
    //           print(value.data()['fullName']);
    //           return Text(value.data()['fullName']);
    //         });
    //         return Text('Hello');
    //       },
    //     ),
    //   ),
    // );
  }
}
