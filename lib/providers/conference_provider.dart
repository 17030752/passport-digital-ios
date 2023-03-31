import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/data/dbHelper.dart';
import 'package:passport_digital_itc/models/conference_model.dart';

class ConferenceProvider extends ChangeNotifier {
  static final db = FirebaseFirestore.instance;
  List<Conference> _conferences = [];
  List<String> _id = [];
  String _company = '';
  String _position = '';
  String _speaker = '';
  String _title = '';
  String _location = '';
  DateTime _startTime = DateTime.now();
  DateTime _endTime = DateTime.now();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  TextEditingController get startTimeController => _startTimeController;
  TextEditingController get endTimeController => _endTimeController;
  DateTime get startTime => _startTime;
  DateTime get endTime => _endTime;

  setCompany(String company) {
    _company = company;
    notifyListeners();
  }

  setPosition(String position) {
    _position = position;
    notifyListeners();
  }

  setSpeaker(String speaker) {
    _speaker = speaker;
    notifyListeners();
  }

  setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  setStartTime(DateTime startTime) {
    _startTime = startTime;
    notifyListeners();
  }

  setEndTime(DateTime endTime) {
    _endTime = endTime;
    notifyListeners();
  }

  setLocation(String location) {
    _location = location;
    notifyListeners();
  }

  Future<void> setConference({
    required String company,
    required String speaker,
    required String title,
    required String position,
    required String location,
  }) async {
    _company = company;
    _speaker = speaker;
    _title = title;
    _position = position;
    _location = location;
    final data = Conference(
        company: company,
        speaker: speaker,
        title: title,
        position: position,
        location: location,
        startTime: _startTime,
        endTime: _endTime);
    DBHelper.registerConference(data);
  }

  Future<void> updateConference({
    required String company,
    required String speaker,
    required String title,
    required String position,
    required String location,
    required String id,
  }) async {
    _company = company;
    _speaker = speaker;
    _title = title;
    _position = position;
    _location = location;
    final data = Conference(
        company: company,
        speaker: speaker,
        title: title,
        position: position,
        location: location,
        startTime: _startTime,
        endTime: _endTime);
    DBHelper.updateConference(data, id);
  }

  Future<DateTime?> pickDate(BuildContext context,
          [int? firstDate, int? lastDate]) =>
      showDatePicker(
          context: context,
          initialDate: _startTime,
          firstDate: DateTime(firstDate ?? DateTime.now().year),
          lastDate: DateTime(lastDate ?? DateTime.now().year + 1));

  Future<TimeOfDay?> pickTime(BuildContext context) => showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _startTime.hour, minute: _startTime.minute));

  Future<String> pickDateTime(BuildContext context,
      {int? firstDate, int? lastDate, bool isStartDate = true}) async {
    DateTime? date = await pickDate(context, firstDate, lastDate);
    TimeOfDay? time = await pickTime(context);
    DateTime dateTime;
    String response = '';
    if (isStartDate == true && date != null && time != null) {
      dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      _startTime = dateTime;
      response = _startTime.toString().substring(0, 19);
      notifyListeners();
      return response;
    }
    if (isStartDate == false && date != null && time != null) {
      dateTime =
          DateTime(date.year, date.month, date.day, time.hour, time.minute);
      _endTime = dateTime;
      response = _endTime.toString().substring(0, 19);
      notifyListeners();
      return response;
    }
    return response;
  }

  List<Conference> get conferences {
    return [..._conferences];
  }

  List<String> get ids {
    return [..._id];
  }

  Future<void> getConferences() async {
    _conferences = await DBHelper.getConferences();
    notifyListeners();
  }

  Future<void> getID(String collection) async {
    _id = await DBHelper.getIdByCollection(collection);
  }

  Future<void> deleteConference(String id) async {
    await DBHelper.deleteConference(id);
  }

  Stream<List<Conference>?> getConferenceListStream() {
    return db.collection('conferences').snapshots().map((snapShot) => snapShot
        .docs
        .map((document) => Conference.fromJson(document.data()))
        .toList());
  }

  Stream<List<String>?> getIdByConferenceStream() {
    return db.collection('conferences').snapshots().map(
        (snapShot) => snapShot.docs.map((document) => document.id).toList());
  }
}
