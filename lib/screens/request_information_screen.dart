import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information_bloc.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information_event.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information_state.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/push_notification_comments.dart';
import 'package:loop_hr/models/push_notification_participants.dart';
import 'package:loop_hr/repositories/push_notification_repository.dart';
import 'package:loop_hr/utils/constants.dart';
import 'package:loop_hr/utils/read_more.dart';

import '../models/push_notification_argument.dart';
import '../utils/style.dart';
import '../utils/system_util.dart';
import '../widgets/activity_indicator.dart';
import '../widgets/adaptive_appbar.dart';

class RequestInformationScreen extends StatefulWidget {
  final PushNotificationArgument argument;
  late final String? previousRoute;

  RequestInformationScreen({required this.argument}) {
    this.previousRoute = argument.previousRoute;
  }

  @override
  _RequestInformationScreenState createState() => _RequestInformationScreenState();
}

class _RequestInformationScreenState extends State<RequestInformationScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _requestBody = {};

  @override
  void initState() {
    BlocProvider.of<PushNotificationBloc>(context).add(FetchPushNotificationComments(widget.argument.pushNotification.itemKey));
    super.initState();
  }

  void validate() async {
    if (_formKey.currentState!.validate()) {
      _requestBody['oidNotification'] = widget.argument.pushNotification.oid.toString();
      if (!widget.argument.pushNotification.isQuestion) {
        _requestBody['action'] = QUESTION;
      } else {
        _requestBody['action'] = ANSWER;
        _requestBody['moreInfoRole'] = null;
      }
      _formKey.currentState!.save();
      context.loaderOverlay.show();

      BlocProvider.of<NotificationInformationBloc>(context).add(CreateInformationRequest(_requestBody, widget.argument.pushNotification.itemKey));
    } else {
      print("Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemUtil.hideKeyboard();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AdaptiveAppBar(
          null,
          'More Information Request',
          centerTitle: true,
        ),
        body: LoaderOverlay(
          overlayWidget: ActivityIndicator(),
          child: BlocListener<NotificationInformationBloc, NotificationInformationState>(
            listener: (context, state) {
              if (state is NotificationInformationSuccess) {
                context.loaderOverlay.hide();
                SystemUtil.buildSuccessSnackbar(
                  context,
                  state.message,
                );
                // int count = 0;
                // Navigator.popUntil(context, (route) {
                //   return count++ == 2;
                // });
              } else if (state is NotificationInformationSuccess) {
                context.loaderOverlay.hide();
                SystemUtil.buildErrorSnackbar(
                  context,
                  state.message,
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Visibility(
                    visible: !widget.argument.pushNotification.isQuestion,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16),
                      child: ParticipantDropdown(
                        pushNotification: widget.argument.pushNotification,
                        onChanged: (value) {
                          _requestBody['moreInfoRole'] = value != null ? value.recipientRole : null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: BlocBuilder<PushNotificationBloc, PushNotificationState>(
                      builder: (context, state) {
                        if (state is PushNotificationLoaded) {
                          if (state.notifications.isEmpty) {
                            return Center(
                              child: Text('Comments not found'),
                            );
                          }
                          return BuildNotificationCommentList(
                            pushNotificationComments: widget.argument.pushNotification.notificationComments,
                            argument: widget.argument,
                          );
                        }
                        if (state is PushNotificationError) {
                          return Center(
                            child: Text(state.message),
                          );
                        }
                        return Center(child: ActivityIndicator());
                      },
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(
                      maxHeight: 200,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            validator: (value) {
                              if (value!.isEmpty) {
                                SystemUtil.buildSuccessSnackbar(
                                  context,
                                  "Comment's is required",
                                );
                                return '';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (String? value) {
                              _requestBody['comment'] = value?.trim();
                            },
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                              hintText: "Type Message...",
                              contentPadding: EdgeInsets.all(16.0),
                              hintStyle: TextStyle(
                                color: Style.primaryColor,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Style.primaryColor,
                          ),
                          onPressed: () {
                            validate();

                            // int count = 0;
                            // Navigator.popUntil(context, (route) {
                            //   return count++ == 2;
                            // });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ParticipantDropdown extends StatefulWidget {
  final PushNotification pushNotification;
  final ValueChanged<PushNotificationParticipants?> onChanged;

  ParticipantDropdown({Key? key, required this.pushNotification, required this.onChanged}) : super(key: key);

  @override
  State<ParticipantDropdown> createState() => _ParticipantDropdownState();
}

class _ParticipantDropdownState extends State<ParticipantDropdown> {
  List<PushNotificationParticipants> _notificationParticipants = List.empty(growable: true);

  PushNotificationParticipants? _selectedParticipant;

  @override
  void initState() {
    super.initState();
    loadMasterData();
  }

  Future<void> loadMasterData() async {
    _notificationParticipants = await context.read<PushNotificationRepository>().findAllNotificationParticipants(
          widget.pushNotification,
        );
    if (_notificationParticipants.isNotEmpty) {
      setState(() {
        _selectedParticipant = _notificationParticipants.first;
        widget.onChanged(_selectedParticipant);
        // _selectedParticipant = _notificationParticipants.firstWhere((p) => p.fullName == widget.pushNotification.senderName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<PushNotificationParticipants>(
      mode: Mode.BOTTOM_SHEET,
      showSelectedItems: true,
      selectedItem: _selectedParticipant,
      itemAsString: (item) => item!.lastName,
      compareFn: (item, selectedItem) => item?.lastName == selectedItem?.lastName,
      validator: (value) => value == null ? 'Leave type is required' : null,
      dropdownSearchDecoration: InputDecoration(
        labelText: "Notification Participants",
      ),
      items: _notificationParticipants,
      onChanged: (value) {
        widget.onChanged(value);
        setState(() {
          _selectedParticipant = value;
        });
      },
      showAsSuffixIcons: true,
      dropdownButtonBuilder: (_) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: const Icon(
          Icons.arrow_downward,
          color: Colors.black54,
          size: 20,
        ),
      ),
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
      itemCount: pushNotificationComments.length,
      itemBuilder: (BuildContext context, index) {
        NotificationComments _pushNotificationComments = pushNotificationComments[index];
        if (_pushNotificationComments.userComment != null)
          return Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                    ReadMore.readMore(_pushNotificationComments.fromUser),
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
                                      _pushNotificationComments.formattedCommentDate(),
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
                        Text(
                          'Comments',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ReadMore.readMore(
                          _pushNotificationComments.userComment.toString(),
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



