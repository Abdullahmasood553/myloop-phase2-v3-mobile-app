import 'package:flutter/material.dart';
import 'package:loop_hr/screens/all_outdoor_list_screen.dart';
import 'package:loop_hr/screens/approved_outdoor_list_screen.dart';
import 'package:loop_hr/screens/pending_outdoor_list_screen.dart';
import 'package:loop_hr/utils/style.dart';

import '../utils/constants.dart';
import '../utils/icon_util.dart';

class OutDoorScreen extends StatefulWidget {
  OutDoorScreen({Key? key}) : super(key: key);

  @override
  _OutDoorScreenState createState() => _OutDoorScreenState();
}

class _OutDoorScreenState extends State<OutDoorScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  static const List<Widget> tab = <Widget>[AllOutDoorListScreen(), ApprovedOutDoorListScreen(), PendingOutDoorListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: tab[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Style.kBottomNavigationColor,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _currentIndex,
        selectedItemColor: Style.logoColor,
        selectedLabelStyle: Style.bodyText2.copyWith(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              iconAll,
              width: bottomNavigationDrawerIconSizeWidth,
              height: bottomNavigationDrawerIconSizeHeight,
            ),
            label: 'All',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              iconApproved,
              width: bottomNavigationDrawerIconSizeWidth,
              height: bottomNavigationDrawerIconSizeHeight,
            ),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              iconPending,
              width: bottomNavigationDrawerIconSizeWidth,
              height: bottomNavigationDrawerIconSizeHeight,
            ),
            label: 'Pending',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
