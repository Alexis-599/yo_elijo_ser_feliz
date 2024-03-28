import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAdaptiveAlertDialog extends StatelessWidget {
  const CustomAdaptiveAlertDialog(
      {super.key,
      required this.alertMsg,
      required this.actiionBtnName,
      required this.onAction,
      this.actionBtnColor,
      this.title});
  final String alertMsg;
  final String actiionBtnName;
  final VoidCallback onAction;
  final Color? actionBtnColor;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      return AlertDialog(
        title: Text(title ?? 'Alerta'),
        content: Text(alertMsg),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onAction,
            child: Text(
              actiionBtnName,
              style: TextStyle(color: actionBtnColor ?? Colors.red.shade700),
            ),
          ),
        ],
      );
    } else {
      return CupertinoAlertDialog(
        title: Text(title ?? 'Alerta'),
        content: Text(alertMsg),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            onPressed: onAction,
            child: Text(
              actiionBtnName,
              style: TextStyle(color: actionBtnColor ?? Colors.red.shade700),
            ),
          ),
        ],
      );
    }
  }
}
