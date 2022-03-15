import 'package:flutter/material.dart';

import '../utils/utils.dart';

class NotificationContainer extends StatelessWidget {
  final Widget child;
  const NotificationContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      margin: EdgeInsets.only(left: 16),
      padding: EdgeInsets.all(10),
      decoration: boxDecoration(
        radius: 8,
        spreadRadius: 0,
        blurRadius: 0,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF46A6E1).withOpacity(.5),
            Color(0xFF46A6E1),
            Color(0xFF2C72AE),
          ],
        ),
      ),
      child: this.child,
    );
  }
}
