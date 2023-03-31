import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../providers/professor_provider.dart';

class FloatingActionButtonWidget extends StatefulWidget {
  List<SpeedDialChild?> options = <SpeedDialChild?>[];
  FloatingActionButtonWidget(
      {super.key, required List<SpeedDialChild?> options});

  @override
  State<FloatingActionButtonWidget> createState() =>
      _FloatingActionButtonWidgetState();
}

class _FloatingActionButtonWidgetState
    extends State<FloatingActionButtonWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String _text = '';
    return SpeedDial(
      speedDialChildren: <SpeedDialChild>[
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
