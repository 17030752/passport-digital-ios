import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_digital_itc/providers/professor_provider.dart';
import 'package:passport_digital_itc/screens/professors/add_conference_screen.dart';
import 'package:passport_digital_itc/screens/widgets/custom_appbar.dart';
import 'package:passport_digital_itc/screens/widgets/bottomNavBarPWidget.dart';
import 'package:passport_digital_itc/screens/widgets/floatingActionButtonWidget.dart';
import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../models/conference_model.dart';
import '../../providers/conference_provider.dart';
import '../../providers/student_provider.dart';
import '../../services/firebase_auth_methods.dart';
import '../../utils/showSnackBar.dart';
import '../../utils/utilities.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});
  @override
  State<AdminScreen> createState() => AdminScreenState();
}

class AdminScreenState extends State<AdminScreen> {
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
  final TextEditingController _noControlTextController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
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
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(
            title: 'Menu Administradores',
          ),
        ),
        body: _listv2(mounted),
        floatingActionButton: _FloatingActionButtonWidget(
          options: [
            SpeedDialChild(
              child: const Icon(Icons.group_rounded),
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: 'Administrar Usuarios',
              onPressed: () {
                Navigator.of(context).pushNamed('/usersAdmin');
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.qr_code_scanner_rounded),
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: 'Escanear QR',
              onPressed: () {
                Provider.of<ProfessorProvider>(context, listen: false)
                    .scanQR(mounted, context);
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.edit_calendar_rounded),
              foregroundColor: Theme.of(context).colorScheme.onSecondary,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: 'Agregar conferencia',
              onPressed: () {
                Navigator.of(context).pushNamed('/addConference');
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavbarPWidget(
          role: '/admin',
        ));
  }

  String? result;
  Widget _listv2(dynamic mounted) {
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
                  return Container(
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
                                child: const Text('numero control'),
                              )
                            : ElevatedButton(
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
                    ),
                  );
                },
              );
          }
        });
  }

  _FloatingActionButtonWidget({required List<SpeedDialChild> options}) {
    return SpeedDial(
      speedDialChildren:
          !kIsWeb ? options : options.removeAt(1) as List<SpeedDialChild>,
      closedForegroundColor: Theme.of(context).colorScheme.secondary,
      openForegroundColor: Theme.of(context).colorScheme.onPrimary,
      closedBackgroundColor: Theme.of(context).colorScheme.primary,
      openBackgroundColor: Theme.of(context).colorScheme.secondary,
      labelsBackgroundColor: Theme.of(context).colorScheme.onSecondary,
      child: Icon(
        Icons.settings_rounded,
        color: Theme.of(context).colorScheme.onSecondary,
      ),
    );
  }
}
