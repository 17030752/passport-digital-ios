import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/utils/notification.dart';
import 'package:passport_digital_itc/utils/showSnackBar.dart';

class FirebaseAuthMethods extends ChangeNotifier {
  final FirebaseAuth _auth;
  String? _role;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuthMethods(this._auth, [this._role]);
  User? get user => _auth.currentUser;
  String? get role => _role;

  //state persistence
  Stream<User?> get authState => //FirebaseAuth.instance.authStateChanges();
      // FirebaseAuth.instance.userChanges();
      FirebaseAuth.instance.idTokenChanges();
  //email login
  Future<void> loginWithEmail(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        getRole(value.user!.email);
        debugPrint('_role: ${_role}');
      });
      if (!_auth.currentUser!.emailVerified) {
        // ignore: use_build_context_synchronously
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  //email sing up
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    var status;
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await sendEmailVerification(context);
      status = true;
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      status = false;
    }
    return status;
  }

  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context,
          'Verificacion enviada, porfavor revisa tu correo en la carpeta Spam');
      showDialogNotification(
          context,
          'Casi terminas!',
          'Verificacion enviada, porfavor revisa tu correo para validar tu registro\n en caso de no encontrar el correo revisa tu carpeta SPAM o correo no deseado',
          Icons.warning_amber_rounded,
          Colors.yellowAccent[700]!);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> sendPasswordResetEmail(
      {String? email, BuildContext? context}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email!);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context!, e.message!);
    }
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  Future<void> getRole(String? email) async {
    final doc =
        db.collection('users').where("email", isEqualTo: email).limit(1);
    final QuerySnapshot query = await doc.get();
    for (var element in query.docs) {
      final json = jsonEncode(element.data());
      final map = jsonDecode(json);
      _role = map['role'];
      notifyListeners();
    }
  }
}
