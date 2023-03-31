import 'package:flutter/material.dart';
import 'package:passport_digital_itc/data/dbHelper.dart';
import 'package:passport_digital_itc/models/student_model.dart';

class StudentProvider with ChangeNotifier {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();
  final TextEditingController _namesController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _noControlController = TextEditingController();
  //getters
  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get careerController => _careerController;
  TextEditingController get namesController => _namesController;
  TextEditingController get lastNamesController => _lastNamesController;
  TextEditingController get noControlController => _noControlController;
  final List<Student> _students = [];
  Map<String, dynamic> _student = {};
  late Student _form;

  String _career = 'Carrera';
  String _email = 'Email';
  String _names = 'Nombres';
  String _lastnames = 'Apellidos';
  String _noControl = 'Numero de Control';
  String _role = 'Estudiante';
  String _id = '';

  String get career => _career;
  String get email => _email;
  String get names => _names;
  String get lastnames => _lastnames;
  String get noControl => _noControl;
  String get role => _role;
  String get id => _id;

  List<Student> get students {
    return [..._students];
  }

  Map<String, dynamic> get student {
    return {..._student};
  }

  set setStudentProvider(Map<String, dynamic> student) {
    DBHelper.registerStudent(student);
  }

  Future<void> getOneStudent(String email) async {
    _student = await DBHelper.getOneUser(email, "email");
    notifyListeners();
  }

  Future<void> getStudentID(String email) async {
    _id = await DBHelper.getUserID(email);
    notifyListeners();
  }

  Future<void> setStudent({
    required String career,
    required String email,
    required String name,
    required String noControl,
    required String role,
  }) async {
    _form = Student(
        career: career,
        email: email,
        name: name,
        noControl: noControl,
        role: role);
    DBHelper.registerStudent(_form.toJson());
    notifyListeners();
  }

  setCareer(String career) {
    _career = career;
    notifyListeners();
  }

  setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  setNames(String names) {
    _names = names;
    notifyListeners();
  }

  setLastNames(String lastnames) {
    _lastnames = lastnames;
    notifyListeners();
  }

  setNoControl(String noControl) {
    _noControl = noControl;
    notifyListeners();
  }

  setRole(String role) {
    _role = role;
    notifyListeners();
  }
}
