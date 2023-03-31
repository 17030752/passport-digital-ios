import 'package:flutter/material.dart';

class CustomTextFormfield extends StatefulWidget {
  TextEditingController textController;
  String? labelText;
  Color? fillColor;
  BorderRadius? borderRadius;
  String onChanged;
  CustomTextFormfield(
      {super.key,
      required this.textController,
      required this.labelText,
      required this.fillColor,
      required this.borderRadius,
      required this.onChanged});

  @override
  State<CustomTextFormfield> createState() => _CustomTextFormfieldState();
}

class _CustomTextFormfieldState extends State<CustomTextFormfield> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final string = widget.onChanged;
    return TextFormField(
      onChanged: (string) {
        debugPrint('string: ${string}');
      },
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor introducir un texto..';
        }
        return null;
      },
      controller: widget.textController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_search_rounded),
        labelText: widget.labelText,
        filled: true,
        fillColor: widget.fillColor,
        counterStyle: TextStyle(color: Colors.green[300]),
        floatingLabelStyle: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.onSecondary,
            backgroundColor: Theme.of(context).colorScheme.secondary),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.primary),
          // borderRadius: widget.borderRadius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1, color: Theme.of(context).colorScheme.secondary),
          // borderRadius: widget.borderRadius
        ),
        errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red)),
        errorStyle: const TextStyle(
          color: Colors.red,
        ),
      ),
    );
  }
}
