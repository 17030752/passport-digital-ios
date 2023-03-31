import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/data/dbHelper.dart';
import 'package:passport_digital_itc/models/student_model.dart';

class AdminProvider extends ChangeNotifier {
  static final db = FirebaseFirestore.instance;
  List<Student> _students = [];
  List<Student> get students => _students;
  bool? isValid;
  setStudents(List<Student> students) {
    _students = students;
  }

  Stream<List<Student>?> getUsers() {
    return db.collection('users').limit(2).snapshots().map(
        (event) => event.docs.map((e) => Student.fromJson(e.data())).toList());
  }

  void setEmail(String text) {}

  void setCareer(String text) {}

  void setNames(String text) {}

  void setLastNames(String text) {}

  void setNoControl(String text) {}

  Future<void> setUser({required Student user}) async {
    DBHelper.registerStudent(user.toJson());
  }

  updateConference(
      {required String name,
      required String email,
      required String career,
      required String noControl,
      required String role,
      required String id}) {}
}
