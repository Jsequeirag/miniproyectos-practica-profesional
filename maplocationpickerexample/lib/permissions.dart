import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class Permissions {
  Future<bool> checkPermission(
      Permission permission, BuildContext context) async {
    var status = await permission.status;

    if (status.isGranted) return true;
    print(
        "Numero de permiso " + permission.value.toString() + " " + status.name);
    if (status.isPermanentlyDenied || status.isDenied) {
      var permissionName = "";
      switch (permission.value) {
        case 1:
          permissionName = "Camara";
          break;
        case 3:
          permissionName = "Localización";
          break;
        default:
      }
      //await permission.request();
      await showAlertDialog(context, permissionName);
      return false;
      //1==> camera 3==> location
    } else {
      print("Acceso no denegado");
      var requestStatus = await permission.request();
      if (requestStatus.isGranted) return true;
      return false;
    }
    /* if (status == true) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Permission is grated")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Permission is not grated")));
    }*/
  }

  showAlertDialog(context, permissionName) => showCupertinoDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('Permiso denegado'),
          content: Text('Permita el acceso a $permissionName'),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                await openAppSettings();
                Navigator.of(context).pop();
              },
              child: const Text('Configuración'),
            ),
          ],
        ),
      );
}
