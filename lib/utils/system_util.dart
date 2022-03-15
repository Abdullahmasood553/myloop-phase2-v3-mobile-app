import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/dismiss_absence_form_dialog.dart';

class SystemUtil {
  static void buildSnackbar(BuildContext context, String title, {Color? color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          textScaleFactor: 1,
        ),
        backgroundColor: color,
      ),
    );
  }

  static void buildSuccessSnackbar(BuildContext context, String title) {
    buildSnackbar(context, title, color: Style.primaryColor);
  }

  static void buildErrorSnackbar(BuildContext context, String title) {
    buildSnackbar(context, title, color: Colors.red);
  }

  static hideKeyboard() {
    SystemChannels.textInput.invokeMethod("TextInput.hide");
  }

  static Future<bool> showFormDismissDialog(BuildContext context) async {
    final bool? result;
    if (Platform.isIOS) {
      result = await showCupertinoDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DismissAbsenceFormDialog(),
      );
    } else {
      result = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => DismissAbsenceFormDialog(),
      );
    }
    return result!;
  }
}
