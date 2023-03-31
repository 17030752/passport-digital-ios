import 'package:flutter/material.dart';
import 'package:passport_digital_itc/models/conference_model.dart';
import 'package:passport_digital_itc/providers/conference_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/showSnackBar.dart';

class AddConferenceScreen extends StatefulWidget {
  final Conference? conference;
  final String? id;
  const AddConferenceScreen({this.conference, this.id, super.key});

  @override
  State<AddConferenceScreen> createState() => _AddConferenceScreenState();
}

class _AddConferenceScreenState extends State<AddConferenceScreen> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _speakerController;
  late TextEditingController _endTimeController;
  late TextEditingController _startTimeController;
  late TextEditingController _locationController;
  String? id;
  // The reference to the navigator
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController()
      ..addListener(() {
        Provider.of<ConferenceProvider>(context, listen: false)
            .setTitle(_titleController.text);
      });
    _companyController = TextEditingController()
      ..addListener(() {
        Provider.of<ConferenceProvider>(context, listen: false)
            .setCompany(_companyController.text);
      });
    _positionController = TextEditingController()
      ..addListener(() {
        Provider.of<ConferenceProvider>(context, listen: false)
            .setPosition(_positionController.text);
      });
    _speakerController = TextEditingController()
      ..addListener(() {
        Provider.of<ConferenceProvider>(context, listen: false)
            .setSpeaker(_speakerController.text);
      });
    _locationController = TextEditingController()
      ..addListener(() {
        Provider.of<ConferenceProvider>(context, listen: false)
            .setLocation(_locationController.text);
      });
    _startTimeController = TextEditingController();
    _endTimeController = TextEditingController();
    isUpdate();
  }

  void isUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final arguments =
            ModalRoute.of(context)!.settings.arguments as AddConferenceScreen;
        //final hours = startTime.hour.toString().padLeft(2, '0');
        //final minutes = startTime.minute.toString().padLeft(2, '0');
        _titleController.text = arguments.conference!.title!;
        _companyController.text = arguments.conference!.company!;
        _speakerController.text = arguments.conference!.speaker!;
        _positionController.text = arguments.conference!.position!;
        _locationController.text =
            arguments.conference?.location ?? 'No disponible';
        _startTimeController.text =
            arguments.conference!.startTime.toString().substring(0, 19);
        _endTimeController.text =
            arguments.conference!.endTime.toString().substring(0, 19);
        id = arguments.id;
        return;
      }
    });
  }

  @override
  void dispose() {
    _companyController.dispose();
    _speakerController.dispose();
    _titleController.dispose();
    _positionController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _clear() {
    _companyController.clear();
    _speakerController.clear();
    _titleController.clear();
    _positionController.clear();
    _startTimeController.clear();
    _endTimeController.clear();
    _locationController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(ModalRoute.of(context)!.settings.arguments == null
              ? 'Agregar conferencia'
              : 'Editar conferencia'),
        ),
        body: (Form(
          key: _formKey,
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                children: [
                  _textfield(
                      text: 'Titulo de la conferencia',
                      icon: Icons.text_fields_rounded,
                      controller: _titleController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Empresa',
                      icon: Icons.factory_rounded,
                      controller: _companyController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Cargo del ponente',
                      icon: Icons.assignment_ind,
                      controller: _positionController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Nombre del ponente',
                      icon: Icons.text_fields_rounded,
                      controller: _speakerController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Ubicación',
                      icon: Icons.pin_drop_rounded,
                      controller: _locationController),
                  const Spacer(
                    flex: 1,
                  ),
                  TextFormField(
                    controller: _startTimeController,
                    readOnly: true,

                    onTap: () async {
                      _startTimeController.text = await context
                          .read<ConferenceProvider>()
                          .pickDateTime(context);
                    },
                    decoration: _inputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        icon: Icons.calendar_month_rounded,
                        hintText: 'Fecha de Inicio',
                        labelText: 'Fecha de Inicio',
                        filled: true,
                        fillColor: Colors.white,
                        borderSide: Theme.of(context).colorScheme.secondary,
                        borderRadius: 5),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce un texto..';
                      }
                      return null;
                    },
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  TextFormField(
                    controller: _endTimeController,
                    readOnly: true,
                    onTap: () async {
                      _endTimeController.text = await context
                          .read<ConferenceProvider>()
                          .pickDateTime(context, isStartDate: false);
                    },
                    decoration: _inputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        icon: Icons.calendar_month_rounded,
                        hintText: 'Fecha de Fin',
                        labelText: 'Fecha de Fin',
                        filled: true,
                        fillColor: Colors.white,
                        borderSide: Theme.of(context).colorScheme.secondary,
                        borderRadius: 5),
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor introduce un texto..';
                      }
                      return null;
                    },
                  ),
                  const Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                send();
                                _clear();
                              }
                            },
                            icon: const Icon(Icons.send_rounded),
                            label: Text(
                                ModalRoute.of(context)!.settings.arguments ==
                                        null
                                    ? 'Registrar'
                                    : 'Actualizar')),
                      ),
                    ],
                  ),
                ],
              )),
        )));
  }

  _textfield(
      {String? text, TextEditingController? controller, IconData? icon}) {
    return TextFormField(
      controller: controller,
      decoration: _inputDecoration(
          icon: icon,
          labelText: text,
          filled: true,
          fillColor: Colors.white,
          borderSide: Theme.of(context).colorScheme.secondary,
          borderRadius: 5),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor introduce un texto..';
        }
        return null;
      },
    );
  }

  InputDecoration _inputDecoration(
      {FloatingLabelBehavior? floatingLabelBehavior,
      IconData? icon,
      String? labelText,
      String? hintText,
      bool? filled,
      Color? fillColor,
      required Color borderSide,
      required double borderRadius}) {
    return InputDecoration(
      hintText: hintText,
      floatingLabelBehavior: floatingLabelBehavior,
      suffixIcon: Icon(icon),
      counterStyle: TextStyle(color: Colors.green[300]),
      labelText: labelText,
      floatingLabelStyle: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSecondary,
          backgroundColor: borderSide),
      filled: filled,
      fillColor: fillColor,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.primary),
          borderRadius: BorderRadius.circular(borderRadius)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderSide),
          borderRadius: BorderRadius.circular(borderRadius)),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red)),
      errorStyle: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  send() {
    if (id == null) {
      context
          .read<ConferenceProvider>()
          .setConference(
            company: _companyController.text,
            speaker: _speakerController.text,
            title: _titleController.text,
            position: _positionController.text,
            location: _locationController.text,
          )
          .then((value) => showSnackBar(context, 'Documento creado'))
          .catchError((error) =>
              showSnackBar(context, "Error al crear documento $error"));
      return;
    }
    context
        .read<ConferenceProvider>()
        .updateConference(
          company: _companyController.text,
          speaker: _speakerController.text,
          title: _titleController.text,
          position: _positionController.text,
          location: _locationController.text,
          id: id!,
        )
        .then((value) => showSnackBar(context, 'Documento creado'))
        .catchError((error) =>
            showSnackBar(context, "Error al crear documento $error"));
  }
}
