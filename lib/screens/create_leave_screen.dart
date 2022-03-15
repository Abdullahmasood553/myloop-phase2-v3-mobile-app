import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/time-log-bloc/time_log.dart';
import 'package:loop_hr/models/attendance_type.dart';
import 'package:loop_hr/repositories/attendance_type_repository.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/adaptive_date_field.dart';
import 'package:loop_hr/widgets/leave_request_footer.dart';

class AbsenceFormScreen extends StatefulWidget {
  @override
  _AbsenceFormScreenState createState() => _AbsenceFormScreenState();
}

class _AbsenceFormScreenState extends State<AbsenceFormScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _requestBody = {};

  void validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int startDate = _requestBody['dateStart'];
      int endDate = _requestBody['dateEnd'];
      if (startDate <= endDate) {
        context.loaderOverlay.show();
        BlocProvider.of<TimeLogBloc>(context).add(CreateLeaveRequest(_requestBody));
      } else {
        SystemUtil.buildErrorSnackbar(context, 'End date cannot be before start date.');
      }
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
      child: WillPopScope(
        onWillPop: () async {
          return SystemUtil.showFormDismissDialog(context);
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AdaptiveAppBar(
              null,
              'Create Leave Request',
              centerTitle: true,
            ),
            body: LoaderOverlay(
              overlayWidget: ActivityIndicator(),
              child: SingleChildScrollView(
                child: BlocListener<TimeLogBloc, TimeLogState>(
                  listener: (context, state) {
                    if (state is LeaveRequestSuccess) {
                      context.loaderOverlay.hide();
                      SystemUtil.buildSuccessSnackbar(
                        context,
                        state.message,
                      );
                      Navigator.pop(context, true);
                    } else if (state is LeaveRequestError) {
                      context.loaderOverlay.hide();
                      SystemUtil.buildErrorSnackbar(
                        context,
                        state.message,
                      );
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      Container(
                        decoration: boxDecorations(showShadow: true),
                        padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                        margin: EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              DropdownSearch<AttendanceType>(
                                mode: Mode.BOTTOM_SHEET,
                                showSelectedItems: true,
                                popupSafeArea: PopupSafeAreaProps(bottom: true),
                                scrollbarProps: ScrollbarProps(
                                  isAlwaysShown: true,
                                  thickness: 7,
                                ),
                                itemAsString: (item) => item!.typeName,
                                compareFn: (item, selectedItem) => item?.oid == selectedItem?.oid,
                                validator: (value) => value == null ? 'Leave type is required' : null,
                                dropdownSearchDecoration: InputDecoration(
                                  labelText: "Leave Type",
                                ),
                                onFind: (String? filter) async {
                                  List<AttendanceType> _attendanceType = List.empty(growable: true);
                                  try {
                                    _attendanceType = await context.read<AttendanceTypeRepository>().findAllAttendanceType();
                                  } catch (e) {
                                    return _attendanceType;
                                  }
                                  return _attendanceType;
                                },
                                onChanged: (value) {
                                  _requestBody['attendanceTypeId'] = value!.oid;
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
                              ),
                              AdaptiveDateField(
                                title: 'From Date',
                                onSaved: (DateTime? value) {
                                  if (value != null) {
                                    _requestBody['dateStart'] = value.millisecondsSinceEpoch;
                                  }
                                },
                                validator: (value) => value == null ? 'From date is required.' : null,
                              ),
                              AdaptiveDateField(
                                title: 'To Date',
                                onSaved: (DateTime? value) {
                                  if (value != null) {
                                    _requestBody['dateEnd'] = value.millisecondsSinceEpoch;
                                  }
                                },
                                validator: (value) => value == null ? 'To date is required.' : null,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Comments/Reason',
                                  alignLabelWithHint: true,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Comment is required";
                                  } else {
                                    return null;
                                  }
                                },
                                onSaved: (String? value) {
                                  _requestBody['comments'] = value;
                                },
                                maxLines: 2,
                                maxLength: 1000,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            persistentFooterButtons: <Widget>[
              LeaveRequestFooter(onSubmit: validate),
            ],
          ),
        ),
      ),
    );
  }
}
