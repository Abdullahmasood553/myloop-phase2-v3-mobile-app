import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/push_notification_argument.dart';
import 'package:loop_hr/utils/style.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/request_info_dialog.dart';
import 'package:loop_hr/widgets/reject_reason_dialog.dart';
import '../models/push_notification_comments.dart';
import '../utils/read_more.dart';
import '../utils/system_util.dart';
import '../widgets/activity_indicator.dart';

class PushNotificationDetailScreen extends StatefulWidget {
  final PushNotificationArgument argument;

  late final PushNotification pushNotification;
  late final String? previousRoute;

  PushNotificationDetailScreen({required this.argument}) {
    this.pushNotification = argument.pushNotification;
    this.previousRoute = argument.previousRoute;
  }

  @override
  State<PushNotificationDetailScreen> createState() => _PushNotificationDetailScreenState();
}

class _PushNotificationDetailScreenState extends State<PushNotificationDetailScreen> {
  // @override
  // void initState() {
  //   BlocProvider.of<PushNotificationBloc>(context).add(FetchPushNotificationComments(widget.argument.pushNotification.itemKey));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        'Notification Detail',
        centerTitle: true,
      ),
      body: LoaderOverlay(
        overlayWidget: ActivityIndicator(),
        child: BlocListener<NotificationInformationBloc, NotificationInformationState>(
          listener: (context, state) {
            if (state is NotificationInformationSuccess) {
              context.loaderOverlay.hide();
              Navigator.pop(context);
            } else if (state is NotificationInformationError) {
              context.loaderOverlay.hide();
              SystemUtil.buildErrorSnackbar(context, state.message);
            }
          },
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildPushNotificationListItem('Name', widget.pushNotification.senderName),
                _buildPushNotificationListItem('Description', widget.pushNotification.body),
                _buildPushNotificationListItem('Leave Type', widget.pushNotification.typeName),
                _buildPushNotificationListItem('Date Start', widget.pushNotification.formattedDateStart()),
                _buildPushNotificationListItem('Date End', widget.pushNotification.formattedDateEnd()),
                _buildOutDoorWidget(),
                _buildPushNotificationListItem('Comments', this.widget.pushNotification.comments),
                _buildTADAWidget(),
                if (widget.pushNotification.getReason != null)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPushNotificationListItem(
                        'Reason of rejection',
                        this.widget.pushNotification.getReason!,
                      ),
                    ],
                  ),
                Row(
                  children: [
                    Expanded(
                      child: BuildNotificationCommentList(
                        pushNotificationComments: widget.argument.pushNotification.notificationComments,
                        argument: widget.argument,
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                Column(
                  children: [
                    Row(
                      children: [
                        if (!widget.pushNotification.isActionPerformed && widget.pushNotification.isActionable)
                          Expanded(
                            child: _buildRequestInformationButton(context, 'Request Info.'),
                          ),
                        SizedBox(width: 16),
                        if (!widget.pushNotification.isActionPerformed && widget.pushNotification.isActionable)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Style.dangerColor,
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              ),
                              onPressed: () async {
                                String? result = await showDialog(
                                  context: context,
                                  builder: (_) {
                                    return TextDialog();
                                  },
                                );
                                if (result != null) {
                                  Map<String, dynamic> _requestBody = {
                                    'oidAction': 2,
                                    'oidNotification': widget.pushNotification.oid,
                                    'comment': result,
                                  };
                                  BlocProvider.of<NotificationInformationBloc>(context).add(CreateApproveRejectNotification(_requestBody));
                                  Navigator.pop(context);
                                }
                              },
                              child: Text(
                                'Reject',
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ),
                        if (!widget.pushNotification.isActionPerformed && widget.pushNotification.isActionable)
                          SizedBox(
                            width: widget.pushNotification.isActionable ? 0 : 16,
                          ),
                      ],
                    ),
                    Row(
                      children: [
                        if (!widget.pushNotification.isActionPerformed && widget.pushNotification.isActionable)
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Style.successColor,
                                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                              ),
                              onPressed: () {
                                Map<String, dynamic> _requestBody = {
                                  'oidAction': 1,
                                  'oidNotification': widget.pushNotification.oid,
                                };
                                BlocProvider.of<NotificationInformationBloc>(context).add(CreateApproveRejectNotification(_requestBody));
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Approve',
                              ),
                            ),
                          ),
                        if (!widget.pushNotification.isActionable && widget.pushNotification.isFYI)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                BlocProvider.of<NotificationInformationBloc>(context).add(DismissNotification(widget.pushNotification.oid));
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Dismiss',
                                textScaleFactor: 1.0,
                              ),
                            ),
                          ),
                        if (widget.pushNotification.isQuestion) Expanded(child: _buildRequestInformationButton(context, 'Submit Response')),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOutDoorWidget() {
    if (widget.pushNotification.isOD) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPushNotificationListItem('Time Start', this.widget.pushNotification.timeStart!),
          _buildPushNotificationListItem('Time End', this.widget.pushNotification.timeEnd!),
          if (widget.pushNotification.fromCity != null) _buildPushNotificationListItem('From City', this.widget.pushNotification.fromCity!),
          if (widget.pushNotification.toCity != null) _buildPushNotificationListItem('To City', this.widget.pushNotification.toCity!),
        ],
      );
    }
    return SizedBox();
  }

  Widget _buildTADAWidget() {
    if (widget.pushNotification.isOD) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.pushNotification.reimbursementType != null) _buildPushNotificationListItem('Reimbursement Type', this.widget.pushNotification.reimbursementType!),
          if (widget.pushNotification.claimType != null) _buildPushNotificationListItem('Claim Type', this.widget.pushNotification.claimType!),
          if (widget.pushNotification.taxiCharges != null) _buildPushNotificationListItem('Taxi Charges', this.widget.pushNotification.taxiCharges!),
          if (widget.pushNotification.travellingAmount != null) _buildPushNotificationListItem('Travelling Amount', this.widget.pushNotification.travellingAmount!),
          if (widget.pushNotification.nightStayArrangement != null) _buildPushNotificationListItem('Nightstay Arrangement', this.widget.pushNotification.nightStayArrangement!),
          if (widget.pushNotification.diningAmount != null) _buildPushNotificationListItem('Dining Amount', this.widget.pushNotification.diningAmount!),
        ],
      );
    }
    return SizedBox();
  }

  Widget _buildPushNotificationListItem(String key, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          key,
          textScaleFactor: 1.0,
          textAlign: TextAlign.left,
          style: Style.bodyText1.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          value,
          textScaleFactor: 1.0,
        ),
        Divider(height: 20, thickness: .5),
      ],
    );
  }

  Widget _buildRequestInformationButton(BuildContext context, String title) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            ),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (_) {
                  return RequestInfoDialog(pushNotification: widget.argument.pushNotification);
                },
              );
            },
            child: Text(
              title,
              textScaleFactor: 1.0,
            ),
          ),
        ),
      ],
    );
  }
}

class BuildNotificationCommentList extends StatelessWidget {
  final List<NotificationComments> pushNotificationComments;
  final PushNotificationArgument argument;

  const BuildNotificationCommentList({Key? key, required this.pushNotificationComments, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: argument.pushNotification.notificationComments.length,
      itemBuilder: (BuildContext context, index) {
        if (pushNotificationComments[index].userComment != null)
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Color.fromARGB(255, 68, 55, 55),
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReadMore.readMore(pushNotificationComments[index].fromUser),
                    SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 11,
                                    child: Text(
                                      pushNotificationComments[index].formattedCommentDate(),
                                      textScaleFactor: 1.0,
                                      style: Style.bodyText2.copyWith(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(color: Colors.grey),
                        ReadMore.readMore(
                          pushNotificationComments[index].userComment.toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        return SizedBox();
      },
    );
  }
}
