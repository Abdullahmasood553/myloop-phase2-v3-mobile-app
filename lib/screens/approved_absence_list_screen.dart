import 'package:flutter/material.dart';
import 'package:loop_hr/screens/absence_list_screen.dart';

class ApprovedAbsenceListScreen extends StatelessWidget {
  const ApprovedAbsenceListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AbsenceListScreen(status: 2);
  }
}
