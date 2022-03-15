import 'package:flutter/material.dart';
import 'package:loop_hr/screens/all_absence_list_screen.dart';
import 'package:loop_hr/screens/approved_absence_list_screen.dart';
import 'package:loop_hr/screens/pending_absence_list_screen.dart';
import 'package:loop_hr/utils/constants.dart';
import 'package:loop_hr/utils/icon_util.dart';
import 'package:loop_hr/utils/style.dart';

class AbsenceScreen extends StatefulWidget {
  AbsenceScreen({Key? key}) : super(key: key);

  @override
  _AbsenceScreenState createState() => _AbsenceScreenState();
}

class _AbsenceScreenState extends State<AbsenceScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  static const List<Widget> tab = <Widget>[
    AllAbsenceListScreen(),
    ApprovedAbsenceListScreen(),
    PendingAbsenceListScreen(),
  ];

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
