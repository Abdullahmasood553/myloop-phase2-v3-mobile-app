import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/authentication-bloc/authentication.dart';
import 'package:loop_hr/utils/utils.dart';

class LogoutDialog extends StatelessWidget {
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
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
          ),
          CupertinoDialogAction(
            child: Text(
              'No',
              textScaleFactor: 1,
              style: Style.bodyText2.copyWith(color: Colors.black),
            ),
            onPressed: () {
              Navigator.pop(context);
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
            'Log Out',
            textScaleFactor: 1,
            style: Style.bodyText2.copyWith(color: Colors.red),
          ),
          onPressed: () {
            BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            textScaleFactor: 1,
            style: Style.bodyText2.copyWith(color: Colors.black),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }

  Text _titleWidget() {
    return Text(
      'Are you sure you want to log out?',
      style: Style.bodyText1,
      textScaleFactor: 1,
    );
  }
}
