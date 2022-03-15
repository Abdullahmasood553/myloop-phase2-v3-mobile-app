import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/login-bloc/login.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _requestBody = {};

  void validate() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      BlocProvider.of<LoginBloc>(context).add(CreateOTP(_requestBody));
      // context.loaderOverlay.show();
      print(_requestBody);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        SystemUtil.hideKeyboard();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: ActivityIndicator(),
          ),
          overlayOpacity: 0.8,
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                child: SvgPicture.asset(
                  welcomeScreenSvgIcon,
                  semanticsLabel: 'dashboard',
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: BlocListener<LoginBloc, LoginState>(
                    listener: (context, state) {
                      if (state is OTPSuccess) {
                        context.loaderOverlay.hide();
                        Navigator.pushNamed(context, otpScreenRoute, arguments: state.otp);
                      } else if (state is OTPError) {
                        context.loaderOverlay.hide();
                        SystemUtil.buildErrorSnackbar(context, state.response);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            '\n Easy to use \n your HR Application',
                            // style: boldTextStyle(size: 25),
                            style: Style.headline5.copyWith(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.0,
                          ),
                          SizedBox(height: 25),
                          Text(
                            'Sign in to your account',
                            style: Style.bodyText1,
                            textScaleFactor: 1.0,
                          ),
                          SizedBox(height: 25),
                          Form(
                            key: _formKey,
                            child: Container(
                              width: size.width,
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    child: TextFormField(
                                      cursorColor: Style.textSecondaryColor.withOpacity(0.2),
                                      cursorWidth: 1,
                                      autocorrect: true,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(
                                          RegExp(r"\d+([\.]\d+)?"),
                                        ),
                                      ],
                                      onSaved: (value) {
                                        _requestBody['employeeCode'] = value;
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Employee code is required';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Employee Code',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                            width: 1.5,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.only(left: 16, bottom: 16, top: 16, right: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Container(
                                    height: 55,
                                    child: IntlPhoneField(
                                      initialCountryCode: 'PK',
                                      countries: ['PK', 'LK'],
                                      flagsButtonPadding: EdgeInsets.only(left: 16, top: 3),
                                      showDropdownIcon: false,
                                      cursorColor: Style.textSecondaryColor.withOpacity(0.2),
                                      cursorWidth: 1,
                                      disableLengthCheck: true,
                                      autovalidateMode: AutovalidateMode.onUserInteraction,
                                      onChanged: (phone) {},
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Theme.of(context).primaryColor,
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      onSaved: (phone) {
                                        // _requestBody['phoneNumber'] = phone?.completeNumber.replaceFirst("0", "");
                                        _requestBody['phoneNumber'] = phone?.completeNumber;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              validate();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              elevation: 0.0,
                              fixedSize: Size.fromWidth(double.maxFinite),
                              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                            ),
                            child: Text("Login",
                                style: Style.bodyText1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
