import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loop_hr/blocs/time-log-bloc/time_log.dart';
import 'package:loop_hr/models/attendance.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/adaptive_date_field.dart';
import 'package:loop_hr/widgets/error_widget.dart';

class TimeLogScreen extends StatefulWidget {
  @override
  _TimeLogScreenState createState() => _TimeLogScreenState();
}

class _TimeLogScreenState extends State<TimeLogScreen> {
  int _pageNo = 0;
  DateTime? selectedDate;
  DateTime? toDate;

  final PagingController<int, Attendance> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(
      (pageKey) {
        if (selectedDate != null) {
          toDate = null;
        }
        BlocProvider.of<TimeLogBloc>(context).add(
          FetchTimeLogEvent(selectedDate, toDate),
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
        'Attendance',
        centerTitle: true,
      ),
      body: Container(
        child: BlocListener<TimeLogBloc, TimeLogState>(
          listener: (context, state) {
            if (state is TimeLogLoaded) {
              if (state.attendanceList.isEmpty) {
                _pagingController.appendLastPage(state.attendanceList);
              } else {
                _pageNo += 1;
                toDate = state.attendanceList.last.date;
                print(toDate);
                if (selectedDate == null) {
                  _pagingController.appendPage(state.attendanceList, _pageNo);
                } else {
                  _pagingController.appendLastPage(state.attendanceList);
                }
              }
            }
            if (state is TimeLogError) {
              _pagingController.error = state.message;
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
                      _pageNo = 0;
                      _pagingController.refresh();
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    child: PagedListView<int, Attendance>(
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<Attendance>(
                        firstPageProgressIndicatorBuilder: (context) =>
                            Center(child: ActivityIndicator()),
                        newPageProgressIndicatorBuilder: (context) =>
                            Center(child: Container()),
                        firstPageErrorIndicatorBuilder: (context) {
                          return MLErrorWidget(
                            title: _pagingController.error,
                            onPress: () => _pagingController.refresh(),
                          );
                        },
                        noItemsFoundIndicatorBuilder: (context) {
                          return Center(
                            child: Text('No attendance found'),
                          );
                        },
                        itemBuilder: (context, item, index) {
                          if (selectedDate != null) {
                            return BuildTimeLogList(attendance: item);
                          } else {
                            return BuildTimeLogListWithHeader(entity: item);
                          }
                        },
                      ),
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
    toDate = null;
    _pagingController.refresh();
  }
}

class BuildTimeLogListWithHeader extends StatelessWidget {
  final Attendance entity;

  const BuildTimeLogListWithHeader({required this.entity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.0, 16, 16.0, 0),
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Column(
        children: [
          Container(
            height: 40.0,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.centerLeft,
            child: Text(
              entity.formattedDate(),
              style: const TextStyle(color: Colors.black),
              textScaleFactor: 1.0,
            ),
          ),
          Row(
            children: [
              Expanded(child: BuildTimeLogList(attendance: entity)),
            ],
          ),
        ],
      ),
    );
  }
}

class BuildTimeLogList extends StatelessWidget {
  final Attendance attendance;

  BuildTimeLogList({Key? key, required this.attendance}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) => Divider(height: 1, thickness: .5),
      itemCount: attendance.getAttendanceDetailBeanList().length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        AttendanceDetailBean data =
            attendance.getAttendanceDetailBeanList()[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white30,
            child: _buildTileIcon(data.getIsHoliday),
          ),
          title: Column(
            children: [
              if (!data.getIsHoliday && index == 0)
                (Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "CheckIn",
                          style: Style.bodyText1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1.0,
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "CheckOut",
                          style: Style.bodyText1.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textScaleFactor: 1.0,
                        )),
                  ],
                )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      data.getIsHoliday ? data.holiday! : data.getTimeIn,
                      style: Style.bodyText1.copyWith(
                        fontWeight: FontWeight.normal,
                      ),
                      textScaleFactor: 1.0,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (data.getTimeOut != null)
                    Expanded(
                      flex: 1,
                      child: Text(
                        data.getTimeOut!,
                        style: Style.bodyText1.copyWith(
                          fontWeight: FontWeight.normal,
                        ),
                        textScaleFactor: 1.0,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget _buildTileIcon(bool isHoliday) {
  if (isHoliday) {
    return SvgPicture.asset(
      holidayIcon,
      width: 40,
      height: 40,
    );
  }
  return Image.asset(
    iconAttendance,
  );
}
