import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_event.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_state.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/screens/dashboard_screen.dart';
import 'package:loop_hr/screens/notification_screen.dart';
import 'package:loop_hr/screens/profile_screen.dart';
import 'package:loop_hr/utils/constants.dart';
import 'package:loop_hr/utils/utils.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  int index = 0;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<bool> _onWillPop() async {
    if (_currentIndex == 0) {
      return true;
    } else {
      setState(() {
      _currentIndex = 0;
      });
    }
    return false;
  }

  Future<void> _initNotifications() async {
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        if (message != null) {
          var _user = RepositoryProvider.of<LoginRepository>(context).getLoggedInUser;
          if (_user != null) {
            Navigator.pushNamed(context, notificationsScreenRoute, arguments: true).then((value) {
              BlocProvider.of<NotificationCounterBloc>(context).add(
                FetchNotificationCounter(forceRefresh: true),
              );
            });
          } else {
            Navigator.pushNamed(context, loginScreenRoute);
          }
        }
      },
    );

    // Foreground Messaging
    FirebaseMessaging.onMessage.listen(
      (message) {
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
        }
        BlocProvider.of<NotificationCounterBloc>(context).add(
          FetchNotificationCounter(forceRefresh: true),
        );
      },
    );

    // When the app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var _user = RepositoryProvider.of<LoginRepository>(context).getLoggedInUser;
      if (_user != null) {
        Navigator.pushNamed(context, notificationsScreenRoute, arguments: true).then((value) {
          BlocProvider.of<NotificationCounterBloc>(context).add(
            FetchNotificationCounter(forceRefresh: true),
          );
        });
      } else {
        Navigator.pushNamed(context, loginScreenRoute);
      }
    });
  }

  final tab = [DashboardScreen(), ProfileScreen(), NotificationScreen()];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white60,
        body: tab[_currentIndex],
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                iconHomeActive,
                height: bottomNavigationDrawerIconSizeWidth,
                width: bottomNavigationDrawerIconSizeHeight,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                RepositoryProvider.of<LoginRepository>(context).getLoggedInUser?.gender == 'F' ? iconFemaleProfileActive : iconMaleProfileActive,
                height: bottomNavigationDrawerIconSizeWidth,
                width: bottomNavigationDrawerIconSizeWidth,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: <Widget>[
                  Image.asset(
                    iconNotificationActive,
                    height: bottomNavigationDrawerIconSizeWidth,
                    width: bottomNavigationDrawerIconSizeWidth,
                  ),
                  BlocBuilder<NotificationCounterBloc, NotificationCounterLoaded>(
                    builder: (context, state) {
                      if (state.counter > 0) {
                        return Positioned(
                          right: 0,
                          top: 0,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              state.counter.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  )
                ],
              ),
              label: 'Notifications',
            )
          ],
          onTap: (index) {
            setState(
              () {
                _currentIndex = index;

              },
            );
          },
        ),
      ),
    );
  }
}
