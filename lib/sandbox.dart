import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    Future<DocumentSnapshot> data() async {
      return await FirebaseFirestore.instance
          .collection('users')
          .doc('mayursinalkar404@gmail.com')
          .get();
    }

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: data(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            // var data2 = snapshot.data.data();
            data().then((value) {
              print(value.data()['fullName']);
              return Text(value.data()['fullName']);
            });
            return Text('Hello');
          },
        ),
      ),
    );
  }
}
