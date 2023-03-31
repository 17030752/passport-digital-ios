import 'package:flutter/material.dart';
import 'package:passport_digital_itc/models/conference_model.dart';
import 'package:passport_digital_itc/models/student_model.dart';
import 'package:passport_digital_itc/providers/admin_provider.dart';
import 'package:passport_digital_itc/providers/conference_provider.dart';
import 'package:passport_digital_itc/providers/student_provider.dart';
import 'package:provider/provider.dart';

import '../../utils/showSnackBar.dart';

class addUserScreen extends StatefulWidget {
  final Student? user;
  final String? id;
  const addUserScreen({this.user, this.id, super.key});

  @override
  State<addUserScreen> createState() => _addUserScreenState();
}

class _addUserScreenState extends State<addUserScreen> {
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  final TextEditingController _roleController = TextEditingController();
  late TextEditingController _careerController;
  late TextEditingController _namesController;
  late TextEditingController _lastNamesController;
  late TextEditingController _noControlController;
  String? id;
  Student? user;
  String? role;
  // The reference to the navigator
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()
      ..addListener(() {
        Provider.of<AdminProvider>(context, listen: false)
            .setEmail(_emailController.text);
      });
    _careerController = TextEditingController()
      ..addListener(() {
        Provider.of<AdminProvider>(context, listen: false)
            .setCareer(_careerController.text);
      });
    _namesController = TextEditingController()
      ..addListener(() {
        Provider.of<AdminProvider>(context, listen: false)
            .setNames(_namesController.text);
      });
    _lastNamesController = TextEditingController()
      ..addListener(() {
        Provider.of<AdminProvider>(context, listen: false)
            .setLastNames(_lastNamesController.text);
      });
    _noControlController = TextEditingController()
      ..addListener(() {
        Provider.of<AdminProvider>(context, listen: false)
            .setNoControl(_noControlController.text);
      });
    isUpdate();
  }

  void isUpdate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final arguments =
            ModalRoute.of(context)!.settings.arguments as addUserScreen;
        //final hours = startTime.hour.toString().padLeft(2, '0');
        //final minutes = startTime.minute.toString().padLeft(2, '0');
        _namesController.text = arguments.user!.name!;
        _emailController.text = arguments.user!.email!;
        _noControlController.text = arguments.user!.noControl!;
        _careerController.text = arguments.user!.career!;
        _roleController.text = arguments.user!.role!;
        id = arguments.id;
        user = arguments.user;
        return;
      }
    });
  }

  @override
  void dispose() {
    _namesController.dispose();
    _emailController.dispose();
    _noControlController.dispose();
    _careerController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _clear() {
    _namesController.clear();
    _emailController.clear();
    _noControlController.clear();
    _careerController.clear();
    _roleController.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(ModalRoute.of(context)!.settings.arguments == null
              ? 'Agregar usuario'
              : 'Editar usuario'),
        ),
        body: (Form(
          key: _formKey,
          child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _textfield(
                      text: 'Nombre',
                      icon: Icons.person_rounded,
                      controller: _namesController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Email',
                      icon: Icons.email_rounded,
                      controller: _emailController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Carrera',
                      icon: Icons.factory_rounded,
                      controller: _careerController),
                  const Spacer(
                    flex: 1,
                  ),
                  _textfield(
                      text: 'Numero de control',
                      icon: Icons.numbers_rounded,
                      controller: _noControlController),
                  const Spacer(
                    flex: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownMenu(
                            controller: _roleController,
                            leadingIcon: Icon(Icons.badge_rounded),
                            label: const Text('Rol'),
                            dropdownMenuEntries: const [
                              DropdownMenuEntry(
                                  value: 'Estudiante', label: 'Estudiante'),
                              DropdownMenuEntry(
                                  value: 'Profesor', label: 'Profesor'),
                              DropdownMenuEntry(
                                  value: 'Monitor', label: 'Monitor'),
                              DropdownMenuEntry(
                                  value: 'JVP',
                                  label: 'Jefe vinculacion de proyectos')
                            ]),
                      ),
                    ],
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
      user?.name = _namesController.text;
      user?.email = _emailController.text;
      user?.career = _careerController.text;
      user?.noControl = _noControlController.text;
      user?.role = _roleController.text;
      context
          .read<AdminProvider>()
          .setUser(user: user!)
          .then((value) => showSnackBar(context, 'Usuario creado'))
          .catchError((error) =>
              showSnackBar(context, "Error al crear usuario $error"));
      return;
    }
    context
        .read<AdminProvider>()
        .updateConference(
          name: _namesController.text,
          email: _emailController.text,
          career: _careerController.text,
          noControl: _noControlController.text,
          role: _roleController.text,
          id: id!,
        )
        .then((value) => showSnackBar(context, 'Usuario actualizado'))
        .catchError((error) =>
            showSnackBar(context, "Error al actualizar usuario $error"));
  }
}
