import 'package:flutter/material.dart';
import 'package:loop_hr/utils/utils.dart';

class LeaveRequestDialogAndroid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Are you sure you want to cancel request?',
        style: Style.bodyText2,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Yes',
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
}
