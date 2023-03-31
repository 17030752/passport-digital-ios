import 'package:cloud_firestore/cloud_firestore.dart';

class Student {
  String? career;
  String? email;
  String? name;
  String? noControl;
  String? role;

  Student({this.career, this.email, this.name, this.noControl, this.role});
  Student.fromJson(Map<String, dynamic> json) {
    career = json['career'];
    email = json['email'];
    name = json['name'];
    noControl = json['no_control'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['career'] = career;
    data['email'] = email;
    data['name'] = name;
    data['no_control'] = noControl;
    data['role'] = role;
    return data;
  }

  factory Student.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Student(
      career: data?['career'],
      email: data?['email'],
      name: data?['name'],
      noControl: data?['no_control'],
      role: data?['role'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (career != null) "career": career,
      if (email != null) "email": email,
      if (name != null) "name": name,
      if (noControl != null) "no_control": noControl,
      if (role != null) "role": role,
    };
  }
}
