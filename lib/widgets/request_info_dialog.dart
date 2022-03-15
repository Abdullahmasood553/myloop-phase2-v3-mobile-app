import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information.dart';
import 'package:loop_hr/utils/style.dart';

import '../models/push_notification.dart';
import '../models/push_notification_participants.dart';
import '../repositories/push_notification_repository.dart';
import '../utils/constants.dart';


class RequestInfoDialog extends StatefulWidget {
  final PushNotification pushNotification;
  RequestInfoDialog({Key? key, required this.pushNotification}) : super(key: key);

  @override
  _RequestInfoDialogState createState() => _RequestInfoDialogState();
}

class _RequestInfoDialogState extends State<RequestInfoDialog> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<PushNotificationParticipants> _notificationParticipants = List.empty(growable: true);
  Map<String, dynamic> _requestBody = {};
  PushNotificationParticipants? _selectedParticipant;

  String? value;

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
        // widget.onChanged(_selectedParticipant);
      });
    }
  }

  void validate() {
    if (_formKey.currentState!.validate()) {
      _requestBody['oidNotification'] = widget.pushNotification.oid.toString();
      if (!widget.pushNotification.isQuestion) {
        _requestBody['action'] = QUESTION;
      } else {
        _requestBody['action'] = ANSWER;
        _requestBody['moreInfoRole'] = null;
      }
      _formKey.currentState!.save();
      BlocProvider.of<NotificationInformationBloc>(context).add(CreateInformationRequest(_requestBody, widget.pushNotification.itemKey));

      Navigator.pop(context);
    } else {
      print("Not Validated");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Request Information'),
      content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: !widget.pushNotification.isQuestion,
                child: ParticipantDropdown(
                  pushNotification: widget.pushNotification,
                  onChanged: (value) {
                    _requestBody['moreInfoRole'] = value != null ? value.recipientRole : null;
                  },
                ),
              ),
              TextFormField(
                autocorrect: false,
                autofocus: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _requestBody['comment'] = newValue?.trim();
                },
                cursorColor: Style.primaryColor,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Style.primaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Style.primaryColor),
                  ),
                  labelText: '',
                  contentPadding: EdgeInsets.only(
                    left: 5,
                    bottom: 5,
                    top: 5,
                    right: 5,
                  ),
                ),
              ),
            ],
          )),
      /* Here add your custom widget  */
      actions: <Widget>[
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  child: Text(
                    'Submit',
                    style: Style.bodyText2.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Style.primaryColor,
                    onPrimary: Style.primaryColor,
                    elevation: 0,
                  ),
                  onPressed: validate,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: OutlinedButton(
                  child: Text(
                    'Cancel',
                    style: Style.bodyText2.copyWith(color: Colors.black),
                  ),
                  onPressed: () => Navigator.pop(context, null),
                ),
              ),
            )
          ],
        ),
      ],
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
