import 'package:flutter/material.dart';
import 'package:loop_hr/screens/outdoor_duty_list_screen.dart';

class PendingOutDoorListScreen extends StatelessWidget {
  const PendingOutDoorListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutdoorDutyListScreen(status: 3);
  }
}