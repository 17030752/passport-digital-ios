import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:passport_digital_itc/data/dbHelper.dart';
import 'package:passport_digital_itc/models/user_conference_model.dart';
import 'package:quickalert/quickalert.dart';

class ProfessorProvider extends ChangeNotifier {
  String _scanBarCode = 'unknown';
  String get scanBarCode => _scanBarCode;

  Future<void> scanQR(dynamic isMounted, dynamic context) async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#FC7300', 'Cancelar', true, ScanMode.QR);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    _scanBarCode = barcodeScanRes;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!isMounted) {
      notifyListeners();
    } else {
      notifyListeners();
      if (_scanBarCode != 'unknown' &&
          _scanBarCode.contains('user') &&
          !_scanBarCode.contains('null')) {
        DBHelper.registerAttendance(_scanBarCode).then((_) {
          return QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              text: 'Registro completado satisfactoriamente!',
              confirmBtnText: 'Continuar');
        }, onError: (error) {
          return QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Algo salio mal registrando datos...',
              text: '$error',
              confirmBtnColor: Colors.red[900]!,
              confirmBtnText: 'Salir');
        });
      } else {
        return QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'No lo veo bien...',
            text:
                'Recuerda estar en un lugar con buena iluminación,angulo frontal a la camara y de preferencia tener en buen estado tu credencial para usar este metodo',
            confirmBtnColor: Colors.red[900]!,
            confirmBtnText: 'Salir');
      }
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal(
      dynamic isMounted, dynamic context, dynamic idConference) async {
    //print('esta montado? $isMounted');
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#FC7300', 'Cancelar', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    _scanBarCode = barcodeScanRes;
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!isMounted) {
      notifyListeners();
    } else {
      notifyListeners();

      await DBHelper.getOneUser(_scanBarCode.trim(), "no_control").then(
          (response) {
        if (response.isNotEmpty) {
          final attendance = UserConferences(
              userId: response['id'], conferenceId: idConference);
          final json = jsonEncode(attendance.toJson());
          DBHelper.registerAttendance(json).then((_) {
            return QuickAlert.show(
                context: context,
                type: QuickAlertType.success,
                title: 'Registro completado !',
                text: 'Alumno: ${response['name']}',
                confirmBtnText: 'Continuar');
          }, onError: (error) {
            return QuickAlert.show(
                context: context,
                type: QuickAlertType.error,
                title: 'Algo salio mal registrando datos...',
                text: '$error',
                confirmBtnColor: Colors.red[900]!,
                confirmBtnText: 'Salir');
          });
        } else {
          return QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'No lo veo bien...',
              text:
                  'Recuerda estar en un lugar con buena iluminación,angulo frontal a la camara y de preferencia tener en buen estado tu credencial para usar este metodo',
              confirmBtnColor: Colors.red[900]!,
              confirmBtnText: 'Salir');
        }
      }, onError: (error) {
        return QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Algo salio mal obteniendo datos...',
            text: 'Error: $error',
            confirmBtnColor: Colors.red[900]!,
            confirmBtnText: 'Salir');
      });
    }
  }

  Future<void> digitBarcode(
      String text, dynamic context, dynamic idConference) async {
    _scanBarCode = text;
    notifyListeners();
    await DBHelper.getOneUser(_scanBarCode.trim(), "no_control").then(
        (response) {
      if (response.isNotEmpty) {
        final attendance =
            UserConferences(userId: response['id'], conferenceId: idConference);
        final json = jsonEncode(attendance.toJson());
        DBHelper.registerAttendance(json).then((_) {
          return QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
              title: 'Registro completado !',
              text: 'Alumno: ${response['name']}',
              confirmBtnText: 'Continuar');
        }, onError: (error) {
          return QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Algo salio mal registrando datos...',
              text: '$error',
              confirmBtnColor: Colors.red[900]!,
              confirmBtnText: 'Salir');
        });
      } else {
        return QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'No lo encuentro...',
            text:
                'El numero de control proporcionado no corresponde a ningun alumno, digita nuevamente el numero o revisa si esta escrito correctamente',
            confirmBtnColor: Colors.red[900]!,
            confirmBtnText: 'Salir');
      }
    }, onError: (error) {
      return QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Algo salio mal obteniendo datos...',
          text: 'Error: $error',
          confirmBtnColor: Colors.red[900]!,
          confirmBtnText: 'Salir');
    });
  }
}
