import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/data/dbHelper.dart';
import 'package:passport_digital_itc/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // ignore: unused_element
  void _loginUser() async {
    context.read<FirebaseAuthMethods>().loginWithEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context);
    final firebaseUser = Provider.of<User?>(context, listen: false);
    // final email = firebaseUser != null ? firebaseUser.email : '';
    // context.read<FirebaseAuthMethods>().getRole(email);
  }

  // ignore: unused_element
  void _singUpUser() async {
    context.read<FirebaseAuthMethods>().signUpWithEmail(
        email: emailController.text,
        password: passwordController.text,
        context: context);
    emailController.clear();
    passwordController.clear();
  }

  @override
  void initState() {
    super.initState();
    /* WidgetsBinding.instance.addPostFrameCallback((_) {
       showDialogNotification(
           context,
          'Aviso Importante',
          'Recuerda verificar tu correo una vez registrado para poder acceder a la aplicacion 📫',
          Icons.warning_amber_rounded,
           Colors.yellowAccent[700]!);
     }); */
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.green[900],
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: Icon(
                  CupertinoIcons.person_alt_circle_fill,
                  size: 100,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  children: [
                    TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return "Por favor introduce algun texto..";
                        },
                        decoration: _inputDecoration(
                            labelText: 'correo',
                            filled: true,
                            fillColor: Colors.grey[100],
                            borderSide: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(5))),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return null;
                          }
                          return "Por favor introduce algun texto..";
                        },
                        decoration: _inputDecoration(
                            labelText: 'clave',
                            filled: true,
                            fillColor: Colors.grey[100],
                            borderSide: Theme.of(context).colorScheme.secondary,
                            borderRadius: BorderRadius.circular(5))),
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  child: Text(
                                    'Olvidaste tu contraseña?',
                                    style: TextStyle(color: Colors.green[300]),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .popAndPushNamed('/forgotpassword');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.height / 10,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _loginUser();
                                  }
                                },
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.green[100])),
                                child: const Text(
                                  'Entrar',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                Text(
                                  'No tienes cuenta?',
                                  style: TextStyle(color: Colors.green[600]),
                                ),
                                InkWell(
                                  child: Text(
                                    'Registrate ahora',
                                    style: TextStyle(color: Colors.green[300]),
                                  ),
                                  onTap: () {
                                    Navigator.of(context)
                                        .popAndPushNamed('/register');
                                  },
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {String? labelText,
      bool? filled,
      Color? fillColor,
      required Color borderSide,
      required BorderRadius borderRadius}) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle: TextStyle(
          color: Colors.white,
          backgroundColor: Theme.of(context).colorScheme.secondary),
      filled: filled,
      fillColor: fillColor,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.green[900]!),
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
}
