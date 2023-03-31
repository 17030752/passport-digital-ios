// ignore_for_file: file_names
import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/models/conference_model.dart';
import 'package:passport_digital_itc/models/student_model.dart';
import 'package:passport_digital_itc/models/user_conference_model.dart';

import '../utils/showSnackBar.dart';

class DBHelper {
  static final db = FirebaseFirestore.instance;

  static Future<void> registerStudent(Map<String, dynamic> data) async {
    try {
      final docStudent = FirebaseFirestore.instance.collection('users').doc();
      await docStudent.set(data);
    } on FirebaseFirestore catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<void> registerAttendance(attendance) async {
    final map = jsonDecode(attendance);
    map['date'] = DateTime.now();
    await db.collection('usersConferences').doc().set(map);
  }

  static Future<void> registerConference(Conference data) async {
    db.collection('conferences').doc().set(data.toJson());
  }

  static Future<void> updateConference(Conference data, String id) async {
    db.collection('conferences').doc(id).update(data.toJson());
  }

  static Future<void> deleteConference(String docID) async {
    db.collection("conferences").doc(docID).delete();
  }

  static Future<String?> firstTransaction(
      {required String fieldData,
      required String fieldName,
      required String idConference}) async {
    var id;
    String? response;
    final QuerySnapshot querySnapshot = await db
        .collection("users")
        .where(fieldName, isEqualTo: fieldData)
        .get();

    for (var doc in querySnapshot.docs) {
      id = doc.id;
      final json = jsonEncode(doc.data());
      final map = jsonDecode(json);
      response = map['name'];
    }
    final userRef = db.collection("users").doc(id);
    final userConferenceRef = db.collection('usersConferences').doc();
    final conference = UserConferences(
        userId: id, conferenceId: idConference, date: DateTime.now());
    db.runTransaction((transaction) async {
      transaction.get(userRef);
      transaction.set(userConferenceRef, conference.toJson());
    });
    return response;
  }

  static Future<Map<String, dynamic>> getOneUser(
      String data, String fieldName) async {
    Map<String, dynamic> map = {};
    FirebaseFirestore db = FirebaseFirestore.instance;
    final usersRef = db.collection("users");
    final query = usersRef.where(fieldName, isEqualTo: data);
    final snapshot = query.get();
    QuerySnapshot querySnapshot = await snapshot;
    for (var element in querySnapshot.docs) {
      final json = jsonEncode(element.data());
      final data = jsonDecode(json);
      map.addAll(data);
      map['id'] = element.id;
    }
    return map;
  }

  static Future<List<dynamic>> getStudents() async {
    //UTILIZAR LOADDUMPDATA
    final studentList = [];
    final first = db.collection("users"); //18030325

    QuerySnapshot query = await first.get();
    var lastIndex = {};
    // ignore: unused_local_variable
    var count = 0;
    for (var element in query.docs) {
      lastIndex = jsonDecode(jsonEncode(element.data()));
      //print("primeros 3: ${element.data()}");
      count++;
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: lastIndex['email'],
          password:
              '@${lastIndex['no_control']}ITC', //formato de contrasena = @17030752ITC
        );
        await FirebaseAuth.instance.signOut();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
          if (kDebugMode) {
            print('The account already exists for that email.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e.toString());
        }
      }
    }
    return studentList;
  }

  static Future<List<Conference>> getConferences() async {
    List<Conference> conferences = [];
    var collectionRef = FirebaseFirestore.instance
        .collection('conferences')
        .withConverter(
            fromFirestore: Conference.fromFirestore,
            toFirestore: (Conference conference, _) => conference.toFirestore())
        .get();
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await collectionRef;
    for (var element in querySnapshot.docs) {
      final Conference c = element.data() as Conference;
      conferences.add(c);
    }
    return conferences;
  }

  static Future<String> getUserID(String email) async {
    String id = '';
    // Create a reference to the users collection
    final usersRef = db.collection("users");
    // Create a query against the collection.
    final query = usersRef.where("email", isEqualTo: email);
    final collectionRef = await query.get();

    QuerySnapshot querySnapshot = collectionRef;
    for (var element in querySnapshot.docs) {
      id = element.id;
    }
    return id;
  }

  static Future<List<String>> getIdByCollection(String collection) async {
    final id = <String>[];
    final idRef = db.collection(collection);
    QuerySnapshot query = await idRef.get();
    for (var element in query.docs) {
      id.add(element.id);
    }
    return id;
  }
}
