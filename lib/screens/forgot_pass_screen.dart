import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _emailController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: Colors.green[900],
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Introduce un correo por favor...';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      fillColor: Colors.white,
                      filled: true,
                      label: Text('Correo'),
                      labelStyle: TextStyle(backgroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: ElevatedButton.icon(
                            onPressed: () {
                              _formKey.currentState!.validate()
                                  ? context
                                      .read<FirebaseAuthMethods>()
                                      .sendPasswordResetEmail(
                                          email: _emailController.text,
                                          context: context)
                                      .whenComplete(
                                          () => _emailController.clear())
                                  : null;
                            },
                            icon: const Icon(CupertinoIcons.paperplane_fill),
                            label: const Text(
                              'Restablecer contraseña',
                              style: TextStyle(fontSize: 14),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  InkWell(
                      onTap: () => Navigator.of(context).pushNamed('/login'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.green[200],
                            size: 14,
                          ),
                          Text(
                            'Volver al inicio de sesión',
                            style: TextStyle(
                                color: Colors.green[300], fontSize: 14),
                          ),
                        ],
                      )),
                ],
              ),
            )));
  }
}
