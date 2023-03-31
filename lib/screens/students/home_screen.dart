import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:passport_digital_itc/models/conference_model.dart';
import 'package:passport_digital_itc/models/user_conference_model.dart';
import 'package:passport_digital_itc/providers/conference_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../providers/student_provider.dart';
import '../../services/firebase_auth_methods.dart';
import '../../utils/utilities.dart';
import '../widgets/bottomNavBarPWidget.dart';

class HomeStudentScreen extends StatefulWidget {
  const HomeStudentScreen({super.key});

  @override
  State<HomeStudentScreen> createState() => _HomeStudentScreenState();
}

class _HomeStudentScreenState extends State<HomeStudentScreen> {
  List<Conference> conference = [];
  // ignore: prefer_typing_uninitialized_variables
  var getConferences;
  // ignore: prefer_typing_uninitialized_variables
  var id;
  // ignore: prefer_typing_uninitialized_variables
  var student;
  // ignore: prefer_typing_uninitialized_variables
  var idConferences;
  var idByConferences;
  var conferenceItems;
  @override
  void initState() {
    final user = context.read<FirebaseAuthMethods>().user;
    idByConferences = Provider.of<List<String>?>(context, listen: false);
    conferenceItems = Provider.of<List<Conference>?>(context, listen: false);
    id = Provider.of<StudentProvider>(context, listen: false)
        .getStudentID(user!.email!);
    super.initState();
  }

  void splashScreen() async {
    WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
    await Future.delayed(const Duration(seconds: 1));
    FlutterNativeSplash.remove();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idUser = context.watch<StudentProvider>().id;
    idByConferences = Provider.of<List<String>?>(context);
    conferenceItems = Provider.of<List<Conference>?>(context);
    final stream =
        context.watch<ConferenceProvider>().getConferenceListStream();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Estudiante'),
      ),
      body: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('No hay reuniones de momento'),
              );
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              case ConnectionState.done:
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: conferenceItems?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () => showDialog(
                          context: context,
                          builder: (builder) {
                            return AlertDialog(
                              content:
                                  StatefulBuilder(builder: (builder, setState) {
                                final attendance = UserConferences(
                                    conferenceId: idByConferences[index],
                                    userId: idUser);
                                return _qrCode(attendance.toJson());
                              }),
                            );
                          }),
                      leading: const Icon(
                        Icons.calendar_month_sharp,
                        size: 35,
                      ),
                      title: Text(
                        "${conferenceItems[index].title}",
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${conferenceItems[index].speaker}",
                            style: const TextStyle(fontStyle: FontStyle.italic),
                          ),
                          Text(
                            "Hora: ${Utilities.formatHour(conferenceItems[index].startTime.toString(), 10, 16)} -${Utilities.formatHour(conferenceItems[index].endTime.toString(), 10, 16)}",
                          ),
                          Text(
                            "Ubicacion: ${conferenceItems[index].location ?? 'No disponible'}",
                          ),
                        ],
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Fecha',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            Utilities.formatHour(
                                conferenceItems[index].startTime.toString(),
                                0,
                                10),
                            style: const TextStyle(
                                color: Colors.green, fontSize: 15),
                          )
                        ],
                      ),
                    );
                  },
                );
            }
          }),
      bottomNavigationBar: BottomNavbarPWidget(
        role: '/student',
      ),
    );
  }

  Widget _qrCode(Map<String, dynamic> data) {
    String cadena = jsonEncode(data);
    return SizedBox(
      width: MediaQuery.of(context).size.width * .35,
      height: MediaQuery.of(context).size.height * .35,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cadena.isNotEmpty
                      ? Center(
                          child: Wrap(children: [
                            QrImage(
                              data: cadena,
                              backgroundColor: Colors.green[200]!,
                              size: MediaQuery.of(context).size.height * .25,
                            ),
                          ]),
                        )
                      : Center(
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.qr_code_2_outlined,
                              color: Colors.black26,
                              size: 100,
                            ),
                            Text(
                              'Aqui aparecera tu codigo de acceso...',
                              style: TextStyle(
                                  color: Colors.black26,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic),
                            )
                          ],
                        )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
