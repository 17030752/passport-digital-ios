import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/models/student_model.dart';
import 'package:passport_digital_itc/providers/student_provider.dart';
import 'package:passport_digital_itc/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> student = <String, dynamic>{};
  List students = <Student>[];
  String email = '';
  var getCredentialData;
  var user;
  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _init() async {
    user = context.read<FirebaseAuthMethods>().user;
    getCredentialData =
        context.read<StudentProvider>().getOneStudent(user.email);
  }

  @override
  Widget build(BuildContext context) {
    student = context.watch<StudentProvider>().student;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informacion Academica'),
      ),
      body: FutureBuilder(
        future: getCredentialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                    child: Column(
                  children: const [
                    Icon(Icons.sentiment_dissatisfied_rounded),
                    Text('Ups algo sucedio inesperado...')
                  ],
                ));
              }
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 8.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Theme.of(context).colorScheme.outline,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 16),
                        height: 200,
                        width: 350,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green[50]!,
                                  radius: 50, //we give the image a radius of 50
                                  child: Stack(
                                    children: [
                                      const Icon(
                                          CupertinoIcons.person_alt_circle,
                                          size: 100,
                                          color: Colors.green),
                                      Positioned(
                                          right: 10,
                                          bottom: double.minPositive,
                                          child: user!.emailVerified == true
                                              ? const CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .checkmark_circle_fill,
                                                  ),
                                                )
                                              : const CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.white,
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .question_diamond_fill,
                                                    color: Colors.orange,
                                                  ),
                                                ))
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  //CrossAxisAlignment.end ensures the components are aligned from the right to left.
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 8),
                                      width: 150,
                                      color: Colors.black54,
                                      height: 2,
                                    ),
                                    const SizedBox(height: 4),
                                    Text('+${student['no_control']}'),
                                    const Text(
                                      'TECNOLOGICO NACIONAL DE MEXICO',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const Text('CELAYA'),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${student['name']}',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${student['career']}'),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${student['role']}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text('${DateTime.now().year}'),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /* const Divider(),
                InkWell(
                  onTap: () {
                    debugPrint('press tab');
                  },
                  child: const Text('actualizar perfil'),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    debugPrint('press tab');
                  },
                  child: const Text('eliminar cuenta'),
                ),
                const Divider(), */
                        user.emailVerified == false
                            ? ActionChip(
                                backgroundColor: Colors.yellow,
                                label: const Text('Verificar correo'),
                                onPressed: () {
                                  context
                                      .read<FirebaseAuthMethods>()
                                      .sendEmailVerification(context);
                                },
                              )
                            : const SizedBox(),
                      ],
                    )
                  ],
                ),
              );
          }
        },
      ),
    );
  }
}
