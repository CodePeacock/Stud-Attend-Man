import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User> get account {
    return _auth.authStateChanges();
  }

  Future<User> register(email, pass) async {
    try {
      UserCredential account = await _auth.createUserWithEmailAndPassword(
          email: email, password: pass);
      return account.user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<User> login(email, pass) async {
    try {
      UserCredential account =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return account.user;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  Future deleteUser() async {
    User user = _auth.currentUser;
    await user.delete();
  }

  Future updateEmail(newEmail) async {
    User user = _auth.currentUser;
    await user.updateEmail(newEmail);
  }

  Future<String> resetPassword(oldPass, newPass) async {
    try {
      User user = _auth.currentUser;
      UserCredential newAuth = await user.reauthenticateWithCredential(
        EmailAuthProvider.credential(email: user.email, password: oldPass),
      );
      await newAuth.user.updatePassword(newPass);
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  String validateId(String id) {
    if (id.isEmpty) {
      return "Email can't be blank";
    } else {
      return null;
    }
  }

  String validateRegisterPass(String pass) {
    if (pass.length < 6) {
      return "Password can't be less than 6 characters";
    } else {
      return null;
    }
  }

  String validateLoginPass(String pass) {
    if (pass.isEmpty) {
      return "Password can't be empty";
    } else {
      return null;
    }
  }
}
