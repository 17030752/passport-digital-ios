// ignore_for_file: file_names, unused_import

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passport_digital_itc/services/firebase_auth_methods.dart';
import 'package:provider/provider.dart';

class BottomNavbarPWidget extends StatefulWidget {
  String role = '';
  BottomNavbarPWidget({super.key, required String role});

  @override
  State<BottomNavbarPWidget> createState() => _BottomNavbarPWidgetState();
}

class _BottomNavbarPWidgetState extends State<BottomNavbarPWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 1;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomNavigationBar(
      scaleFactor: 0.0001,
      iconSize: 30.0,
      selectedColor: const Color(0xFF398E53),
      strokeColor: const Color(0xFFC8E6C9),
      unSelectedColor: const Color(0xffacacac),
      backgroundColor: Colors.white,
      items: <CustomNavigationBarItem>[
        CustomNavigationBarItem(
          icon: const Icon(CupertinoIcons.person_alt),
          title: const Text("Perfil"),
        ),
        CustomNavigationBarItem(
          icon: const Icon(CupertinoIcons.calendar_today),
          title: const Text("Conferencias"),
        ),
        CustomNavigationBarItem(
          icon: const Icon(CupertinoIcons.chevron_left_square_fill),
          title: const Text("Salir"),
        ),
      ],
      currentIndex: _currentIndex,
      onTap: (index) {
        if (_currentIndex != index) {
          setState(() {
            _currentIndex = index;
          });
          switch (_currentIndex) {
            case 0:
              _currentIndex++;
              _nextIsDontSame('/profile');
              break;
            case 1:
              /* Navigator.of(context).canPop()
                  ? Navigator.of(context).popAndPushNamed('/professors')
                  : */
              //Navigator.of(context).pushNamed('/professors');
              //Navigator.of(context).pushReplacementNamed('/home');
              _nextIsDontSame(widget.role);
              break;
            default:
              Future.delayed(const Duration(milliseconds: 800), () {
                context.read<FirebaseAuthMethods>().signOut(context);
              });
          }
        }
      },
    );
  }

  _nextIsDontSame(String newRouteName) {
    bool isNewRouteSameAsCurrent = false;

    Navigator.popUntil(context, (route) {
      if (route.settings.name == newRouteName) {
        isNewRouteSameAsCurrent = true;
      }
      return true;
    });

    if (!isNewRouteSameAsCurrent) {
      Navigator.pushNamed(context, newRouteName);
    }
  }
}
