import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:passport_digital_itc/providers/professor_provider.dart';
import 'package:passport_digital_itc/screens/professors/add_conference_screen.dart';
import 'package:passport_digital_itc/screens/widgets/bottomNavBarPWidget.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../models/conference_model.dart';
import '../../models/user_conference_model.dart';
import '../../providers/conference_provider.dart';
import '../../providers/student_provider.dart';
import '../../services/firebase_auth_methods.dart';
import '../../utils/showSnackBar.dart';
import '../../utils/utilities.dart';
import '../widgets/floatingActionButtonWidget.dart';

class HomeScreenProfessor extends StatefulWidget {
  const HomeScreenProfessor({super.key});
  @override
  State<HomeScreenProfessor> createState() => HomeScreenProfessorState();
}

class HomeScreenProfessorState extends State<HomeScreenProfessor> {
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
  String _scanBarCode = 'unknown';
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    idByConferences = Provider.of<List<String>?>(context, listen: false);
    conferenceItems = Provider.of<List<Conference>?>(context, listen: false);
    _loadData();
  }

  Future<void> _loadData() async {
    final user = context.read<FirebaseAuthMethods>().user;
    getConferences = Provider.of<ConferenceProvider>(context, listen: false)
        .getConferences();
    id = Provider.of<StudentProvider>(context, listen: false)
        .getStudentID(user?.email ?? '');
    idConferences = Provider.of<ConferenceProvider>(context, listen: false)
        .getID("conferences");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Menu Profesores'),
        ),
        body: body(mounted),
        floatingActionButton: FloatingActionButtonWidget(options: []),
        bottomNavigationBar: BottomNavbarPWidget(
          role: '/professors',
        ));
  }

  Widget body(dynamic mounted) {
    final stream =
        context.watch<ConferenceProvider>().getConferenceListStream();
    idByConferences = Provider.of<List<String>?>(context);
    conferenceItems = Provider.of<List<Conference>?>(context);
    return StreamBuilder(
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
                  return SizedBox(
                    width: double.infinity,
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        ElevatedButton(
                            onPressed: () async {
                              await context
                                  .read<ConferenceProvider>()
                                  .deleteConference(idByConferences[index])
                                  .then(
                                    (doc) => showSnackBar(
                                        context, 'Documento borrado'),
                                    onError: (e) => showSnackBar(context,
                                        'Error actualizando documento $e'),
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[900],
                                shape: const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                fixedSize: const Size(100, 5),
                                minimumSize: const Size(100, 5)),
                            child: const Icon(
                              CupertinoIcons.trash,
                              size: 50,
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          child: ListTile(
                            onTap: () => Navigator.of(context).pushNamed(
                                '/addConference',
                                arguments: AddConferenceScreen(
                                    conference: conferenceItems[index],
                                    id: idByConferences[index])),
                            leading: const Icon(
                              Icons.calendar_month_sharp,
                              size: 35,
                            ),
                            title: Text(
                              "${conferenceItems[index].title}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${conferenceItems[index].speaker}",
                                  style: const TextStyle(
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  "Hora: ${Utilities.formatHour(conferenceItems[index].startTime.toString(), 10, 16)} -${Utilities.formatHour(conferenceItems[index].endTime.toString(), 10, 16)}",
                                ),
                                Text(
                                  "IDC: ${idByConferences[index]}",
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
                                      conferenceItems[index]
                                          .startTime
                                          .toString(),
                                      0,
                                      10),
                                  style: const TextStyle(
                                      color: Colors.green, fontSize: 15),
                                )
                              ],
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Provider.of<ProfessorProvider>(context,
                                      listen: false)
                                  .scanBarcodeNormal(
                                      mounted, context, idByConferences[index]);
                            },
                            style: ElevatedButton.styleFrom(
                                shape: const BeveledRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                                fixedSize: const Size(100, 5),
                                minimumSize: const Size(100, 5)),
                            child: const Icon(
                              CupertinoIcons.barcode,
                              size: 50,
                            )),
                      ],
                    ),
                  );
                },
              );
          }
        });
  }

  Widget _list(bool mounted) {
    var idUser = context.watch<StudentProvider>().id;
    var idByConferences = context.watch<ConferenceProvider>().ids;
    var conference = context.watch<ConferenceProvider>().conferences;
    return RefreshIndicator(
      onRefresh: () async {
        // monitor network fetch
        idUser = context.read<StudentProvider>().id;
        idByConferences = context.read<ConferenceProvider>().ids;
        conference = context.read<ConferenceProvider>().conferences;
        _loadData();
        await Future.delayed(const Duration(milliseconds: 1000));
        // if failed,use refreshFailed()
        //_refreshController.refreshCompleted();
      },
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: conference.length,
          itemBuilder: (BuildContext context, int index) {
            return FutureBuilder(
              future: getConferences,
              builder: (context, snapshot) {
                Widget result =
                    const Center(child: CircularProgressIndicator());
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    return result;
                  default:
                    if (snapshot.hasError) {
                      return result = Text('Error: ${snapshot.error}');
                    } else {
                      return result = Container(
                          width: double.infinity,
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    context
                                        .read<ConferenceProvider>()
                                        .deleteConference(
                                            idByConferences[index])
                                        .whenComplete(() {
                                      getConferences = context
                                          .read<ConferenceProvider>()
                                          .getConferences();
                                      conference = context
                                          .read<ConferenceProvider>()
                                          .conferences;
                                    });
                                    idByConferences =
                                        context.read<ConferenceProvider>().ids;
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red[900],
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                      fixedSize: const Size(100, 5),
                                      minimumSize: const Size(100, 5)),
                                  child: const Icon(
                                    CupertinoIcons.trash,
                                    size: 50,
                                  )),
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 100,
                                child: ListTile(
                                  onTap: () => Navigator.of(context).pushNamed(
                                      '/addConference',
                                      arguments: AddConferenceScreen(
                                          conference: conference[index],
                                          id: idByConferences[index])),
                                  leading: const Icon(
                                    Icons.calendar_month_sharp,
                                    size: 35,
                                  ),
                                  title: Text(
                                    "${conference[index].title}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${conference[index].speaker}",
                                        style: const TextStyle(
                                            fontStyle: FontStyle.italic),
                                      ),
                                      Text(
                                        "Hora: ${Utilities.formatHour(conference[index].startTime.toString(), 10, 16)} -${Utilities.formatHour(conference[index].endTime.toString(), 10, 16)}",
                                      ),
                                      Text(
                                        "ID: ${idByConferences[index]}",
                                      ),
                                      Text(
                                        "Ubicacion: ${conference[index].location}",
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Fecha',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        Utilities.formatHour(
                                            conference[index]
                                                .startTime
                                                .toString(),
                                            0,
                                            10),
                                        style: const TextStyle(
                                            color: Colors.green, fontSize: 15),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    Provider.of<ProfessorProvider>(context,
                                            listen: false)
                                        .scanBarcodeNormal(mounted, context,
                                            idByConferences[index]);
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.zero),
                                      fixedSize: const Size(100, 5),
                                      minimumSize: const Size(100, 5)),
                                  child: const Icon(
                                    CupertinoIcons.barcode,
                                    size: 50,
                                  )),
                            ],
                          ));
                    }
                }
              },
            );
          }),
    );
  }
}
