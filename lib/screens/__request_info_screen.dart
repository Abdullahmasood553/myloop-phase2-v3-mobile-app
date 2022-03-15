import 'dart:ui';

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

  void _refreshPage(context) {
    BlocProvider.of<PushNotificationBloc>(context).add(FetchPushNotificationComments(widget.argument.pushNotification.itemKey));
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
              if (state is CreateInformationRequestSuccess) {
                context.loaderOverlay.hide();
                SystemUtil.buildSuccessSnackbar(
                  context,
                  state.message,
                );
                // int count = 0;
                // Navigator.popUntil(context, (route) {
                //   return count++ == 2;
                // });
              } else if (state is CreateInformationRequestError) {
                context.loaderOverlay.hide();
                SystemUtil.buildErrorSnackbar(
                  context,
                  state.message,
                );
              }
            },
            child: RefreshIndicator(
              onRefresh: () => Future.sync(() {
                _refreshPage(context);
              }),
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
                          if (state is PushNotificationCommentsLoaded) {
                            if (state.pushNotificationComments.isEmpty) {
                              return Center(
                                child: Text('Comments not found'),
                              );
                            }
                            return BuildNotificationCommentList(
                              pushNotificationComments: state.pushNotificationComments,
                              argument: widget.argument,
                            );
                          }
                          if (state is PushNotificationCommentsError) {
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
  final List<PushNotificationComments> pushNotificationComments;

  final PushNotificationArgument argument;
  const BuildNotificationCommentList({Key? key, required this.pushNotificationComments, required this.argument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pushNotificationComments.length,
      shrinkWrap: true,
      padding: EdgeInsets.all(16),
      itemBuilder: (context, index) {
        PushNotificationComments _pushNotificationComments = pushNotificationComments[index];
        if (_pushNotificationComments.userComment != null)
          return Column(
            children: [
              _pushNotificationComments.fromUser != argument.pushNotification.senderName
                  ? LeftHandMessage(
                      pushNotificationComments: _pushNotificationComments,
                      argument: argument,
                      index: index
                    )
                  : RightHandMessage(
                      pushNotificationComments: _pushNotificationComments,
                    )
            ],
          );
        return SizedBox();
      },
    );
  }
}

class RightHandMessage extends StatelessWidget {
  final PushNotificationComments pushNotificationComments;
  const RightHandMessage({required this.pushNotificationComments});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(15),
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              color: Style.primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                bottomLeft: Radius.circular(19),
                bottomRight: Radius.circular(19),
              ),
            ),
            child: Column(children: [
              Text(
                pushNotificationComments.userComment.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ]),
          ),
        ),
      ],
    );
  }
}

class LeftHandMessage extends StatelessWidget {
  final PushNotificationComments pushNotificationComments;
  final PushNotificationArgument argument;
  final int? index;
  const LeftHandMessage({required this.pushNotificationComments, required this.argument,this.index});
  

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(19),
              bottomLeft: Radius.circular(19),
              bottomRight: Radius.circular(19),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(argument.pushNotification.isQuestion)
              Visibility(
                visible: index == 1,
                child: Text(
                  pushNotificationComments.fromUser,
                  textScaleFactor: 1.0,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              ),
              Text(
                pushNotificationComments.userComment.toString(),
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
