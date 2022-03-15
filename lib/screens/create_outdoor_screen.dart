import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/outdoor-duty/outdoor.dart';
import 'package:loop_hr/models/city.dart';
import 'package:loop_hr/models/ta_da_lookups.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/repositories/city_repository.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/repositories/ta_da_lookups_repository.dart';
import 'package:loop_hr/utils/constants.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';
import 'package:loop_hr/widgets/adaptive_date_time_field.dart';
import 'package:loop_hr/widgets/leave_request_footer.dart';

class OutdoorDutyCreateScreen extends StatefulWidget {
  @override
  _OutdoorDutyCreateState createState() => _OutdoorDutyCreateState();
}

class _OutdoorDutyCreateState extends State<OutdoorDutyCreateScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final CreateOutDoor createOutDoor;
  Map<String, dynamic> _requestBody = {'attendanceTypeId': 3063};

  late final User _user;
  List<TADALookups> _tada = List.empty(growable: true);
  List<City> _city = List.empty(growable: true);

  @override
  void initState() {
    super.initState();
    _user = RepositoryProvider.of<LoginRepository>(context).getLoggedInUser!;
    _loadMasterData();
  }

  void _loadMasterData() async {
    _tada = await context.read<TADALookupsRepository>().findAllTADALookups();
    _city = await context.read<CityRepository>().findAllCity();
  }

  void validate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      int startDate = _requestBody['dateStart'];
      int endDate = _requestBody['dateEnd'];
      if (startDate < endDate) {
        context.loaderOverlay.show();
        BlocProvider.of<OutDoorBloc>(context).add(CreateOutDoor(_requestBody));
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
              'Create Outdoor Duty',
              centerTitle: true,
            ),
            body: LoaderOverlay(
              overlayWidget: ActivityIndicator(),
              child: SingleChildScrollView(
                child: BlocListener<OutDoorBloc, OutDoorState>(
                  listener: (context, state) {
                    if (state is CreateOutDoorSuccess) {
                      context.loaderOverlay.hide();
                      SystemUtil.buildSuccessSnackbar(context, state.message);
                      Navigator.pop(context, true);
                    } else if (state is CreateOutDoorError) {
                      context.loaderOverlay.hide();
                      SystemUtil.buildErrorSnackbar(context, state.message);
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
                              AdaptiveDateTimeField(
                                title: 'From Date',
                                validator: (value) => value == null ? 'From date is required' : null,
                                onSaved: (DateTime? value) {
                                  if (value != null) {
                                    _requestBody['dateStart'] = value.millisecondsSinceEpoch;
                                    _requestBody['timeStart'] = DateUtil.defaultTimeFormat.format(value);
                                  }
                                },
                              ),
                              AdaptiveDateTimeField(
                                title: 'To Date',
                                onSaved: (DateTime? value) {
                                  if (value != null) {
                                    _requestBody['dateEnd'] = value.millisecondsSinceEpoch;
                                    _requestBody['timeEnd'] = DateUtil.defaultTimeFormat.format(value);
                                  }
                                },
                                validator: (value) => value == null ? 'To date is required' : null,
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: DropdownSearch<City>(
                                  mode: Mode.BOTTOM_SHEET,
                                  showSelectedItems: true,
                                  popupSafeArea: PopupSafeAreaProps(bottom: true),
                                  scrollbarProps: ScrollbarProps(
                                    isAlwaysShown: true,
                                    thickness: 7,
                                  ),
                                  showClearButton: true,
                                  itemAsString: (item) => item!.name,
                                  compareFn: (item, selectedItem) => item?.oid == selectedItem?.oid,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "From City",
                                  ),
                                  onFind: (String? filter) async {
                                    try {
                                      return _city;
                                    } catch (e) {
                                      return _city;
                                    }
                                  },
                                  onChanged: (value) {
                                    _requestBody['fromCity'] = value != null ? value.oid : null;
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
                              ),
                              SizedBox(height: 10),
                              Container(
                                child: DropdownSearch<City>(
                                  mode: Mode.BOTTOM_SHEET,
                                  showSelectedItems: true,
                                  popupSafeArea: PopupSafeAreaProps(bottom: true),
                                  scrollbarProps: ScrollbarProps(
                                    isAlwaysShown: true,
                                    thickness: 7,
                                  ),
                                  showClearButton: true,
                                  itemAsString: (item) => item!.name,
                                  compareFn: (item, selectedItem) => item?.oid == selectedItem?.oid,
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: "To City",
                                  ),
                                  onFind: (String? filter) async {
                                    try {
                                      return _city;
                                    } catch (e) {
                                      return _city;
                                    }
                                  },
                                  onChanged: (value) {
                                    _requestBody['toCity'] = value != null ? value.oid : null;
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
                              ),
                              if (_user.reimbursementFlag)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                      child: DropdownSearch<TADALookups>(
                                        mode: Mode.BOTTOM_SHEET,
                                        showSelectedItems: true,
                                        showClearButton: true,
                                        itemAsString: (item) => item!.flexValue,
                                        compareFn: (item, selectedItem) => item?.flexValue == selectedItem?.flexValue,
                                        dropdownSearchDecoration: InputDecoration(
                                          labelText: "Reimbursement Type",
                                        ),
                                        onFind: (String? filter) async {
                                          try {
                                            return _tada.where((e) => e.flexValueSetName == IL_TADA_TYPE).toList();
                                          } catch (e) {
                                            return _tada.where((e) => e.flexValueSetName == IL_TADA_TYPE).toList();
                                          }
                                        },
                                        onChanged: (value) {
                                          _requestBody['reimbursementType'] = value != null ? value.flexValue : null;
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
                                    ),
                                  ],
                                ),
                              if (_user.claimFlag)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                        child: DropdownSearch<TADALookups>(
                                      mode: Mode.BOTTOM_SHEET,
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      itemAsString: (item) => item!.flexValue,
                                      compareFn: (item, selectedItem) => item?.flexValue == selectedItem?.flexValue,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Claim Type",
                                      ),
                                      onFind: (String? filter) async {
                                        try {
                                          return _tada.where((e) => e.flexValueSetName == IL_TADA_CLAIM).toList();
                                        } catch (e) {
                                          return _tada.where((e) => e.flexValueSetName == IL_TADA_CLAIM).toList();
                                        }
                                      },
                                      onChanged: (value) {
                                        _requestBody['claimType'] = value != null ? value.flexValue : null;
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
                                    )),
                                  ],
                                ),
                              if (_user.taxiFlag)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Taxi Charges (E1~E4)',
                                        alignLabelWithHint: true,
                                      ),
                                      onSaved: (String? value) {
                                        _requestBody['taxiCharges'] = value;
                                      },
                                    )),
                                  ],
                                ),
                              if (_user.nightStayFlag)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    DropdownSearch<TADALookups>(
                                      mode: Mode.BOTTOM_SHEET,
                                      showSelectedItems: true,
                                      showClearButton: true,
                                      itemAsString: (item) => item!.flexValue,
                                      compareFn: (item, selectedItem) => item?.flexValue == selectedItem?.flexValue,
                                      dropdownSearchDecoration: InputDecoration(
                                        labelText: "Night Stay Arrangement",
                                      ),
                                      onFind: (String? filter) async {
                                        try {
                                          return _tada.where((e) => e.flexValueSetName == IL_TADA_NIGHT_STAY).toList();
                                        } catch (e) {
                                          return _tada.where((e) => e.flexValueSetName == IL_TADA_NIGHT_STAY).toList();
                                        }
                                      },
                                      onChanged: (value) {
                                        _requestBody['nightStayArrangement'] = value != null ? value.flexValue : null;
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
                                    )
                                  ],
                                ),
                              if (_user.travellingAmountFlag)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Travelling Amount (Grade M2)	',
                                        alignLabelWithHint: true,
                                      ),
                                      onSaved: (String? value) {
                                        _requestBody['travellingAmount'] = value;
                                      },
                                    )),
                                  ],
                                ),
                              if (_user.diningAmountFlag)
                                Column(
                                  children: [
                                    SizedBox(height: 10),
                                    Container(
                                        child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Dining Amount (Grade M2)	',
                                        alignLabelWithHint: true,
                                      ),
                                      onSaved: (String? value) {
                                        _requestBody['diningAmount'] = value;
                                      },
                                    )),
                                  ],
                                ),
                              SizedBox(height: 10),
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
