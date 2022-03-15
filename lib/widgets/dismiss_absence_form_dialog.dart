import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop_hr/utils/style.dart';

class DismissAbsenceFormDialog extends StatelessWidget {
  const DismissAbsenceFormDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: _titleWidget(),
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Yes',
              textScaleFactor: 1,
              style: Style.bodyText2.copyWith(color: Colors.red),
            ),
            isDefaultAction: true,
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
          CupertinoDialogAction(
            child: Text(
              'No',
              textScaleFactor: 1,
              style: Style.bodyText2.copyWith(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
        ],
      );
    }
    return AlertDialog(
      title: _titleWidget(),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Yes',
            textScaleFactor: 1,
            style: Style.bodyText2.copyWith(color: Colors.red),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        TextButton(
          child: Text(
            'No',
            style: Style.bodyText2.copyWith(color: Colors.black),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
        )
      ],
    );
  }

  Text _titleWidget() {
    return Text(
      'Are you sure to dismiss?',
      textScaleFactor: 1,
      style: Style.bodyText1,
    );
  }
}
