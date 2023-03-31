// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

class Conference {
  String? _title;
  String? _speaker;
  String? _position;
  String? _company;
  DateTime? _startTime;
  DateTime? _endTime;
  String? _location;

  Conference(
      {String? title,
      String? speaker,
      String? position,
      String? company,
      DateTime? startTime,
      DateTime? endTime,
      String? location}) {
    if (title != null) {
      _title = title;
    }
    if (speaker != null) {
      _speaker = speaker;
    }
    if (position != null) {
      _position = position;
    }
    if (company != null) {
      _company = company;
    }
    if (startTime != null) {
      _startTime = startTime;
    }
    if (endTime != null) {
      _endTime = endTime;
    }
    if (location != null) {
      _location = location;
    }
  }
  String? get location => _location;
  set location(String? location) => _location = location;
  String? get title => _title;
  set title(String? title) => _title = title;
  String? get speaker => _speaker;
  set speaker(String? speaker) => _speaker = speaker;
  String? get position => _position;
  set position(String? position) => _position = position;
  String? get company => _company;
  set company(String? company) => _company = company;
  DateTime? get startTime => _startTime;
  set startTime(DateTime? startTime) => _startTime = startTime;
  DateTime? get endTime => _endTime;
  set endTime(DateTime? endTime) => _endTime = endTime;

  Conference.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _speaker = json['speaker'];
    _position = json['position'];
    _company = json['company'];
    _startTime = DateTime.fromMillisecondsSinceEpoch(
        json['start_time'].millisecondsSinceEpoch);
    _endTime = DateTime.fromMillisecondsSinceEpoch(
        json['end_time'].millisecondsSinceEpoch);
    _location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = _title;
    data['speaker'] = _speaker;
    data['position'] = _position;
    data['company'] = _company;
    data['start_time'] = _startTime;
    data['end_time'] = _endTime;
    data['location'] = _location;
    return data;
  }

  factory Conference.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Conference(
        title: data?['title'],
        speaker: data?['speaker'],
        position: data?['position'],
        company: data?['company'],
        startTime: DateTime.fromMillisecondsSinceEpoch(
            data?['start_time'].millisecondsSinceEpoch),
        endTime: DateTime.fromMillisecondsSinceEpoch(
            data?['end_time'].millisecondsSinceEpoch),
        location: data?['location']);
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (speaker != null) "speaker": speaker,
      if (position != null) "position": position,
      if (company != null) "company": company,
      if (startTime != null) "start_time": (startTime),
      if (endTime != null) "end_time": (endTime),
      if (location != null) "location": (location),
    };
  }
}
