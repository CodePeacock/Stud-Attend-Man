import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataBase {
  UserDataBase(this.user);

  final User user;

  final CollectionReference _userData =
      FirebaseFirestore.instance.collection('users');

  Future<String> newUserData(
      String firstName, String lastName, String type) async {
    try {
      Map<String, dynamic> data = {
        'firstName': firstName,
        'lastName': lastName,
        'fullName': firstName + ' ' + lastName,
        'type': type,
        'uid': user.uid,
        //updated
        'email': user.email,
      };
      await _userData.doc(user.email).set(data);
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future userType() async {
    DocumentSnapshot data;
    await _userData.doc(user.email).get().then((DocumentSnapshot ds) {
      data = ds;
    });
    return data.data()['type'];
  }

  Future userName() async {
    try {
      DocumentSnapshot data;
      await _userData.doc(user.email).get().then((DocumentSnapshot ds) {
        data = ds;
      });
      return (data.data()['firstName'].toString() +
          " " +
          data.data()['lastName'].toString());
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> updateUserName(String firstName, String lastName) async {
    try {
      await _userData.doc(user.email).update({
        'firstName': firstName,
        'lastName': lastName,
      });
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class StudentsList {
  final CollectionReference _userData =
      FirebaseFirestore.instance.collection('users');

  Future<List<String>> getAllStudents() async {
    try {
      List<String> students = [];
      QuerySnapshot qs = await _userData.get();
      qs.docs.forEach((DocumentSnapshot ds) {
        if (ds.data()['type'] == 'Student') {
          students.add(ds.id);
        }
      });
      return students.isEmpty ? [] : students;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class TeacherSubjectsAndBatches {
  TeacherSubjectsAndBatches(this.user);

  final User user;

  final CollectionReference _teachers =
      FirebaseFirestore.instance.collection('teachers-data');

  Future<String> addSubject(String subject) async {
    try {
      //Creating an map with subjects as keys and whether to show it or not as an boolean value
      await _teachers
          .doc(user.email)
          .set({subject: true}, SetOptions(merge: true));
      //above subject boolean set to default true
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteSubject(String subject) async {
    try {
      List<String> documents = [];
      await _teachers
          .doc(user.email)
          .set({subject: FieldValue.delete()}, SetOptions(merge: true));
      await _teachers
          .doc(user.email)
          .collection(subject)
          .get()
          .then((QuerySnapshot qs) {
        for (DocumentSnapshot ds in qs.docs) {
          documents.add(ds.id);
          ds.reference.delete();
        }
      });
      if (documents.isNotEmpty) {
        for (String document in documents) {
          await _teachers
              .doc(user.email)
              .collection(subject)
              .doc(document)
              .collection('attendance')
              .get()
              .then((QuerySnapshot qs) {
            for (DocumentSnapshot ds in qs.docs) {
              documents.add(ds.id);
              ds.reference.delete();
            }
          });
        }
      }
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> addBatch(String subject, String batch) async {
    try {
      await _teachers
          .doc(user.email)
          .collection(subject)
          .doc(batch)
          .set({}, SetOptions(merge: true));
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future deleteBatch(String subject, String batch) async {
    try {
      await _teachers.doc(user.email).collection(subject).doc(batch).delete();
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> addStudent(
      String subject, String batch, String studentEmail) async {
    try {
      await _teachers
          .doc(user.email)
          .collection(subject)
          .doc(batch)
          .set({studentEmail: true}, SetOptions(merge: true));
      CollectionReference _students =
          FirebaseFirestore.instance.collection('students-data');
      await _students.doc(studentEmail).set({
        DateTime.now().millisecondsSinceEpoch.toString(): {
          'teacherEmail': user.email,
          // 'teacherName': , //working on it
          'subject': subject,
          'batch': batch,
          //below boolean defaulted to true
          'active': true,
        }
      }, SetOptions(merge: true));
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> deleteStudent(
      String subject, String batch, String studentEmail) async {
    try {
      await _teachers
          .doc(user.email)
          .collection(subject)
          .doc(batch)
          .set({studentEmail: FieldValue.delete()}, SetOptions(merge: true));
      await _teachers
          .doc(user.email)
          .collection(subject)
          .doc(batch)
          .collection('attendance')
          .doc(studentEmail)
          .delete();
      CollectionReference _students =
          FirebaseFirestore.instance.collection('/students-data');
      Map studentDetails = {};
      await _students.doc(studentEmail).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          studentDetails = ds.data();
        }
      });
      if (studentDetails.isNotEmpty) {
        List<String> keys = studentDetails.keys.toList();
        for (String key in keys) {
          if (studentDetails[key]['teacherEmail'] == user.email) {
            await _students
                .doc(studentEmail)
                .set({key: FieldValue.delete()}, SetOptions(merge: true));
          }
        }
      }
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String> addAttendance(
      String subject, String batch, String dateTime, Map attendance) async {
    try {
      CollectionReference attendanceReference = _teachers
          .doc(user.email)
          .collection(subject)
          .doc(batch)
          .collection('attendance');
      for (String studentEmail in attendance.keys) {
        await attendanceReference
            .doc(studentEmail)
            .set({dateTime: attendance[studentEmail]}, SetOptions(merge: true));
      }
      return 'Success';
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> getSubjects() async {
    try {
      List<String> subjects = [];
      await _teachers.doc(user.email).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          subjects.addAll(ds.data().keys);
        } else {
          subjects = ['Empty'];
        }
      });
      return subjects.isEmpty ? ['Empty'] : subjects;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<String>> getBatches(String subject) async {
    try {
      List<String> batches = [];
      QuerySnapshot qs =
          await _teachers.doc(user.email).collection(subject).get();
      qs.docs.forEach((DocumentSnapshot ds) => batches.add(ds.id));
      return batches.isEmpty || batches == null ? ['Empty'] : batches;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map> getStudents(String subject, String batch) async {
    try {
      Map students = {};
      await _teachers
          .doc(user.email)
          .collection(subject)
          .doc(batch)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          students = ds.data();
          if (ds.data().isEmpty) {
            students['Empty'] = true;
          } else {
            students['Empty'] = false;
          }
        } else {
          students['Empty'] = true;
        }
      });
      return students;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class StudentEnrollmentAndAttendance {
  StudentEnrollmentAndAttendance(this.user);

  final User user;

  final CollectionReference _students =
      FirebaseFirestore.instance.collection('students-data');

  Future<Map> enrollmentList() async {
    try {
      var enrollmentDetails = {};
      await _students.doc(user.email).get().then((DocumentSnapshot ds) {
        if (ds.exists) {
          enrollmentDetails = ds.data();
        } else {
          enrollmentDetails = {
            'empty': {
              'subject': "Subjects not found",
              'batch': '-_-',
              'teacherEmail': 'Try contacting your teachers'
            }
          };
        }
      });
      return enrollmentDetails.isEmpty
          ? {
              'empty': {
                'subject': "Subjects not found",
                'batch': '-_-',
                'teacherEmail': 'Try contacting your teachers'
              }
            }
          : enrollmentDetails;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}

class GetAttendance {
  final CollectionReference _teachers =
      FirebaseFirestore.instance.collection('teachers-data');

  Future<Map> getAttendance(String teacherEmail, String subject, String batch,
      String studentEmail) async {
    try {
      Map attendanceList = {};
      await _teachers
          .doc(teacherEmail)
          .collection(subject)
          .doc(batch)
          .collection('attendance')
          .doc(studentEmail)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          attendanceList = ds.data();
        }
      });
      return attendanceList.isEmpty ? null : attendanceList;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
