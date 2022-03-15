import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_event.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification.dart';
import 'package:loop_hr/models/push_notification.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/error_widget.dart';

import '../models/push_notification_argument.dart';

class NotificationScreen extends StatefulWidget {
  final bool backButtonVisible;
  // final PushNotificationArgument argument;

  const NotificationScreen({this.backButtonVisible = false});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _pageNo = 0;
  final PagingController<int, PushNotification> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<PushNotificationBloc>(context).add(FetchPushNotification(pageKey));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        'Notification',
        centerTitle: true,
        automaticallyImplyLeading: widget.backButtonVisible,
      ),
      body: BlocListener<NotificationInformationBloc, NotificationInformationState>(
        listener: (context, state) {
          if (state is NotificationInformationSuccess) {
            _refreshNotifications();
            SystemUtil.buildSuccessSnackbar(context, state.message);
          } else if (state is NotificationInformationError) {
            SystemUtil.buildErrorSnackbar(context, state.message);
          }
        },
        child: BlocListener<PushNotificationBloc, PushNotificationState>(
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
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () {
                _pageNo = 0;
                _pagingController.refresh();
              },
            ),
            child: PagedListView.separated(
              separatorBuilder: (context, index) => Divider(height: 1, thickness: .5),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<PushNotification>(
                firstPageProgressIndicatorBuilder: (context) => Center(child: ActivityIndicator()),
                newPageProgressIndicatorBuilder: (context) => Center(child: Container()),
                firstPageErrorIndicatorBuilder: (context) {
                  return MLErrorWidget(
                    title: _pagingController.error,
                    onPress: () => _pagingController.refresh(),
                  );
                },
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text('No notifications found'),
                  );
                },
                itemBuilder: (context, item, index) {
                  return _notificationListItem(item);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refreshNotifications() {
    Future.delayed(Duration(milliseconds: 600), () {
      BlocProvider.of<NotificationCounterBloc>(context).add(FetchNotificationCounter());
      _pageNo = 0;
      _pagingController.refresh();
    });
  }

  Widget _notificationListItem(PushNotification notification) {
    return Container(
      padding: EdgeInsets.only(
        top: 12.0,
        bottom: 12,
      ),
      child: ListTile(
        dense: true,
        onTap: () {
          // Navigator.pushNamed(context, notificationDetailScreenRoute, arguments: notification);
          Navigator.pushNamed(
            context,
            notificationDetailScreenRoute,
            arguments: new PushNotificationArgument(notification, notificationsScreenRoute),
          );
        },
        leading: Image.asset(
          notification.isOD ? iconOD : iconLeave,
          height: 40,
          width: 40,
        ),
        title: !notification.isActionable
            ? null
            : Text(
                notification.senderName,
                style: Style.bodyText1.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
                textScaleFactor: 1.0,
              ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 4),
          child: Text(
            notification.body,
            style: Style.bodyText2.copyWith(color: Colors.black54),
            textScaleFactor: 1.0,
            maxLines: 2,
          ),
        ),
      ),
    );
  }
}
