import 'package:flutter/material.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.sentiment_neutral_rounded,
              size: 40,
              color: Colors.green[300],
            ),
            Text(
              '404 ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 40, color: Colors.green[300]),
            ),
            Text(
              'Recurso no encontrado ',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.green[300]),
            ),
          ],
        ),
      ),
    );
  }
}
