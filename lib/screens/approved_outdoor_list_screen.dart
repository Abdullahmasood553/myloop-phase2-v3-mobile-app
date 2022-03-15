import 'package:flutter/material.dart';
import 'package:loop_hr/screens/outdoor_duty_list_screen.dart';


class ApprovedOutDoorListScreen extends StatelessWidget {
  const ApprovedOutDoorListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutdoorDutyListScreen(status: 2);
  }
}
