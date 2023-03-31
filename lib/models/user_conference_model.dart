// ignore_for_file: unnecessary_getters_setters, unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';

class UserConferences {
  String? _userId;
  String? _conferenceId;
  DateTime? _date;
  UserConferences({String? userId, String? conferenceId, DateTime? date}) {
    if (userId != null) {
      this._userId = userId;
    }
    if (conferenceId != null) {
      this._conferenceId = conferenceId;
    }
    if (date != null) {
      this._date = date;
    }
  }

  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  String? get conferenceId => _conferenceId;
  set conferenceId(String? conferenceId) => _conferenceId = conferenceId;
  DateTime? get date => _date;
  set date(DateTime? date) => _date = date;

  UserConferences.fromJson(Map<String, dynamic> json) {
    _userId = json['user_id'];
    _conferenceId = json['conference_id'];
    _date = DateTime.fromMillisecondsSinceEpoch(json['date']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = this._userId;
    data['conference_id'] = this._conferenceId;
    data['date'] = this._date;
    return data;
  }

  factory UserConferences.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserConferences(
        userId: data?['title'],
        conferenceId: data?['speaker'],
        date: DateTime.fromMillisecondsSinceEpoch(
            data?['date'].millisecondsSinceEpoch));
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (userId != null) "user_id": userId,
      if (conferenceId != null) "conference_id": conferenceId,
      if (date != null) "date": date,
    };
  }
}
