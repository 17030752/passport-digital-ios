import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:passport_digital_itc/providers/student_provider.dart';
import 'package:passport_digital_itc/services/firebase_auth_methods.dart';
import 'package:passport_digital_itc/utils/showSnackBar.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  final TextEditingController _passwordController = TextEditingController();
  late TextEditingController _careerController;
  late TextEditingController _namesController;
  late TextEditingController _lastNamesController;
  late TextEditingController _noControlController;
  bool isStudent = true;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _careerController.dispose();
    _namesController.dispose();
    _lastNamesController.dispose();
    _noControlController.dispose();
    super.dispose();
  }

  void clearForm() {
    _emailController.clear();
    _passwordController.clear();
    _careerController.clear();
    _namesController.clear();
    _lastNamesController.clear();
    _noControlController.clear();
  }

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()
      ..addListener(() {
        Provider.of<StudentProvider>(context, listen: false)
            .setEmail(_emailController.text);
      });
    _careerController = TextEditingController()
      ..addListener(() {
        Provider.of<StudentProvider>(context, listen: false)
            .setCareer(_careerController.text);
      });
    _namesController = TextEditingController()
      ..addListener(() {
        Provider.of<StudentProvider>(context, listen: false)
            .setNames(_namesController.text);
      });
    _lastNamesController = TextEditingController()
      ..addListener(() {
        Provider.of<StudentProvider>(context, listen: false)
            .setLastNames(_lastNamesController.text);
      });
    _noControlController = TextEditingController()
      ..addListener(() {
        Provider.of<StudentProvider>(context, listen: false)
            .setNoControl(_noControlController.text);
      });
  }

  // ignore: unused_element
  void _loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
        email: _emailController.text,
        password: _passwordController.text,
        context: context);
  }

  void _singUpUser(String name) {
    String role = context.read<StudentProvider>().role;
    context
        .read<FirebaseAuthMethods>()
        .signUpWithEmail(
            email: _emailController.text,
            password: _passwordController.text,
            context: context)
        .then((value) {
      if (value == true) {
        context.read<StudentProvider>().setStudent(
            career: _careerController.text,
            email: _emailController.text,
            name: name,
            noControl: _noControlController.text,
            role: role);
        showSnackBar(context, 'Registrado revisa tu correo ! ');
        return;
      }
    });
  }

  void registerStudent() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.green[900],
        body: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 25,
                    child: Align(
                      alignment: Alignment.center,
                      child: Icon(
                        CupertinoIcons.person_crop_circle_fill_badge_plus,
                        size: 50,
                      ),
                    )),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Formato: Cada palabra debe comenzar por una letra mayuscula y separada por un unico espacio, excepto por los campos correo, numero de control y contraseña.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.green[600],
                            fontStyle: FontStyle.italic),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                          controller: _namesController,
                          keyboardType: TextInputType.text,
                          validator: (value) => _validator(value,
                              r'^[A-ZÀ-ÖØ-öø-ÿ][a-zÀ-ÖØ-öø-ÿ]*( [A-ZÀ-ÖØ-öø-ÿ][a-zÀ-ÖØ-öø-ÿ]*)*$'),
                          decoration: _inputDecoration(
                              labelText: 'Nombres',
                              filled: true,
                              fillColor: Colors.grey[100],
                              borderSide:
                                  Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(5))),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: TextFormField(
                          controller: _lastNamesController,
                          validator: (value) => _validator(value,
                              r'^[A-ZÀ-ÖØ-öø-ÿ][a-zÀ-ÖØ-öø-ÿ]*( [A-ZÀ-ÖØ-öø-ÿ][a-zÀ-ÖØ-öø-ÿ]*)*$'),
                          keyboardType: TextInputType.text,
                          decoration: _inputDecoration(
                              labelText: 'Apellidos',
                              filled: true,
                              fillColor: Colors.grey[100],
                              borderSide:
                                  Theme.of(context).colorScheme.secondary,
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    controller: _careerController,
                    validator: (value) => _validator(value,
                        r'^[A-ZÀ-ÖØ-öø-ÿ][a-zÀ-ÖØ-öø-ÿ]*( [A-ZÀ-ÖØ-öø-ÿ][a-zÀ-ÖØ-öø-ÿ]*)*$'),
                    keyboardType: TextInputType.text,
                    decoration: _inputDecoration(
                        labelText: 'Carrera',
                        filled: true,
                        fillColor: Colors.grey[100],
                        borderSide: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5))),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    controller: _emailController,
                    validator: (value) => isStudent == true
                        ? _validator(value, r'^[0-9]+@itcelaya\.edu\.mx$')
                        : _validator(
                            value, r'^[^\d][\w.-]+@itcelaya\.edu\.mx$'),
                    // inputFormatters: _inputFormat(r'\S+@\S+\.\S+', 8),
                    decoration: _inputDecoration(
                        labelText: 'Correo institucional',
                        filled: true,
                        fillColor: Colors.grey[100],
                        borderSide: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5))),
                SizedBox(
                  height: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 0,
                        child: Text(
                          '¿Eres alumno?',
                          style: TextStyle(color: Colors.green[300]),
                        ),
                      ),
                      Checkbox(
                          value: context.watch<StudentProvider>().role ==
                              'Estudiante',
                          fillColor:
                              MaterialStateProperty.all(Colors.green[800]),
                          onChanged: (bool? value) {
                            context.read<StudentProvider>().setRole(
                                value == true ? 'Estudiante' : 'Profesor');
                          })
                    ],
                  ),
                ),
                TextFormField(
                    controller: _noControlController,
                    validator: (value) => _validator(value, r'^[0-9]+$'),
                    maxLength: 8,
                    inputFormatters: _inputFormat('', 8),
                    decoration: _inputDecoration(
                        labelText: 'Numero de control',
                        filled: true,
                        fillColor: Colors.grey[100],
                        borderSide: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5))),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                    controller: _passwordController,
                    decoration: _inputDecoration(
                        labelText: 'Contraseña',
                        filled: true,
                        fillColor: Colors.grey[100],
                        borderSide: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5))),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Ya eres miembro?',
                      style: TextStyle(color: Colors.green[600]),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/login');
                      },
                      child: Text('Inicia Sesion',
                          style: TextStyle(color: Colors.green[300])),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .08,
                  child: ElevatedButton.icon(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _getData();
                        }
                      },
                      icon: const Icon(CupertinoIcons.paperplane_fill),
                      label: const Text('Registrar')),
                )
              ],
            ),
          ),
        ));
  }

  void _getData() async {
    String text = _namesController.text;
    text += ' ${_lastNamesController.text}';
    _singUpUser(text);
  }

  InputDecoration _inputDecoration(
      {String? labelText,
      bool? filled,
      Color? fillColor,
      required Color borderSide,
      required BorderRadius borderRadius}) {
    return InputDecoration(
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
          borderRadius: borderRadius),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: borderSide),
          borderRadius: borderRadius),
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.red)),
      errorStyle: const TextStyle(
        color: Colors.red,
      ),
    );
  }

  List<TextInputFormatter>? _inputFormat(
      String expression, int? maxCharacters) {
    List<TextInputFormatter> res = [];
    if (expression.isEmpty) {
      res = [LengthLimitingTextInputFormatter(maxCharacters)];
    } else {
      res = [
        FilteringTextInputFormatter.allow(RegExp(expression)),
        LengthLimitingTextInputFormatter(maxCharacters)
      ];
    }
    return res;
  }

  String? _validator(value, String expression) {
    var re = RegExp(expression);
    return re.hasMatch(value) ? null : 'Por favor introduce un formato valido';
  }
}
