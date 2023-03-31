import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/student_model.dart';

class Utilities {
  static Future<void> capitalize(String text) async {
    List<String> words = [];
    words = text.split(" ");
    String name = '';
    for (var word in words) {
      name += ' ${word[0].toUpperCase()}${word.substring(1)}';
    }
    name = name.trim();
    // return name;
  }

  static String formatHour(String word, int start, int end) {
    return word.substring(start, end);
  }

  static String timeStampToString(int date) {
    DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(date);
    String formattedString =
        DateFormat('dd-MM-yyyy HH:mm:ss').format(timeStamp);
    return formattedString;
  }

  static Future<void> loadDumpData(
      String assetjsonroute, String collection) async {
    //FirebaseFirestore db = FirebaseFirestore.instance;
    //var stu = db.collection(collection);
    String response = await rootBundle
        .loadString(assetjsonroute); // example path => 'assets/data.json'
    Map<String, dynamic> map = jsonDecode(response);
    map.forEach((key, value) async {
      //Map<String, dynamic> map = jsonDecode(value.toString());
      var model = Student.fromJson(value);
      /*  final doc = stu.doc();
      await doc
          .set(model.toJson())
          .onError((e, _) => print("Error writing document: $e")); */
      //Future.delayed(Duration(milliseconds: 500));
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: model.email!,
          password:
              '@${model.noControl}ITC', //formato de contrasena = @17030752ITC
        );
        await FirebaseAuth.instance.signOut();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          if (kDebugMode) {
            print('The password provided is too weak.');
          }
        } else if (e.code == 'email-already-in-use') {
          //print("${model.email}");
          if (kDebugMode) {
            print('The account already exists for that email.');
          }
        }
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }
    });
  }
}
