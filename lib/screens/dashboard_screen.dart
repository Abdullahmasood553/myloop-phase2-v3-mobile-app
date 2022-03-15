import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loop_hr/blocs/headline-notification-bloc/headline_notification_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_event.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_state.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/notification_counter.dart';
import 'package:loop_hr/models/push_notification_argument.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/screens/create_leave_screen.dart';
import 'package:loop_hr/screens/create_outdoor_screen.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/notification_container.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  int _pageNo = 0;
  NotificationCounter? notificationCounter;

  final PagingController<int, PushNotification> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    RepositoryProvider.of<LoginRepository>(context).refreshUser();

    BlocProvider.of<NotificationCounterBloc>(context).add(FetchNotificationCounter());

    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<HeadlineNotificationBloc>(context).add(FetchPushNotification(pageKey));
      },
    );
  }

  void _refreshNotificationsAndCounter() {
    Future.delayed(Duration(milliseconds: 400), () {
      BlocProvider.of<NotificationCounterBloc>(context).add(FetchNotificationCounter());
      _refreshNotification();
    });
  }

  void _refreshNotification() {
    _pageNo = 0;
    _pagingController.refresh();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshNotificationsAndCounter();
      RepositoryProvider.of<LoginRepository>(context).refreshUser();
      BlocProvider.of<NotificationCounterBloc>(context).add(FetchNotificationCounter());
    }
  }

  Widget _buildAbsenceButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Image.asset(
          iconAdd,
          height: 30,
          width: 30,
        ),
        onPressed: () {
          _createAbsenceModalBottomSheet(context);
        },
        padding: EdgeInsets.zero,
      );
    }
    return IconButton(
      icon: Image.asset(
        iconAdd,
        height: 30,
        width: 30,
      ),
      onPressed: () {
        _createAbsenceModalBottomSheet(context);
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdaptiveAppBar(
        appSplashIcon,
        'loophr',
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          _buildAbsenceButton(),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            child: SvgPicture.asset(
              leaveScreenSvgIcon,
              semanticsLabel: 'dashboard',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.fill,
            ),
          ),
          BlocListener<NotificationInformationBloc, NotificationInformationState>(
            listener: (context, state) {
              if (state is NotificationInformationSuccess) {
                _refreshNotificationsAndCounter();
                SystemUtil.buildSuccessSnackbar(context, state.message);
              }
            },
            child: ListView(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              children: <Widget>[
                Container(
                  height: 180, // notification card height
                  child: BlocListener<HeadlineNotificationBloc, PushNotificationState>(
                    listener: (context, state) {
                      if (state is PushNotificationLoaded) {
                        if (state.isLastPage) {
                          _pagingController.appendLastPage(state.notifications);
                        } else {
                          _pageNo += 1;
                          _pagingController.appendPage(state.notifications, _pageNo);
                        }
                      }
                      if (state is PushNotificationError) {
                        _pagingController.error = state.message;
                      }
                    },
                    child: PagedListView(
                      scrollDirection: Axis.horizontal,
                      pagingController: _pagingController,
                      shrinkWrap: true,
                      padding: EdgeInsets.only(right: 16),
                      builderDelegate: PagedChildBuilderDelegate<PushNotification>(
                        firstPageProgressIndicatorBuilder: (context) {
                          return Row(
                            children: [
                              NotificationLoader(),
                              NotificationLoader(),
                            ],
                          );
                        },
                        newPageProgressIndicatorBuilder: (context) => Center(child: Container()),
                        firstPageErrorIndicatorBuilder: (context) => BuildNoHeadlineNotification(
                          title: _pagingController.error,
                        ),
                        noItemsFoundIndicatorBuilder: (context) {
                          return BuildNoHeadlineNotification();
                        },
                        itemBuilder: (context, item, index) {
                          return _notificationListItem(item);
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Services ',
                    style: Style.headline6,
                    textScaleFactor: 1.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoundedIconButton(
                              context,
                              onTap: () {
                                Navigator.pushNamed(context, attendanceListScreenRoute);
                              },
                              title: 'Attendance',
                              imageName: iconAttendance,
                            ),
                          ),
                          Expanded(
                            child: _buildRoundedIconButton(
                              context,
                              onTap: () async {
                                await Navigator.pushNamed(context, absenceScreenRoute);
                                _refreshNotificationsAndCounter();
                              },
                              title: 'Leave',
                              imageName: iconLeave,
                            ),
                          ),
                          Expanded(
                            child: _buildRoundedIconButton(
                              context,
                              onTap: () async {
                                await Navigator.pushNamed(context, outdoorScreenRoute);
                                _refreshNotificationsAndCounter();
                              },
                              title: 'Outdoor Duty',
                              imageName: iconOD,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRoundedIconButton(
                              context,
                              onTap: () => {Navigator.pushNamed(context, paySlipScreenRoute)},
                              title: 'Payslip',
                              imageName: iconPayslip,
                            ),
                          ),
                          Spacer(),
                          Spacer(),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 16, right: 16),
                  child: Text(
                    'Employee Engagement ',
                    style: Style.headline6,
                    textScaleFactor: 1.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildRoundedIconButton(
                          context,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              surveyListScreenRoute,
                            );
                            // _refreshNotificationsAndCounter();
                          },
                          title: 'Survey',
                          imageName: iconSurvey,
                          isPoll: false,
                        ),
                      ),
                      Expanded(
                        child: _buildRoundedIconButton(
                          context,
                          onTap: () async {
                            await Navigator.pushNamed(
                              context,
                              pollListScreenRoute,
                            );
                            // _refreshNotificationsAndCounter();
                          },
                          title: 'Poll',
                          imageName: iconPoll,
                          isPoll: true,
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _notificationListItem(PushNotification notification) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          notificationDetailScreenRoute,
          arguments: new PushNotificationArgument(notification, homeScreenRoute),
        );
      },
      child: NotificationContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    notification.isOD ? iconOD : iconLeave,
                    height: 50,
                    width: 50,
                  ),
                ),
                Visibility(
                  visible: notification.isActionable,
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        notification.senderName,
                        textScaleFactor: 1.0,
                        style: Style.bodyText2.copyWith(color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Expanded(
              child: Text(
                notification.body,
                textScaleFactor: 1.0,
                style: Style.bodyText2.copyWith(color: Colors.white),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: 8),
            Text(
              timeago.format(notification.notificationDate),
              textScaleFactor: 1.0,
              style: Style.bodyText2.copyWith(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  void _createAbsenceModalBottomSheet(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Image.asset(iconLeave),
                ),
                title: Text(
                  'Create Leave',
                  textScaleFactor: 1.0,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  bool? result = await showBarModalBottomSheet(
                    expand: true,
                    isDismissible: true,
                    context: context,
                    builder: (context) => AbsenceFormScreen(),
                  );
                  if (result != null && result) {
                    Future.delayed(
                      Duration(milliseconds: 400),
                      () {
                        _refreshNotificationsAndCounter();
                      },
                    );
                  }
                },
              ),
              ListTile(
                leading: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.white,
                  child: Image.asset(iconOD),
                ),
                title: Text(
                  'Create Outdoor Duty',
                  textScaleFactor: 1.0,
                ),
                onTap: () async {
                  Navigator.pop(context);
                  bool? result = await showBarModalBottomSheet(
                    expand: true,
                    isDismissible: true,
                    context: context,
                    builder: (context) => OutdoorDutyCreateScreen(),
                  );
                  if (result != null && result) {
                    Future.delayed(
                      Duration(milliseconds: 400),
                      () {
                        _refreshNotificationsAndCounter();
                      },
                    );
                  }
                },
              ),
              SizedBox(height: 20)
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoundedIconButton(BuildContext context, {required String title, required String imageName, required VoidCallback onTap, bool? isPoll}) {
    return Container(
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: onTap,
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                imageName,
                width: 80,
                height: 80,
              ),
              Container(
                // margin: EdgeInsets.only(top: 5),
                child: Text(
                  title,
                  textScaleFactor: 1,
                  style: Style.bodyText2.copyWith(color: Colors.black),
                ),
              ),
            ],
          ),
          Container(
            child: isPoll != null
                ? BlocBuilder<NotificationCounterBloc, NotificationCounterLoaded>(
                    builder: (context, state) {
                      int _counter = 0;
                      if (isPoll) {
                        _counter = state.pollCount;
                      } else {
                        _counter = state.surveyCount;
                      }
                      if (_counter > 0) {
                        return Positioned(
                          right: 8,
                          top: 10,
                          child: new Container(
                            padding: EdgeInsets.all(2),
                            decoration: new BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              _counter.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox();
                      }
                    },
                  )
                : SizedBox(),
          )
        ]),
      ),
    );
  }
}

class NotificationLoader extends StatelessWidget {
  const NotificationLoader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180.0,
      decoration: boxDecoration(
        radius: 8,
        spreadRadius: 0,
        blurRadius: 0,
        gradient: LinearGradient(colors: [Colors.white70, Colors.white70]),
      ),
      margin: EdgeInsets.only(left: 16),
      padding: EdgeInsets.all(10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 2.0),
                      ),
                      Container(
                        width: double.infinity,
                        height: 8.0,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: 40.0,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              width: 60.0,
              height: 8.0,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class BuildNoHeadlineNotification extends StatelessWidget {
  final String? title;

  const BuildNoHeadlineNotification({Key? key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NotificationContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(radius: 30, backgroundColor: Colors.white, child: Image.asset(iconNotification)),
          SizedBox(height: 15),
          Expanded(
            child: Text(
              title ?? 'No new notifications',
              textScaleFactor: 1.0,
              style: Style.bodyText2.copyWith(
                color: Colors.white,
                fontSize: 14,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
