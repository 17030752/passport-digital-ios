// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  final String title;
  const CustomAppBar({required this.title, super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar>
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.title),
    );
  }

  @override
  Element createElement() {
    throw UnimplementedError();
  }

  @override
  List<DiagnosticsNode> debugDescribeChildren() {
    throw UnimplementedError();
  }

  @override
  Key? get key => throw UnimplementedError();

  @override
  String toStringDeep(
      {String prefixLineOne = '',
      String? prefixOtherLines,
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    throw UnimplementedError();
  }

  @override
  String toStringShallow(
      {String joiner = ', ',
      DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    throw UnimplementedError();
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
