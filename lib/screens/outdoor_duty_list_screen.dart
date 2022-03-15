import 'dart:io';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loop_hr/blocs/absence-bloc/absence.dart';
import 'package:loop_hr/models/absence.dart';
import 'package:loop_hr/screens/create_outdoor_screen.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/adaptive_date_field.dart';
import 'package:loop_hr/widgets/custom_chip.dart';
import 'package:loop_hr/widgets/error_widget.dart';
import 'package:loop_hr/widgets/leave_request_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../utils/read_more.dart';

class OutdoorDutyListScreen extends StatefulWidget {
  final int status;
  const OutdoorDutyListScreen({Key? key, this.status = 1}) : super(key: key);

  @override
  _OutdoorDutyListScreenState createState() => _OutdoorDutyListScreenState();
}

class _OutdoorDutyListScreenState extends State<OutdoorDutyListScreen> {
  int _pageNo = 0;
  DateTime? selectedDate;
  final PagingController<int, Absence> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<AbsenceBloc>(context).add(
          FetchAbsenceEvent(true, pageKey, selectedDate, widget.status),
        );
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        'Outdoor Duty',
        centerTitle: true,
        actions: [
          _buildAbsenceButton(),
        ],
      ),
      body: Container(
        child: BlocListener<AbsenceBloc, AbsenceState>(
          listener: (context, state) {
            if (state is AbsenceLoaded) {
              if (state.absence.isEmpty) {
                _pagingController.appendLastPage(state.absence);
              } else {
                _pageNo += 1;
                _pagingController.appendPage(state.absence, _pageNo);
              }
            }

            if (state is AbsenceError) {
              _pagingController.error = state.message;
            }

            if (state is CancelLeaveRequestSuccess) {
              _refreshPage();
              SystemUtil.buildSuccessSnackbar(context, state.message);
            } else if (state is CancelLeaveRequestError) {
              SystemUtil.buildErrorSnackbar(context, state.message);
            }
          },
          child: RefreshIndicator(
            onRefresh: () => Future.sync(() {
              _refreshPage();
            }),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16),
                  child: AdaptiveDateField(
                    title: 'Date',
                    showPrefix: true,
                    onChanged: (value) {
                      selectedDate = value;
                      _refreshPage();
                    },
                  ),
                ),
                Expanded(
                  child: PagedListView(
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<Absence>(
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
                          child: Text('No outdoor duty found'),
                        );
                      },
                      itemBuilder: (context, item, index) {
                        return _buildOutDoorListItem(item);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _refreshPage() {
    _pageNo = 0;
    _pagingController.refresh();
  }

  void _settingModalBottomSheet(context, Absence absence) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.cancel_outlined),
              title: Text(
                'Cancel Leave Request',
                textScaleFactor: 1.0,
              ),
              onTap: () async {
                Navigator.pop(context);
                bool? result = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => LeaveRequestDialogAndroid(),
                );
                if (result != null && result) {
                  BlocProvider.of<AbsenceBloc>(context).add(CancelLeaveRequestEvent(absence));
                }
              },
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildAbsenceButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Image.asset(
          iconAdd,
          height: 30,
          width: 30,
        ),
        onPressed: () async {
          bool? result = await showBarModalBottomSheet(
            expand: true,
            isDismissible: true,
            context: context,
            builder: (context) => OutdoorDutyCreateScreen(),
          );
          if (result != null && result == true) {
            _refreshPage();
          }
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
      onPressed: () async {
        bool? result = await showBarModalBottomSheet(
          expand: true,
          isDismissible: true,
          context: context,
          builder: (context) => OutdoorDutyCreateScreen(),
        );
        if (result != null && result == true) {
          _refreshPage();
        }
      },
    );
  }

  Widget _buildOutDoorListItem(Absence absence) {
    return GestureDetector(
      onTap: () {
        if (absence.isCancelable) {
          _settingModalBottomSheet(context, absence);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ReadMore.readMore(
              absence.comments!,
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Date: ' + absence.formattedStartDate() + ' - ' + absence.formattedStartDate(),
                        textScaleFactor: 1.0,
                        style: Style.bodyText2.copyWith(
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Time: ' + absence.timeStart.toString() + " - " + absence.timeEnd.toString(),
                            textScaleFactor: 1.0,
                            style: Style.bodyText2.copyWith(
                              color: Colors.black87,
                            ),
                          ),
                          Visibility(
                            visible: widget.status == 1,
                            child: CustomChip(
                              absence.getStatus!,
                              color: absence.status == 'Approved' ? Colors.green : Colors.orangeAccent,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Visibility(
                //   visible: widget.status == 1,
                //   child: CustomChip(
                //     absence.getStatus!,
                //     color: absence.status == 'Approved' ? Colors.green : Colors.orangeAccent,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
