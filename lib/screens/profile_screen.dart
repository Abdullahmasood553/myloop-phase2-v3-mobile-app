import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/authentication-bloc/authentication.dart';
import 'package:loop_hr/blocs/leave-balance-bloc/leave_balance.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/logout_dialog.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<LeaveBalanceBloc>(context).add(LeaveBalanceFetch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Style.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              if (Platform.isIOS) {
                showCupertinoDialog(context: context, builder: (_) => LogoutDialog());
              } else {
                showDialog(context: context, builder: (_) => LogoutDialog());
              }
            },
            icon: Image.asset(iconLogout),
          ),
        ],
      ),
      body: _buildBody(),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildBody() {
    return LoaderOverlay(
      child: SingleChildScrollView(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state is AuthenticationAuthenticated) {
              return Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(bottom: 16),
                    color: Style.primaryColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          height: 100,
                          width: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: FadeInImage(
                              fit: BoxFit.cover,
                              placeholder: AssetImage(loadingIcon),
                              imageErrorBuilder: (context, error, stackTrace) {
                                return CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    avatarIcon,
                                  ),
                                );
                              },
                              image: Image.network(
                                '${ApiUtil.profileImageEndPoint}/${state.user.employeeNumber}',
                                height: 40,
                                width: 10,
                                color: Style.primaryColor,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    avatarIcon,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ).image,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            '${state.user.fullName}',
                            textScaleFactor: 1.0,
                            style: Style.bodyText1.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            '${state.user.positionTitle}',
                            textScaleFactor: 1.0,
                            style: Style.bodyText2.copyWith(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 13, right: 13, top: 16),
                    child: Column(
                      children: [
                        Container(
                          decoration: boxDecorations(showShadow: true),
                          padding: EdgeInsets.all(16.0),
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                _buildEmployeeDetail('Grade', state.user.grade),
                                SizedBox(height: 5),
                                Container(
                                  child: state.user.email != null
                                      ? _buildEmployeeDetail(
                                          'Email',
                                          state.user.email.toString(),
                                        )
                                      : Container(),
                                ),
                                SizedBox(height: 5),
                                Container(
                                  child: state.user.supervisorName != null
                                      ? _buildEmployeeDetail(
                                          'Supervisor Name',
                                          state.user.supervisorName.toString(),
                                        )
                                      : Container(),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<LeaveBalanceBloc, LeaveBalanceState>(
                    builder: (context, state) {
                      if (state is LeaveBalanceLoaded) {
                        return Container(
                          margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Personal Leaves',
                                textScaleFactor: 1.0,
                                style: Style.bodyText1.copyWith(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 16),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  children: [
                                    _buildEmployeeDetail(
                                      'Entitle',
                                      state.data.personalEntitle.toString(),
                                    ),
                                    SizedBox(height: 5),
                                    _buildEmployeeDetail(
                                      'Consumed',
                                      state.data.personalConsumed.toString(),
                                    ),
                                    Divider(thickness: .5),
                                    _buildEmployeeDetail(
                                      'Balance',
                                      state.data.personalBalance.toString(),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Annual Leaves',
                                textScaleFactor: 1.0,
                                style: Style.bodyText1.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 16),
                                child: Column(
                                  children: [
                                    _buildEmployeeDetail(
                                      'Entitle',
                                      state.data.annualEntitle.toString(),
                                    ),
                                    SizedBox(height: 5),
                                    _buildEmployeeDetail(
                                      'Consumed',
                                      state.data.annualConsumed.toString(),
                                    ),
                                    Divider(thickness: .5),
                                    _buildEmployeeDetail(
                                      'Balance',
                                      state.data.annualBalance.toString(),
                                    ),
                                    SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox();
                    },
                  )
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildEmployeeDetail(String? key, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            key!,
            textScaleFactor: 1.0,
            textAlign: TextAlign.left,
            style: Style.bodyText2.copyWith(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value!,
            textScaleFactor: 1.0,
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        )
      ],
    );
  }
}
