import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loop_hr/blocs/absence-bloc/absence.dart';
import 'package:loop_hr/models/absence.dart';
import 'package:loop_hr/screens/create_leave_screen.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/adaptive_date_field.dart';
import 'package:loop_hr/widgets/custom_chip.dart';
import 'package:loop_hr/widgets/error_widget.dart';
import 'package:loop_hr/widgets/leave_request_dialog.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';


import '../utils/read_more.dart';

class AbsenceListScreen extends StatefulWidget {
  final int status;

  const AbsenceListScreen({Key? key, this.status = 1}) : super(key: key);

  @override
  _AbsenceListScreenState createState() => _AbsenceListScreenState();
}

class _AbsenceListScreenState extends State<AbsenceListScreen> {
  int _pageNo = 0;
  DateTime? selectedDate;

  final PagingController<int, Absence> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) {
        BlocProvider.of<AbsenceBloc>(context).add(FetchAbsenceEvent(false, pageKey, selectedDate, widget.status));
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
        'Leave Request',
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
            onRefresh: () => Future.sync(
              () {
                _refreshPage();
              },
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                  ),
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
                      itemBuilder: (context, item, index) {
                        return _buildAbsenceListItem(item);
                      },
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
                          child: Text(
                            'No absence found',
                          ),
                        );
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

  Widget _buildAbsenceButton() {
    if (Platform.isIOS) {
      return CupertinoButton(
        child: Image.asset(
          iconAdd,
          height: 30,
          width: 30,
        ),
        onPressed: _showCreateModalBottomSheet,
        padding: EdgeInsets.zero,
      );
    }
    return IconButton(
      icon: Image.asset(
        iconAdd,
        height: 30,
        width: 30,
      ),
      onPressed: _showCreateModalBottomSheet,
    );
  }

  Future<void> _showCreateModalBottomSheet() async {
    bool? result = await showBarModalBottomSheet(
      expand: true,
      isDismissible: true,
      context: context,
      builder: (context) => AbsenceFormScreen(),
    );
    if (result != null && result == true) {
      _refreshPage();
    }
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

  Widget _buildAbsenceListItem(Absence absence) {
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
            Text(
              absence.absenceType,
              maxLines: 2,
              style: Style.bodyText1.copyWith(
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
              textScaleFactor: 1.0,
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'Start Date:',
                              textScaleFactor: 1.0,
                              style: Style.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 11,
                            child: Text(
                              absence.formattedStartDate(),
                              textScaleFactor: 1.0,
                              style: Style.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Text(
                              'End Date:',
                              textScaleFactor: 1.0,
                              style: Style.bodyText2.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 11,
                            child: Text(
                              absence.formattedEndDate(),
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
                Visibility(
                  visible: widget.status == 1,
                  child: CustomChip(
                    absence.getStatus!,
                    color: absence.status == 'Approved' ? Colors.green : Colors.orangeAccent,
                  ),
                ),
              ],
            ),
            if (absence.comments != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(color: Colors.grey),
                  Text(
                    "Comment",
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ReadMore.readMore(
                    absence.comments!,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
