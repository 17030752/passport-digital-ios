import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _introkey = GlobalKey<IntroductionScreenState>();
  final String _status = 'waiting';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        key: _introkey,
        next: const Text('Siguiente'),
        showSkipButton: true,
        showNextButton: true,
        showBackButton: false,
        showDoneButton: true,
        skip: const Text("Saltar"),
        done: const Text("Ok"),
        onDone: () {
          // On Done button pressed
          Navigator.of(context).popAndPushNamed('/student');
        },
        onSkip: () {
          // On Skip button pressed
          Navigator.of(context).popAndPushNamed('/student');
        },
        baseBtnStyle: TextButton.styleFrom(
          backgroundColor: Colors.green[100],
        ),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10),
            activeSize: const Size(20, 10),
            activeColor: Theme.of(context).colorScheme.secondary,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25))),
        pages: <PageViewModel>[
          PageViewModel(
              title: "¡Revisa los eventos en curso! 📅",
              image: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "assets/images/studenthome.png",
                ),
              ),
              decoration: const PageDecoration(
                  bodyPadding: EdgeInsets.all(15),
                  imagePadding: EdgeInsets.all(15),
                  bodyTextStyle: TextStyle(fontSize: 20),
                  titleTextStyle: TextStyle(fontSize: 34),
                  pageColor: Color.fromRGBO(250, 252, 251,
                      1) // asi leemos el color que quereoms usar,
                  ),
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        'En esta seccion podras consultar las conferencias disponibles asi como el dia, hora y la ubicacion donde se llevara acabo, ademas de informacion acerca de los ponentes que impartiran la conferencia',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              )),
          PageViewModel(
              title: "¡Consulta tu perfil! 💳",
              image: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "assets/images/perfilpage.png",
                ),
              ),
              decoration: const PageDecoration(
                  bodyPadding: EdgeInsets.all(15),
                  imagePadding: EdgeInsets.all(15),
                  bodyTextStyle: TextStyle(fontSize: 20),
                  titleTextStyle: TextStyle(fontSize: 34),
                  pageColor: Color.fromRGBO(250, 252, 251,
                      1) // asi leemos el color que quereoms usar,
                  ),
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        'En esta seccion podras consultar tu informacion escolar como numero de control, nombre , etc.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              )),
          PageViewModel(
              title: "Sin papeles 📄",
              image: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/images/qrpage.png",
                    ),
                    Image.asset(
                      "assets/images/scannerpage.png",
                    ),
                  ],
                ),
              ),
              decoration: const PageDecoration(
                  bodyPadding: EdgeInsets.all(15),
                  imagePadding: EdgeInsets.all(15),
                  bodyTextStyle: TextStyle(fontSize: 20),
                  titleTextStyle: TextStyle(fontSize: 34),
                  pageColor: Color.fromRGBO(250, 252, 251,
                      1) // asi leemos el color que quereoms usar,
                  ),
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      RichText(
                        text: const TextSpan(children: [
                          TextSpan(
                              text:
                                  'Asiste a los eventos de manera facil y rapida mostrando el codigo de barras en tu credencial escolar o tu QR personal para registrar tu asistencia,',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                          TextSpan(
                              text:
                                  ' el QR es unico por lo que deberas estar registrado en la aplicacion para poder utilizarlo.',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic)),
                          TextSpan(
                              text:
                                  ' Por otro lado, si estas registrado en el semestre actual puedes usar tu credencial escolar vigente para registrar tu entrada',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontStyle: FontStyle.italic)),
                        ]),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  )
                ],
              )),
          PageViewModel(
              title: "¡Que la disfrutes! 😃",
              image: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "assets/images/welcome-amico.png",
                ),
              ),
              decoration: const PageDecoration(
                  bodyPadding: EdgeInsets.all(15),
                  imagePadding: EdgeInsets.all(15),
                  bodyTextStyle: TextStyle(fontSize: 20),
                  titleTextStyle: TextStyle(fontSize: 34),
                  pageColor: Color.fromRGBO(250, 252, 251,
                      1) // asi leemos el color que quereoms usar,
                  ),
              bodyWidget: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: const [
                      Text(
                        'Con esto finalizamos el tutorial para que uses la aplicacion, solo nos queda decir: Disfruta de tus eventos !!!',
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                            fontSize: 16),
                      ),
                    ],
                  )
                ],
              )),
        ],
      ),
    );
  }
}
