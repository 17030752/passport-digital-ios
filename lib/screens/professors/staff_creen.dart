import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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

class HomeScreenStaff extends StatefulWidget {
  const HomeScreenStaff({super.key});
  @override
  State<HomeScreenStaff> createState() => HomeScreenStaffState();
}

class HomeScreenStaffState extends State<HomeScreenStaff> {
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noControlTextController =
      TextEditingController();
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
          title: const Text('Menu Staff'),
        ),
        body: body(mounted),
        floatingActionButton: !kIsWeb
            ? FloatingActionButton(
                tooltip: 'Escanear QR',
                onPressed: () {
                  Provider.of<ProfessorProvider>(context, listen: false)
                      .scanQR(mounted, context);
                },
                child: const Icon(Icons.qr_code_scanner_rounded))
            : null,
        bottomNavigationBar: BottomNavbarPWidget(
          role: '/staff',
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.sentiment_dissatisfied,
                    size: 100,
                    color: Colors.grey[300],
                  ),
                  Text('Ups...ocurrió algo inespedaro',
                      style: TextStyle(
                          color: Colors.grey[300],
                          fontStyle: FontStyle.italic)),
                ],
              ),
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
                  return Container(
                    width: double.infinity,
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        kIsWeb
                            ? ElevatedButton(
                                onPressed: () async {
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      maxLength: 8,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            8)
                                                      ],
                                                      controller:
                                                          _noControlTextController,
                                                      decoration:
                                                          const InputDecoration(
                                                        icon: Icon(Icons
                                                            .numbers_rounded),
                                                        hintText:
                                                            'Introduce numero de control..',
                                                        labelText:
                                                            'No.Control *',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Porfavor introduce un texto';
                                                        } else if (!RegExp(
                                                                r'^\S{8}$')
                                                            .hasMatch(value)) {
                                                          return "Por favor introduce un numero de control valido";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Registrar'),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<ProfessorProvider>()
                                                    .digitBarcode(
                                                        _noControlTextController
                                                            .text,
                                                        context,
                                                        idByConferences[index]);
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    const Icon(
                                      CupertinoIcons.barcode,
                                      size: 50,
                                    ),
                                    Positioned(
                                      left: 35,
                                      child: Container(
                                        color: Colors.white,
                                        child: Icon(
                                          CupertinoIcons
                                              .pencil_ellipsis_rectangle,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          size: 15,
                                        ),
                                      ),
                                    )
                                  ],
                                ))
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                                onPressed: () async {
                                  return showDialog<void>(
                                    context: context,
                                    barrierDismissible:
                                        false, // user must tap button!
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: SingleChildScrollView(
                                          child: ListBody(
                                            children: <Widget>[
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextFormField(
                                                      maxLength: 8,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            8)
                                                      ],
                                                      controller:
                                                          _noControlTextController,
                                                      decoration:
                                                          const InputDecoration(
                                                        icon: Icon(Icons
                                                            .numbers_rounded),
                                                        hintText:
                                                            'Introduce numero de control..',
                                                        labelText:
                                                            'No.Control *',
                                                      ),
                                                      validator: (value) {
                                                        if (value == null ||
                                                            value.isEmpty) {
                                                          return 'Porfavor introduce un texto';
                                                        } else if (!RegExp(
                                                                r'^\S{8}$')
                                                            .hasMatch(value)) {
                                                          return "Por favor introduce un numero de control valido";
                                                        }
                                                        return null;
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Registrar'),
                                            onPressed: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context
                                                    .read<ProfessorProvider>()
                                                    .digitBarcode(
                                                        _noControlTextController
                                                            .text,
                                                        context,
                                                        idByConferences[index]);
                                              }
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Cancelar'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  CupertinoIcons.pencil_ellipsis_rectangle,
                                  color:
                                      Theme.of(context).colorScheme.onSecondary,
                                  size: 50,
                                ),
                              ),
                        Container(
                          color: Colors.green[900],
                          width: 2,
                        ),
                        ElevatedButton(
                            onPressed: () => Provider.of<ProfessorProvider>(
                                    context,
                                    listen: false)
                                .scanBarcodeNormal(
                                    mounted, context, idByConferences[index]),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              shape: const BeveledRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                            ),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                Icon(
                                  Icons.calendar_month_sharp,
                                  size: 50,
                                ),
                                Positioned(
                                  left: 35,
                                  child: Container(
                                    color: Colors.white,
                                    child: Icon(
                                      CupertinoIcons.barcode,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 15,
                                    ),
                                  ),
                                )
                              ],
                            )),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ListTile(
                            onTap: () => Navigator.of(context).pushNamed(
                                '/addConference',
                                arguments: AddConferenceScreen(
                                    conference: conferenceItems[index],
                                    id: idByConferences[index])),
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
                      ],
                    ),
                  );
                },
              );
          }
        });
  }
}
